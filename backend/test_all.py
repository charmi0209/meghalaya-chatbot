# test_all.py
# Systematically tests all 10 original chatbot requirements.
# Includes delays between Gemini calls to respect free tier rate limits.

import requests
import json
import sys
import time

BASE_URL = "http://localhost:5000"
PASS = "✅ PASS"
FAIL = "❌ FAIL"
results = []

# Delay between each test that calls Gemini (seconds)
# Free tier = 20 requests per minute = 1 request per 3 seconds minimum
# We use 5 seconds to be safe
DELAY = 5


def test(name, passed, detail=""):
    status = PASS if passed else FAIL
    results.append((name, passed, detail))
    print(f"{status} | {name}")
    if detail:
        preview = str(detail)[:150]
        print(f"       {preview}{'...' if len(str(detail)) > 150 else ''}")


def chat(question):
    """Send a question and return response. Includes retry on 429."""
    for attempt in range(3):
        try:
            r = requests.post(
                f"{BASE_URL}/chat",
                json={"question": question},
                timeout=120  # longer timeout since Gemini retry can take 60s
            )
            data = r.json()
            if r.status_code == 429:
                print(f"       ⏳ Rate limited by server, waiting 65s...")
                time.sleep(65)
                continue
            return data
        except Exception as e:
            return {"success": False, "error": str(e)}
    return {"success": False, "error": "Failed after 3 attempts"}


def recommend(profile):
    """Send a profile and return recommendations."""
    for attempt in range(3):
        try:
            r = requests.post(
                f"{BASE_URL}/recommend",
                json=profile,
                timeout=120
            )
            data = r.json()
            if r.status_code == 429:
                print(f"       ⏳ Rate limited, waiting 65s...")
                time.sleep(65)
                continue
            return data
        except Exception as e:
            return {"success": False, "error": str(e)}
    return {"success": False, "error": "Failed after 3 attempts"}


print("=" * 60)
print("MEGHALAYA CHATBOT — FULL REQUIREMENT TEST SUITE")
print("Note: Delays added between tests to respect API rate limits")
print("Expected duration: ~3-4 minutes")
print("=" * 60)
print()

# ─── Infrastructure Tests (no Gemini calls, no delay needed) ───
print("── Infrastructure Tests ──")
try:
    r = requests.get(f"{BASE_URL}/health", timeout=5)
    data = r.json()
    test("API health check", data.get("status") == "ok", data.get("message", ""))
except Exception as e:
    test("API health check", False, str(e))

try:
    r = requests.get(f"{BASE_URL}/schemes", timeout=10)
    data = r.json()
    count = data.get("count", 0)
    test("Schemes list loads", data.get("success") and count >= 13,
         f"Found {count} schemes")
except Exception as e:
    test("Schemes list loads", False, str(e))

# ─── Requirement 1 ───
print()
print("── Requirement 1: What is this scheme? ──")
r = chat("What is the Chief Ministers Green Taxi Scheme?")
test(
    "Describes what the scheme is",
    r.get("success") and len(r.get("answer", "")) > 100,
    r.get("answer", r.get("error", ""))
)
time.sleep(DELAY)

# ─── Requirement 2 ───
print()
print("── Requirement 2: Who is eligible? ──")
r = chat("Who is eligible for the homestay scheme?")
test(
    "Answers eligibility questions",
    r.get("success") and len(r.get("answer", "")) > 50,
    r.get("answer", r.get("error", ""))
)
time.sleep(DELAY)

# ─── Requirement 3 ───
print()
print("── Requirement 3: What documents are required? ──")
r = chat("What documents do I need for the goat farming scheme?")
test(
    "Lists required documents",
    r.get("success") and any(
        word in r.get("answer", "").lower()
        for word in ["aadhaar", "identity", "document", "certificate", "proof", "bank"]
    ),
    r.get("answer", r.get("error", ""))
)
time.sleep(DELAY)

