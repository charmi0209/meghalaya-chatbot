# explore.py
# Step 1: open the page and click into "Scheme/ Services"
# Step 2: click on the FIRST scheme card to see what its detail page/popup looks like
# This tells us exactly how to extract eligibility, documents, benefits, etc.

from playwright.sync_api import sync_playwright

def explore_page():
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        page = browser.new_page()

        print("Opening the Meghalaya One homepage...")
        page.goto("https://meghalayaone.gov.in/meghalaya-one/all-scheme", timeout=60000)
        page.wait_for_timeout(3000)

        print("Clicking 'Scheme/ Services'...")
        page.click("text=Scheme/ Services")
        page.wait_for_timeout(4000)

        # Click on the FIRST scheme card (Chief Minister's Meghalaya Homestay Mission Scheme)
        print("Clicking the first scheme card...")
        page.click("h4.brklimit1 >> nth=0")

        # Wait for whatever happens next (modal, new page, side panel) to load
        page.wait_for_timeout(4000)

        # Save what we see now
        page.screenshot(path="scheme_detail_screenshot.png", full_page=True)
        print("✅ Screenshot saved as scheme_detail_screenshot.png")

        html_content = page.content()
        with open("scheme_detail.html", "w", encoding="utf-8") as f:
            f.write(html_content)
        print("✅ HTML saved as scheme_detail.html")

        # Also print the current URL — tells us if it navigated or just opened a popup
        print(f"Current URL: {page.url}")

        browser.close()

if __name__ == "__main__":
    explore_page()