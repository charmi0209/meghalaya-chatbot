# database.py
# This file handles the connection between Python and PostgreSQL.
# Think of it as the phone line between your code and your database.

import psycopg2          # The library that talks to PostgreSQL
import os                # Lets Python read environment variables
from dotenv import load_dotenv  # Reads your .env file

# Load the secret values from the .env file
load_dotenv()

def get_connection():
    """
    This function creates and returns a connection to the database.
    Call this function whenever you need to talk to the database.
    """
    connection = psycopg2.connect(
        host=os.getenv("DB_HOST"),       # Where the database lives (your computer)
        port=os.getenv("DB_PORT"),       # The door number (5432 is PostgreSQL's default)
        dbname=os.getenv("DB_NAME"),     # Which database to open
        user=os.getenv("DB_USER"),       # Your database username
        password=os.getenv("DB_PASSWORD") # Your database password
    )
    return connection

def test_connection():
    """
    This function checks if Python can successfully reach PostgreSQL.
    Run this to verify everything is working.
    """
    try:
        conn = get_connection()          # Try to connect
        cursor = conn.cursor()           # A cursor is like a pen that writes/reads data
        cursor.execute("SELECT version();")  # Ask PostgreSQL for its version number
        version = cursor.fetchone()      # Fetch the result
        print("✅ Database connected successfully!")
        print(f"   PostgreSQL version: {version[0]}")
        cursor.close()
        conn.close()
    except Exception as error:
        print(f"❌ Connection failed: {error}")

# This block runs only when you directly run this file
# It will NOT run when other files import this file
if __name__ == "__main__":
    test_connection()