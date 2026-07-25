# scheduler.py
# This script runs the scraper automatically on a schedule.
# Run this once and leave it running in the background —
# it will re-scrape the Meghalaya One website every night at midnight,
# detect changes, and update the database automatically.

import schedule
import time
import sys
import os
from datetime import datetime

# Allow importing from the backend folder
sys.path.append(os.path.join(os.path.dirname(__file__), "..", "backend"))
from database import get_connection


def log(message):
    """Print a timestamped log message."""
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    print(f"[{timestamp}] {message}")


def get_existing_schemes():
    """
    Returns a dictionary of all schemes currently in the database.
    Key: scheme name (uppercase)
    Value: dict of all fields we track
    """
    conn = get_connection()
    cursor = conn.cursor()

    cursor.execute("""
        SELECT s.name, s.description, s.apply_how,
               s.source_url, s.application_status, s.id,
               e.rule_value, d.document_name, b.benefit_value
        FROM schemes s
        LEFT JOIN scheme_eligibility e ON s.id = e.scheme_id
        LEFT JOIN scheme_documents d ON s.id = d.scheme_id
        LEFT JOIN scheme_benefits b ON s.id = b.scheme_id
        WHERE s.id != 1
        ORDER BY s.name;
    """)
    rows = cursor.fetchall()
    cursor.close()
    conn.close()

    existing = {}
    for row in rows:
        name = row[0].upper().strip()
        existing[name] = {
            "id": row[5],
            "description": row[1] or "",
            "apply_how": row[2] or "",
            "source_url": row[3] or "",
            "application_status": row[4] or "",
            "eligibility": row[6] or "",
            "documents": row[7] or "",
            "benefits": row[8] or ""
        }
    return existing


def detect_changes(old_data, new_data):
    """
    Compares old scheme data with newly scraped data.
    Returns a list of change descriptions.
    """
    changes = []

    fields_to_check = [
        ("description", "Description"),
        ("eligibility", "Eligibility"),
        ("documents", "Required Documents"),
        ("benefits", "Benefits"),
        ("apply_how", "Application Process"),
        ("application_status", "Application Status")
    ]

    for field, label in fields_to_check:
        old_val = (old_data.get(field) or "").strip()[:200]
        new_val = (new_data.get(field) or "").strip()[:200]
        if old_val != new_val:
            changes.append(f"{label} changed")

    return changes


def update_scheme_in_db(scheme_id, new_data, changes):
    """
    Updates a scheme's data in the database when changes are detected.
    """
    conn = get_connection()
    cursor = conn.cursor()

    try:
        # Update the main schemes table
        cursor.execute("""
            UPDATE schemes
            SET description = %s,
                apply_how = %s,
                source_url = %s,
                application_status = %s,
                last_updated = NOW()
            WHERE id = %s;
        """, (
            new_data["description"],
            new_data["apply_how"],
            new_data["source_url"],
            new_data["application_status"],
            scheme_id
        ))

        # Update eligibility
        if new_data.get("eligibility"):
            cursor.execute("DELETE FROM scheme_eligibility WHERE scheme_id = %s;", (scheme_id,))
            cursor.execute("""
                INSERT INTO scheme_eligibility (scheme_id, rule_type, rule_value)
                VALUES (%s, %s, %s);
            """, (scheme_id, "general", new_data["eligibility"]))

        # Update documents
        if new_data.get("documents"):
            cursor.execute("DELETE FROM scheme_documents WHERE scheme_id = %s;", (scheme_id,))
            cursor.execute("""
                INSERT INTO scheme_documents (scheme_id, document_name, is_mandatory)
                VALUES (%s, %s, %s);
            """, (scheme_id, new_data["documents"], True))

        # Update benefits
        if new_data.get("benefits"):
            cursor.execute("DELETE FROM scheme_benefits WHERE scheme_id = %s;", (scheme_id,))
            cursor.execute("""
                INSERT INTO scheme_benefits (scheme_id, benefit_type, benefit_value)
                VALUES (%s, %s, %s);
            """, (scheme_id, "general", new_data["benefits"]))

        # Log what changed
        cursor.execute("""
            INSERT INTO scrape_log (scheme_id, status, changes_found)
            VALUES (%s, %s, %s);
        """, (scheme_id, "updated", ", ".join(changes)))

        conn.commit()

    except Exception as e:
        conn.rollback()
        log(f"  ❌ Database update failed: {e}")
    finally:
        cursor.close()
        conn.close()


