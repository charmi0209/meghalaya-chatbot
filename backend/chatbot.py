# chatbot.py
# Core chatbot logic with:
# - Keyword matching (fast, no AI needed for clear questions)
# - AI fallback matching (Gemini picks the scheme when keywords fail)
# - Scheme recommendation (match user profile against all schemes)
# - Rate limit retry logic (waits and retries on 429 errors)

import os
import json
import time
from dotenv import load_dotenv
from google import genai
from database import get_connection

load_dotenv()
client = genai.Client()


# ─── Trim helper ───
def trim(text, limit=800):
    if not text:
        return "Not specified."
    return text[:limit] + "..." if len(text) > limit else text


# ─── Gemini call with automatic retry on rate limit ───
def gemini_call(prompt, max_retries=3):
    """
    Calls Gemini with automatic retry when rate limited (429 error).
    Waits the time Gemini suggests before retrying.
    """
    for attempt in range(1, max_retries + 1):
        try:
            response = client.interactions.create(
                model="gemini-2.5-flash",
                input=prompt
            )
            return response.output_text
        except Exception as e:
            error_str = str(e)
            if "429" in error_str or "quota" in error_str.lower() or "rate" in error_str.lower():
                if attempt < max_retries:
                    # Extract wait time from error message if available
                    wait_time = 60  # default wait
                    import re
                    match = re.search(r'retry in (\d+)', error_str)
                    if match:
                        wait_time = int(match.group(1)) + 5  # add 5s buffer
                    print(f"Rate limited. Waiting {wait_time}s before retry {attempt}/{max_retries}...")
                    time.sleep(wait_time)
                else:
                    raise Exception(f"Rate limit exceeded after {max_retries} retries. Please wait a minute and try again.")
            else:
                raise e
    return ""


# ─── Step 1: keyword matching ───
def find_matching_scheme_by_keywords(question, all_schemes):
    """
    Fast keyword-based scheme matching.
    Returns (scheme_id, name, source_url) or (None, None, None).
    """
    stopwords = {
        "scheme", "meghalaya", "chief", "minister", "ministers",
        "the", "development", "and", "tell", "about", "what", "who",
        "how", "does", "this", "that", "for", "can", "you", "me",
        "government", "help", "available", "apply", "applying",
        "want", "need", "know", "get", "give", "please"
    }

    question_lower = question.lower()
    best_match = (None, None, None)
    best_score = 0

    for scheme_id, name, source_url in all_schemes:
        name_words = [w.strip(",.()'") for w in name.lower().split()]
        meaningful_words = [w for w in name_words if len(w) > 3 and w not in stopwords]

        score = 0
        for word in meaningful_words:
            if word in question_lower:
                # Double weight for distinctive short words like SEED, FOCUS
                if len(word) <= 6:
                    score += 2
                else:
                    score += 1

        if score > best_score:
            best_score = score
            best_match = (scheme_id, name, source_url)

    if best_score == 0:
        return (None, None, None)

    return best_match


# ─── Step 2: AI fallback matching ───
def find_matching_scheme_by_ai(question, all_schemes):
    """
    When keyword matching fails, ask Gemini which scheme best fits the question.
    """
    scheme_list = "\n".join(
        f"{i+1}. {name}" for i, (_, name, _) in enumerate(all_schemes)
    )

    prompt = f"""You are helping match a user's question to the most relevant government scheme.

Available schemes:
{scheme_list}

User question: {question}

Reply with ONLY the number of the most relevant scheme (e.g. "3").
If no scheme is relevant, reply with "0".
Do not explain. Just the number."""

    try:
        text = gemini_call(prompt)
        choice = text.strip()
        index = int(choice) - 1
        if 0 <= index < len(all_schemes):
            return all_schemes[index]
    except Exception:
        pass

    return (None, None, None)


# ─── Combined matching ───
def find_matching_scheme(question, cursor):
    cursor.execute("SELECT id, name, source_url FROM schemes WHERE id != 1;")
    all_schemes = cursor.fetchall()

    result = find_matching_scheme_by_keywords(question, all_schemes)

    if result[0] is None:
        result = find_matching_scheme_by_ai(question, all_schemes)

    return result


