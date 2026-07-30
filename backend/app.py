# app.py
# Flask web server — bridge between HTML frontend and chatbot logic.

import os
from flask import Flask, request, jsonify
from flask_cors import CORS
from dotenv import load_dotenv
from chatbot import ask_chatbot, recommend_schemes
from database import get_connection

load_dotenv()

app = Flask(__name__)
CORS(app, origins=[
    "https://charmi0209.github.io",
    "http://localhost:5500",
    "http://localhost:5000",
    "http://127.0.0.1:5500"
])

# ─── Health check ───
@app.route("/health", methods=["GET"])
def health():
    return jsonify({
        "status": "ok",
        "message": "Meghalaya Scheme Chatbot API is running"
    })
@app.route("/", methods=["GET"])
def index():
    return jsonify({
        "name": "Meghalaya Scheme Chatbot API",
        "status": "running",
        "endpoints": {
            "health": "/health",
            "schemes": "/schemes",
            "chat": "POST /chat",
            "recommend": "POST /recommend",
            "logs": "/logs"
        }
    })

# ─── Get all schemes ───
@app.route("/schemes", methods=["GET"])
def get_schemes():
    try:
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute("""
            SELECT id, name, application_status
            FROM schemes
            WHERE id != 1
            ORDER BY name;
        """)
        rows = cursor.fetchall()
        cursor.close()
        conn.close()

        schemes = [
            {
                "id": row[0],
                "name": row[1].title(),
                "status": row[2]
            }
            for row in rows
        ]

        return jsonify({
            "success": True,
            "count": len(schemes),
            "schemes": schemes
        })

    except Exception as e:
        return jsonify({"success": False, "error": str(e)}), 500


# ─── Chat endpoint ───
@app.route("/chat", methods=["POST"])
def chat():
    data = request.get_json()

    if not data or "question" not in data:
        return jsonify({
            "success": False,
            "error": "Please provide a 'question' field in your request."
        }), 400

    question = data["question"].strip()

    if not question:
        return jsonify({
            "success": False,
            "error": "Question cannot be empty."
        }), 400

    if len(question) > 500:
        return jsonify({
            "success": False,
            "error": "Question is too long. Please keep it under 500 characters."
        }), 400

    try:
        full_answer = ask_chatbot(question)

        if "\n\n📌 Source: " in full_answer:
            parts = full_answer.split("\n\n📌 Source: ")
            answer_text = parts[0]
            source_url = parts[1].strip() if len(parts) > 1 else ""
        else:
            answer_text = full_answer
            source_url = "https://meghalayaone.gov.in/meghalaya-one/all-scheme"

        return jsonify({
            "success": True,
            "question": question,
            "answer": answer_text,
            "source": source_url
        })

    except Exception as e:
        error_msg = str(e)
        # Return a user-friendly message for rate limit errors
        if "429" in error_msg or "quota" in error_msg.lower():
            return jsonify({
                "success": False,
                "error": "The AI is temporarily busy. Please wait 60 seconds and try again."
            }), 429
        return jsonify({
            "success": False,
            "error": f"Something went wrong: {error_msg}"
        }), 500


# ─── Recommend endpoint ───
@app.route("/recommend", methods=["POST"])
def recommend():
    data = request.get_json()

    if not data:
        return jsonify({
            "success": False,
            "error": "Please provide profile information."
        }), 400

    profile = {}
    for field in ["occupation", "category", "interest", "age", "gender", "location"]:
        if field in data and str(data[field]).strip():
            profile[field] = str(data[field]).strip()

    if not profile:
        return jsonify({
            "success": False,
            "error": "Please provide at least one profile field."
        }), 400

    try:
        recommendations = recommend_schemes(profile)
        return jsonify({
            "success": True,
            "profile": profile,
            "recommendations": recommendations
        })

    except Exception as e:
        error_msg = str(e)
        if "429" in error_msg or "quota" in error_msg.lower():
            return jsonify({
                "success": False,
                "error": "The AI is temporarily busy. Please wait 60 seconds and try again."
            }), 429
        return jsonify({
            "success": False,
            "error": str(e)
        }), 500


# ─── Scrape logs ───
@app.route("/logs", methods=["GET"])
def get_logs():
    try:
        conn = get_connection()
        cursor = conn.cursor()
        cursor.execute("""
            SELECT s.name, l.scraped_at, l.status, l.changes_found
            FROM scrape_log l
            JOIN schemes s ON l.scheme_id = s.id
            ORDER BY l.scraped_at DESC
            LIMIT 50;
        """)
        rows = cursor.fetchall()
        cursor.close()
        conn.close()

        logs = [
            {
                "scheme": row[0].title(),
                "checked_at": row[1].strftime("%Y-%m-%d %H:%M:%S"),
                "status": row[2],
                "changes": row[3]
            }
            for row in rows
        ]

        return jsonify({"success": True, "count": len(logs), "logs": logs})

    except Exception as e:
        return jsonify({"success": False, "error": str(e)}), 500


if __name__ == "__main__":
    port = int(os.getenv("PORT", 5000))
    print(f"🚀 Starting Meghalaya Scheme Chatbot API on port {port}...")
    print(f"   Health check: http://localhost:{port}/health")
    print(f"   Schemes list: http://localhost:{port}/schemes")
    print(f"   Chat endpoint: POST http://localhost:{port}/chat")
    # debug=False in production for security
    # debug mode is only for local development
    is_production = os.getenv("RENDER", False)
    app.run(debug=not is_production, host="0.0.0.0", port=port)