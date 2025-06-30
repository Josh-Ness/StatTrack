import psycopg2
from psycopg2 import OperationalError

# Replace this with your actual password
password = "your_actual_password_here"

try:
    conn = psycopg2.connect(
        dbname="railway",
        user="postgres",
        password="FhWUCHEZdUQlzmPjpnMqhhcceIzpHsCb",
        host="shinkansen.proxy.rlwy.net",
        port=25151
    )
    print("✅ Success: Connected to Railway PostgreSQL!")
    conn.close()
except OperationalError as e:
    print("❌ Connection failed:")
    print(e)