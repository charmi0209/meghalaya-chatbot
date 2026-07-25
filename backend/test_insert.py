# test_insert.py
# This file inserts one fake scheme into the database to verify everything works.

from database import get_connection

def insert_test_scheme():
    conn = get_connection()
    cursor = conn.cursor()

    # Insert one scheme into the schemes table
    cursor.execute("""
        INSERT INTO schemes (name, description, apply_how, source_url)
        VALUES (%s, %s, %s, %s)
        RETURNING id;
    """, (
        "Chief Minister's Health Insurance Scheme",
        "Provides free medical treatment up to Rs. 5 lakhs per year to BPL families.",
        "Visit your nearest Common Service Centre with Aadhaar card and BPL certificate.",
        "https://meghalayaone.gov.in/meghalaya-one/all-scheme"
    ))

    # Get the ID of the scheme we just inserted
    scheme_id = cursor.fetchone()[0]
    print(f"✅ Test scheme inserted with ID: {scheme_id}")

    # Now read it back to confirm it was saved
    cursor.execute("SELECT name, description FROM schemes WHERE id = %s;", (scheme_id,))
    row = cursor.fetchone()
    print(f"✅ Successfully read back: {row[0]}")

    # Save the changes permanently
    conn.commit()

    cursor.close()
    conn.close()

if __name__ == "__main__":
    insert_test_scheme()