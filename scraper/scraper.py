# scraper.py
# This is the REAL scraper. It:
# 1. Opens the Meghalaya One scheme list
# 2. Reads every scheme name from the cards
# 3. Clicks into each scheme one by one
# 4. Extracts: description, applicant category, benefits,
#    eligibility, documents, application process
# 5. Saves everything into PostgreSQL
# 6. Re-navigates fresh to the list and repeats for the next scheme

from playwright.sync_api import sync_playwright
from bs4 import BeautifulSoup
import sys
import os

sys.path.append(os.path.join(os.path.dirname(__file__), "..", "backend"))
from database import get_connection


def extract_tab_text(soup, tab_id):
    tab = soup.find(id=tab_id)
    if not tab:
        return ""
    return tab.get_text(separator="\n", strip=True)


def go_to_scheme_list(page):
    """
    Always returns to a fresh, reliable scheme list page.
    Used at the start and after every scheme (success or failure).
    """
    page.goto("https://meghalayaone.gov.in/meghalaya-one/all-scheme", timeout=60000)
    page.wait_for_timeout(3000)
    page.click("text=Scheme/ Services")
    page.wait_for_selector("h4.brklimit1", timeout=15000)
    page.wait_for_timeout(2000)


def scrape_all_schemes():
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        page = browser.new_page()

        print("Opening Meghalaya One homepage...")
        go_to_scheme_list(page)

        scheme_count = page.locator("h4.brklimit1").count()
        print(f"Found {scheme_count} schemes on the page.")

        # Get all scheme names first, before scraping any details
        # This way we know the full list even if we lose connection later
        all_scheme_names = []
        for i in range(scheme_count):
            scheme_name = page.locator("h4.brklimit1").nth(i).inner_text().strip()
            # Clean up special characters the website sometimes injects
            scheme_name = scheme_name.replace('\u00a0', ' ')  # non-breaking space → regular space
            scheme_name = scheme_name.replace('\u2019', "'")  # curly apostrophe → straight apostrophe
            scheme_name = scheme_name.replace('\u00e6', "'")  # Æ character → apostrophe
            scheme_name = ' '.join(scheme_name.split())       # collapse any double spaces
            all_scheme_names.append(scheme_name)
        print(f"Collected all {len(all_scheme_names)} scheme names.")

        conn = get_connection()
        cursor = conn.cursor()

        # Get names of schemes already in the database
        cursor.execute("SELECT name FROM schemes;")
        already_scraped = {row[0].upper() for row in cursor.fetchall()}
        print(f"Already in database: {len(already_scraped)} schemes.")

        for i, scheme_name in enumerate(all_scheme_names):
            # Skip schemes already successfully scraped
            if scheme_name.upper() in already_scraped:
                print(f"\n[{i+1}/{scheme_count}] Skipping (already scraped): {scheme_name}")
                continue

            # Skip grievance (not a real scheme)
            if "grievance" in scheme_name.lower():
                print(f"\n[{i+1}/{scheme_count}] Skipping (not a scheme): {scheme_name}")
                continue

            try:
                go_to_scheme_list(page)

                print(f"\n[{i+1}/{scheme_count}] Scraping: {scheme_name}")
                page.locator("h4.brklimit1").nth(i).click()
                page.wait_for_timeout(3000)

                source_url = page.url
                html = page.content()
                soup = BeautifulSoup(html, "lxml")

                description_tag = soup.select_one("h4.font600.pb-3.mb-0")
                description = ""
                if description_tag:
                    next_p = description_tag.find_next("p")
                    if next_p:
                        description = next_p.get_text(strip=True)

                applicant_category = extract_tab_text(soup, "tab01")
                benefits = extract_tab_text(soup, "tab22")
                eligibility = extract_tab_text(soup, "tab02")
                documents = extract_tab_text(soup, "tab03")
                application_process = extract_tab_text(soup, "tab04")

                # Check application status
                application_status = "open"
                try:
                    login_button = page.locator("button:has-text('Login to Apply')")
                    if login_button.count() > 0:
                        login_button.first.click()
                        page.wait_for_timeout(1500)
                        closed_modal = page.locator("text=All applications are closed")
                        if closed_modal.count() > 0:
                            application_status = "closed"
                        close_button = page.locator("button.btn-close")
                        if close_button.count() > 0:
                            close_button.first.click()
                            page.wait_for_timeout(500)
                except Exception:
                    application_status = "Status not available on official portal"

                cursor.execute("""
                    INSERT INTO schemes (name, description, apply_how, source_url, application_status)
                    VALUES (%s, %s, %s, %s, %s)
                    RETURNING id;
                """, (scheme_name, description, application_process, source_url, application_status))
                scheme_id = cursor.fetchone()[0]

                if eligibility:
                    cursor.execute("""
                        INSERT INTO scheme_eligibility (scheme_id, rule_type, rule_value)
                        VALUES (%s, %s, %s);
                    """, (scheme_id, "general", eligibility))

                if documents:
                    cursor.execute("""
                        INSERT INTO scheme_documents (scheme_id, document_name, is_mandatory)
                        VALUES (%s, %s, %s);
                    """, (scheme_id, documents, True))

                if benefits:
                    cursor.execute("""
                        INSERT INTO scheme_benefits (scheme_id, benefit_type, benefit_value)
                        VALUES (%s, %s, %s);
                    """, (scheme_id, "general", benefits))

                cursor.execute("""
                    INSERT INTO scrape_log (scheme_id, status, changes_found)
                    VALUES (%s, %s, %s);
                """, (scheme_id, "success", "initial scrape"))

                conn.commit()
                # Update already_scraped so we don't re-do it if we loop again
                already_scraped.add(scheme_name.upper())
                print(f"  ✅ Saved to database with ID {scheme_id}")

            except Exception as e:
                print(f"  ❌ Error scraping scheme #{i+1}: {e}")
                conn.rollback()
                continue

        cursor.close()
        conn.close()
        browser.close()
        print("\n✅ Scraping complete!")
        print(f"Total schemes in database now:")

if __name__ == "__main__":
    scrape_all_schemes()