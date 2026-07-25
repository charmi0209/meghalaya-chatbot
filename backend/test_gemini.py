# test_gemini.py
# Testing Gemini using the NEW Interactions API syntax (as of mid-2026)

import os
from dotenv import load_dotenv
from google import genai

load_dotenv()

# In the new SDK, the client automatically reads GEMINI_API_KEY from the environment
client = genai.Client()

interaction = client.interactions.create(
    model="gemini-3.5-flash",
    input="Say hello in one short sentence."
)

print("✅ Gemini responded:")
print(interaction.output_text)