# check_encoding.py
# Quick one-time check to confirm the database text is clean
# (the "á" you saw earlier was just a PowerShell display quirk)

from database import get_connection

conn = get_connection()
cur = conn.cursor()
cur.execute("SELECT name FROM schemes WHERE id = 3")
result = cur.fetchone()
print(result[0])
conn.close()