# ─── Get full scheme data ───
def get_full_scheme_data(scheme_id, cursor):
    cursor.execute("""
        SELECT name, description, apply_how, source_url, application_status
        FROM schemes WHERE id = %s;
    """, (scheme_id,))
    name, description, apply_how, source_url, application_status = cursor.fetchone()

    cursor.execute("SELECT rule_value FROM scheme_eligibility WHERE scheme_id = %s;", (scheme_id,))
    eligibility_rows = cursor.fetchall()
    eligibility = "\n".join(row[0] for row in eligibility_rows) if eligibility_rows else "Not specified."

    cursor.execute("SELECT document_name FROM scheme_documents WHERE scheme_id = %s;", (scheme_id,))
    document_rows = cursor.fetchall()
    documents = "\n".join(row[0] for row in document_rows) if document_rows else "Not specified."

    cursor.execute("SELECT benefit_value FROM scheme_benefits WHERE scheme_id = %s;", (scheme_id,))
    benefit_rows = cursor.fetchall()
    benefits = "\n".join(row[0] for row in benefit_rows) if benefit_rows else "Not specified."

    return {
        "name": name,
        "description": description,
        "apply_how": apply_how,
        "eligibility": eligibility,
        "documents": documents,
        "benefits": benefits,
        "source_url": source_url,
        "application_status": application_status
    }


# ─── Main chatbot function ───
def ask_chatbot(question):
    conn = get_connection()
    cursor = conn.cursor()

    scheme_id, scheme_name, source_url = find_matching_scheme(question, cursor)

    if scheme_id is None:
        cursor.close()
        conn.close()
        return "I couldn't find a matching scheme for your question. Try asking about a specific scheme like 'homestay', 'green taxi', 'goat farming', or 'PRIME SEED'.\n\n📌 Source: https://meghalayaone.gov.in/meghalaya-one/all-scheme"

    scheme_data = get_full_scheme_data(scheme_id, cursor)
    cursor.close()
    conn.close()

    prompt = f"""You are a helpful government scheme assistant for Meghalaya, India.
Answer ONLY using the data below. Be concise and clear. Use simple language.
Never guess or add information not in the data.
If asked about deadlines, only report the Application Status shown below — never invent dates.

SCHEME: {scheme_data['name']}
DESCRIPTION: {trim(scheme_data['description'], 300)}
ELIGIBILITY: {trim(scheme_data['eligibility'], 800)}
DOCUMENTS: {trim(scheme_data['documents'], 600)}
BENEFITS: {trim(scheme_data['benefits'], 600)}
HOW TO APPLY: {trim(scheme_data['apply_how'], 600)}
STATUS: {scheme_data['application_status']}

QUESTION: {question}

Give a direct, well-structured answer using bullet points where helpful."""

    answer = gemini_call(prompt)
    return f"{answer}\n\n📌 Source: {scheme_data['source_url']}"


# ─── Scheme recommendation ───
def recommend_schemes(user_profile):
    """
    Takes a user profile dict and returns a list of matching schemes.
    """
    conn = get_connection()
    cursor = conn.cursor()

    cursor.execute("""
        SELECT s.id, s.name, s.description, s.source_url,
               e.rule_value
        FROM schemes s
        LEFT JOIN scheme_eligibility e ON s.id = e.scheme_id
        WHERE s.id != 1
        ORDER BY s.name;
    """)
    rows = cursor.fetchall()
    cursor.close()
    conn.close()

    schemes_text = ""
    for scheme_id, name, description, source_url, eligibility in rows:
        schemes_text += f"\nScheme: {name}\n"
        schemes_text += f"Description: {trim(description or '', 150)}\n"
        schemes_text += f"Eligibility: {trim(eligibility or '', 300)}\n"
        schemes_text += "---\n"

    profile_text = "\n".join(f"{k}: {v}" for k, v in user_profile.items())

    prompt = f"""You are a government scheme advisor for Meghalaya, India.
A citizen has provided their profile below. Based ONLY on the available schemes listed,
recommend the top 3 most relevant ones.

CITIZEN PROFILE:
{profile_text}

AVAILABLE SCHEMES:
{schemes_text}

Reply in this EXACT JSON format. No extra text, no markdown, no explanation:
{{"recommendations": [{{"name": "exact scheme name here", "reason": "one sentence why this matches"}}, {{"name": "exact scheme name here", "reason": "one sentence why this matches"}}, {{"name": "exact scheme name here", "reason": "one sentence why this matches"}}]}}"""

    try:
        raw = gemini_call(prompt).strip()

        # Remove markdown fences if present
        if "```" in raw:
            raw = raw.replace("```json", "").replace("```", "").strip()

        # Find JSON object boundaries
        start = raw.find("{")
        end = raw.rfind("}") + 1
        if start != -1 and end > start:
            raw = raw[start:end]

        data = json.loads(raw)
        return data.get("recommendations", [])

    except Exception as e:
        return []


if __name__ == "__main__":
    print("=== Test: Direct question ===")
    print(ask_chatbot("What documents do I need for the homestay scheme?"))

    print("\n=== Test: Recommendations ===")
    profile = {"occupation": "farmer", "interest": "dairy or livestock", "category": "general"}
    recs = recommend_schemes(profile)
    for r in recs:
        print(f"- {r['name']}: {r['reason']}")