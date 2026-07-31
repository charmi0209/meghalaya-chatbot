# chatbot.py
# Core chatbot logic with:
# - Keyword matching (fast, no AI needed for clear questions)
# - AI fallback matching (Gemini picks the scheme when keywords fail)
# - Smart recommendation routing (detects "suggest me" type questions)
# - Friendly, conversational responses like ChatGPT
# - Rate limit retry logic

import os
import json
import time
import re
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
                    wait_time = 60
                    match = re.search(r'retry in (\d+)', error_str)
                    if match:
                        wait_time = int(match.group(1)) + 5
                    print(f"Rate limited. Waiting {wait_time}s before retry {attempt}/{max_retries}...")
                    time.sleep(wait_time)
                else:
                    raise Exception(f"Rate limit exceeded after {max_retries} retries. Please wait a minute and try again.")
            else:
                raise e
    return ""


# ─── Detect if question is asking for recommendations ───
def is_recommendation_question(question):
    """
    Detects when someone is asking for suggestions/recommendations
    rather than asking about a specific scheme.
    """
    triggers = [
        "suggest", "recommend", "best scheme", "which scheme",
        "what scheme", "i am a", "i'm a", "i am an", "i'm an",
        "suitable for me", "good for me", "for my situation",
        "as a student", "as a farmer", "as a woman", "as a youth",
        "as a driver", "as an entrepreneur", "i work as",
        "what can i apply", "eligible for what", "which one should i",
        "what should i apply", "any scheme for me", "help me find",
        "looking for scheme", "schemes available for", "what schemes",
        "any schemes for", "schemes for students", "schemes for farmers",
        "schemes for women", "schemes for youth", "i need help with",
        "i want to start", "i am interested in", "i want to know",
        "what options do i have", "what are my options",
        "can you help me", "please suggest", "please recommend"
    ]
    q = question.lower()
    return any(trigger in q for trigger in triggers)