def run_update():
    """
    The main update function. This is what runs every night.
    1. Scrapes all current scheme data from the website
    2. Compares with what's in the database
    3. Updates anything that changed
    """
    log("=" * 50)
    log("🔄 Starting scheduled update...")

    try:
        # Import scraper functions
        from scraper import (
            go_to_scheme_list,
            extract_tab_text
        )
        from playwright.sync_api import sync_playwright
        from bs4 import BeautifulSoup

        # Get what we currently have in the database
        existing_schemes = get_existing_schemes()
        log(f"📊 Found {len(existing_schemes)} schemes in database")

        new_schemes_found = 0
        schemes_updated = 0
        schemes_unchanged = 0

        with sync_playwright() as p:
            browser = p.chromium.launch(headless=True)
            page = browser.new_page()

            go_to_scheme_list(page)
            scheme_count = page.locator("h4.brklimit1").count()
            log(f"🌐 Found {scheme_count} schemes on website")

            # Collect all names first
            all_names = []
            for i in range(scheme_count):
                name = page.locator("h4.brklimit1").nth(i).inner_text().strip()
                name = name.replace('\u00a0', ' ').replace('\u2019', "'")
                name = name.replace('\u00e6', "'")
                name = ' '.join(name.split())
                all_names.append(name)

            for i, scheme_name in enumerate(all_names):
                # Skip grievance
                if "grievance" in scheme_name.lower():
                    continue

                log(f"  Checking [{i+1}/{scheme_count}]: {scheme_name}")

                try:
                    go_to_scheme_list(page)
                    page.locator("h4.brklimit1").nth(i).click()
                    page.wait_for_timeout(3000)

                    source_url = page.url
                    html = page.content()
                    soup = BeautifulSoup(html, "lxml")

                    # Extract description
                    description = ""
                    desc_tag = soup.select_one("h4.font600.pb-3.mb-0")
                    if desc_tag:
                        next_p = desc_tag.find_next("p")
                        if next_p:
                            description = next_p.get_text(strip=True)

                    # Extract tabs
                    eligibility = extract_tab_text(soup, "tab02")
                    documents = extract_tab_text(soup, "tab03")
                    benefits = extract_tab_text(soup, "tab22")
                    apply_how = extract_tab_text(soup, "tab04")

                    # Check application status
                    application_status = "open"
                    try:
                        login_btn = page.locator("button:has-text('Login to Apply')")
                        if login_btn.count() > 0:
                            login_btn.first.click()
                            page.wait_for_timeout(1500)
                            if page.locator("text=All applications are closed").count() > 0:
                                application_status = "closed"
                            close_btn = page.locator("button.btn-close")
                            if close_btn.count() > 0:
                                close_btn.first.click()
                                page.wait_for_timeout(500)
                    except Exception:
                        application_status = "Status not available on official portal"

                    new_data = {
                        "description": description,
                        "apply_how": apply_how,
                        "source_url": source_url,
                        "application_status": application_status,
                        "eligibility": eligibility,
                        "documents": documents,
                        "benefits": benefits
                    }

                    name_key = scheme_name.upper().strip()

                    if name_key in existing_schemes:
                        # Scheme exists — check for changes
                        old_data = existing_schemes[name_key]
                        changes = detect_changes(old_data, new_data)

                        if changes:
                            log(f"  ✏️  Changes detected: {', '.join(changes)}")
                            update_scheme_in_db(old_data["id"], new_data, changes)
                            schemes_updated += 1
                        else:
                            log(f"  ✅ No changes")
                            schemes_unchanged += 1

                            # Log the check even when nothing changed
                            conn = get_connection()
                            cur = conn.cursor()
                            cur.execute("""
                                INSERT INTO scrape_log (scheme_id, status, changes_found)
                                VALUES (%s, %s, %s);
                            """, (old_data["id"], "checked", "no changes"))
                            conn.commit()
                            cur.close()
                            conn.close()
                    else:
                        # Brand new scheme — insert it
                        log(f"  🆕 New scheme found! Inserting...")
                        conn = get_connection()
                        cur = conn.cursor()
                        cur.execute("""
                            INSERT INTO schemes
                            (name, description, apply_how, source_url, application_status)
                            VALUES (%s, %s, %s, %s, %s)
                            RETURNING id;
                        """, (scheme_name, description, apply_how,
                              source_url, application_status))
                        new_id = cur.fetchone()[0]

                        if eligibility:
                            cur.execute("""
                                INSERT INTO scheme_eligibility
                                (scheme_id, rule_type, rule_value)
                                VALUES (%s, %s, %s);
                            """, (new_id, "general", eligibility))

                        if documents:
                            cur.execute("""
                                INSERT INTO scheme_documents
                                (scheme_id, document_name, is_mandatory)
                                VALUES (%s, %s, %s);
                            """, (new_id, documents, True))

                        if benefits:
                            cur.execute("""
                                INSERT INTO scheme_benefits
                                (scheme_id, benefit_type, benefit_value)
                                VALUES (%s, %s, %s);
                            """, (new_id, "general", benefits))

                        cur.execute("""
                            INSERT INTO scrape_log (scheme_id, status, changes_found)
                            VALUES (%s, %s, %s);
                        """, (new_id, "new", "newly added scheme"))

                        conn.commit()
                        cur.close()
                        conn.close()
                        new_schemes_found += 1

                except Exception as e:
                    log(f"  ❌ Error processing scheme: {e}")
                    continue

            browser.close()

        log("─" * 50)
        log(f"✅ Update complete!")
        log(f"   New schemes found:    {new_schemes_found}")
        log(f"   Schemes updated:      {schemes_updated}")
        log(f"   Schemes unchanged:    {schemes_unchanged}")
        log("=" * 50)

    except Exception as e:
        log(f"❌ Scheduler run failed: {e}")


# ─── Schedule setup ───
def start_scheduler():
    log("🕐 Scheduler started.")
    log("   Will run update every day at midnight.")
    log("   Running first update now to verify everything works...")
    log("   Press Ctrl+C to stop.")
    log("")

    # Run once immediately when you start the scheduler
    run_update()

    # Then schedule it to run every day at midnight
    schedule.every().day.at("00:00").do(run_update)

    # Also useful alternatives — uncomment if you prefer:
    # schedule.every(12).hours.do(run_update)  # Every 12 hours
    # schedule.every().monday.at("06:00").do(run_update)  # Every Monday at 6am

    while True:
        schedule.run_pending()
        time.sleep(60)  # Check every minute if any scheduled job is due


if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description="Meghalaya Scheme Auto-Updater")
    parser.add_argument(
        "--now",
        action="store_true",
        help="Run the update immediately once, then exit (don't start the scheduler)"
    )
    args = parser.parse_args()

    if args.now:
        # Just run once and exit — useful for manual testing
        log("Running one-time update (--now flag detected)...")
        run_update()
    else:
        # Start the full scheduler
        start_scheduler()