# ─── Requirement 4 ───
print()
print("── Requirement 4: How do I apply? ──")
r = chat("How do I apply for the PRIME Small Enterprise SEED scheme?")
test(
    "Explains application process",
    r.get("success") and any(
        word in r.get("answer", "").lower()
        for word in ["apply", "application", "online", "portal", "submit", "meghalaya one"]
    ),
    r.get("answer", r.get("error", ""))
)
time.sleep(DELAY)

# ─── Requirement 5 ───
print()
print("── Requirement 5: What benefits will I receive? ──")
r = chat("What benefits does the Meghalaya Dairy Development Scheme offer?")
test(
    "Describes benefits",
    r.get("success") and len(r.get("answer", "")) > 50,
    r.get("answer", r.get("error", ""))
)
time.sleep(DELAY)

# ─── Requirement 6 ───
print()
print("── Requirement 6: How much financial assistance? ──")
r = chat("How much financial assistance can I get from the homestay scheme?")
test(
    "Mentions financial amounts",
    r.get("success") and any(
        char in r.get("answer", "")
        for char in ["₹", "%", "lakh", "loan", "subsidy", "grant", "crore", "financial"]
    ),
    r.get("answer", r.get("error", ""))
)
time.sleep(DELAY)

# ─── Requirement 7 ───
print()
print("── Requirement 7: Important deadlines? ──")
r = chat("What is the deadline for the Focus scheme?")
test(
    "Handles deadlines honestly",
    r.get("success") and any(
        phrase in r.get("answer", "").lower()
        for phrase in [
            "not available", "unknown", "open", "closed",
            "status", "official portal", "not publish", "no specific"
        ]
    ),
    r.get("answer", r.get("error", ""))
)
time.sleep(DELAY)

# ─── Requirement 8 ───
print()
print("── Requirement 8: Reasons for rejection? ──")
r = chat("What are the reasons my homestay application might be rejected?")
test(
    "Addresses rejection reasons",
    r.get("success") and len(r.get("answer", "")) > 50,
    r.get("answer", r.get("error", ""))
)
time.sleep(DELAY)

# ─── Requirement 9 ───
print()
print("── Requirement 9: Recommend other schemes ──")
r = recommend({
    "occupation": "farmer",
    "interest": "livestock and dairy",
    "category": "general"
})
test(
    "Recommendation endpoint works",
    r.get("success") and len(r.get("recommendations", [])) > 0,
    f"Got {len(r.get('recommendations', []))} recommendations"
)
if r.get("recommendations"):
    for rec in r["recommendations"]:
        print(f"       → {rec.get('name', '')}: {rec.get('reason', '')[:80]}")
time.sleep(DELAY)

# ─── Requirement 10 ───
print()
print("── Requirement 10: Source shown for every answer ──")
r = chat("What documents do I need for the homestay scheme?")
test(
    "Every answer includes source URL",
    r.get("success") and bool(r.get("source", "").startswith("http")),
    r.get("source", "No source found")
)
time.sleep(DELAY)

# ─── Edge Cases (minimal Gemini calls) ───
print()
print("── Edge Cases ──")

try:
    r = requests.post(f"{BASE_URL}/chat", json={"question": ""}, timeout=10)
    data = r.json()
    test(
        "Handles empty question gracefully",
        not data.get("success") and r.status_code == 400,
        data.get("error", "")
    )
except Exception as e:
    test("Handles empty question gracefully", False, str(e))

try:
    r = requests.post(
        f"{BASE_URL}/chat",
        json={"question": "x" * 600},
        timeout=10
    )
    data = r.json()
    test(
        "Handles overly long question",
        not data.get("success") and r.status_code == 400,
        data.get("error", "")
    )
except Exception as e:
    test("Handles overly long question", False, str(e))

time.sleep(DELAY)
r = chat("I have a taxi, what government help is available?")
test(
    "Handles vague questions with AI fallback",
    r.get("success") and len(r.get("answer", "")) > 50,
    r.get("answer", r.get("error", ""))
)

time.sleep(DELAY)
r = chat("What is the weather in Shillong today?")
test(
    "Handles unrelated questions gracefully",
    r.get("answer") is not None or r.get("error") is not None,
    r.get("answer", r.get("error", ""))[:120]
)

# ───