# ─── Step 1: keyword matching ───
def find_matching_scheme_by_keywords(question, all_schemes):
    stopwords = {
        "scheme", "meghalaya", "chief", "minister", "ministers",
        "the", "development", "and", "tell", "about", "what", "who",
        "how", "does", "this", "that", "for", "can", "you", "me",
        "government", "help", "available", "apply", "applying",
        "want", "need", "know", "get", "give", "please", "want",
        "information", "details", "more", "some", "any", "all"
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
    scheme_list = "\n".join(
        f"{i+1}. {name}" for i, (_, name, _) in enumerate(all_schemes)
    )

    prompt = f"""You are helping match a user's question to the most relevant government scheme.

Available schemes:
{scheme_list}

User question: {question}

Reply with ONLY the number of the most relevant scheme (e.g. "3").
If no scheme is relevant at all, reply with "0".
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


# ─── Handle recommendation/suggestion questions ───
def handle_recommendation_question(question):
    """
    Handles open-ended questions like:
    - "I am a student, suggest me the best scheme"
    - "What schemes are good for farmers?"
    - "Can you help me find a scheme for my situation?"
    
    Uses Gemini to extract the user's profile from their question,
    then runs the recommendation engine and gives a friendly response.
    """

    # Step 1: Extract user profile from their question
    extraction_prompt = f"""A citizen of Meghalaya asked this question:
"{question}"

Extract their profile. Only include fields you can clearly infer from the question.
Reply with ONLY this JSON, no extra text:
{{"occupation": "their job or role if mentioned, else empty string", "interest": "what they are interested in or want to do, else empty string", "category": "any category like student/farmer/woman/youth/BPL/PwD/entrepreneur, else empty string", "situation": "brief summary of their situation in 5 words"}}"""

    try:
        raw = gemini_call(extraction_prompt)
        raw = raw.strip().replace("```json", "").replace("```", "").strip()
        start = raw.find("{")
        end = raw.rfind("}") + 1
        profile = json.loads(raw[start:end])
        profile = {k: v for k, v in profile.items() if v and str(v).strip() and k != "situation"}
    except Exception:
        profile = {"interest": question[:150]}

    if not profile:
        profile = {"interest": question[:150]}

    # Step 2: Get scheme recommendations
    recommendations = recommend_schemes(profile)

    if not recommendations:
        return """Hey there! 👋 I'd love to help you find the right scheme!

Could you tell me a bit more about yourself? For example:

- **Who are you?** (student, farmer, taxi driver, entrepreneur, homemaker?)
- **What are you interested in?** (agriculture, tourism, transport, livestock, business?)
- **Any special category?** (BPL, woman entrepreneur, person with disability?)

You can also click the **🎯 Find schemes for me** button at the top — just fill in a few details and I'll instantly show you the best matching schemes!

📌 Source: https://meghalayaone.gov.in/meghalaya-one/all-scheme"""

    # Step 3: Build friendly, ChatGPT-style response
    profile_summary = ", ".join(f"{v}" for v in profile.values() if v)
    rec_details = "\n".join(
        f"Scheme {i+1}: {r['name']}\nWhy it suits them: {r['reason']}"
        for i, r in enumerate(recommendations)
    )

    friendly_prompt = f"""You are a warm, friendly, and knowledgeable government scheme advisor for Meghalaya, India.
You talk like a helpful friend — clear, encouraging, and easy to understand. Like ChatGPT.

A citizen asked: "{question}"
What we know about them: {profile_summary}

Based on their profile, the top recommended schemes are:
{rec_details}

Write a friendly, conversational response that:
1. Opens warmly — acknowledge who they are and that you understand their situation
2. Say something encouraging like "Great news!" or "You're in luck!" if schemes are available
3. For EACH recommended scheme:
   - Give the scheme name in bold
   - Explain in simple words WHY it's good for them specifically
   - Mention 1-2 key benefits they'd actually care about (money, training, support etc.)
   - Mention 1 thing to keep in mind (a pro or a practical tip)
4. End with an encouraging call to action — tell them to click the scheme in the sidebar or use the 🎯 button for more details
5. Keep the tone warm, human, and conversational — NOT formal or bureaucratic
6. Use emojis sparingly but naturally (1-2 per section maximum)
7. Keep total length reasonable — detailed but not overwhelming

IMPORTANT: Only mention details that are in the scheme data above. Do not invent benefits or eligibility rules."""

    final_answer = gemini_call(friendly_prompt)
    return f"{final_answer}\n\n📌 Source: https://meghalayaone.gov.in/meghalaya-one/all-scheme"


# ─── Scheme recommendation engine ───
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
{{"recommendations": [{{"name": "exact scheme name here", "reason": "one sentence why this matches their specific profile"}}, {{"name": "exact scheme name here", "reason": "one sentence why this matches their specific profile"}}, {{"name": "exact scheme name here", "reason": "one sentence why this matches their specific profile"}}]}}"""

    try:
        raw = gemini_call(prompt).strip()

        if "```" in raw:
            raw = raw.replace("```json", "").replace("```", "").strip()

        start = raw.find("{")
        end = raw.rfind("}") + 1
        if start != -1 and end > start:
            raw = raw[start:end]

        data = json.loads(raw)
        return data.get("recommendations", [])

    except Exception:
        return []


# ─── Main chatbot function ───
def ask_chatbot(question):
    # First check if this is a recommendation/suggestion type question
    if is_recommendation_question(question):
        return handle_recommendation_question(question)

    conn = get_connection()
    cursor = conn.cursor()

    scheme_id, scheme_name, source_url = find_matching_scheme(question, cursor)

    if scheme_id is None:
        cursor.close()
        conn.close()
        # Route to recommendations as a friendly fallback instead of cold error
        return handle_recommendation_question(question)

    scheme_data = get_full_scheme_data(scheme_id, cursor)
    cursor.close()
    conn.close()

    prompt = f"""You are a warm, helpful government scheme assistant for Meghalaya, India.
Answer the question below using ONLY the scheme data provided.
Be friendly and conversational — like a knowledgeable friend, not a government officer.
Use simple, clear language. Structure your answer with bullet points where helpful.
Never guess or add information not in the data.
If asked about deadlines, only report the Application Status shown — never invent dates.

SCHEME: {scheme_data['name']}
DESCRIPTION: {trim(scheme_data['description'], 300)}
ELIGIBILITY: {trim(scheme_data['eligibility'], 800)}
DOCUMENTS: {trim(scheme_data['documents'], 600)}
BENEFITS: {trim(scheme_data['benefits'], 600)}
HOW TO APPLY: {trim(scheme_data['apply_how'], 600)}
STATUS: {scheme_data['application_status']}

QUESTION: {question}

Answer in a friendly, helpful tone. Start with a brief direct answer, 
then give details with bullet points. End with a helpful tip or encouragement if relevant."""

    answer = gemini_call(prompt)
    return f"{answer}\n\n📌 Source: {scheme_data['source_url']}"


if __name__ == "__main__":
    print("=== Test 1: Specific scheme question ===")
    print(ask_chatbot("What documents do I need for the homestay scheme?"))

    print("\n=== Test 2: Student asking for recommendations ===")
    print(ask_chatbot("I am a student, suggest me the best scheme"))

    print("\n=== Test 3: Farmer looking for help ===")
    print(ask_chatbot("I am a farmer interested in goats, what schemes can help me?"))

    print("\n=== Test 4: Vague question ===")
    print(ask_chatbot("I want to start a small business, any government support?"))