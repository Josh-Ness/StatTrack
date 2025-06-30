import psycopg2
import os
from dotenv import load_dotenv

load_dotenv()  # Load environment variables from .env

# Connect using env vars (update if yours are named differently)
conn = psycopg2.connect(
    dbname=os.getenv("DB_NAME"),
    user=os.getenv("DB_USER"),
    password=os.getenv("DB_PASSWORD"),
    host=os.getenv("DB_HOST"),
    port=os.getenv("DB_PORT")
)

def run_sql_script(file_path):
    with conn.cursor() as cur:
        with open(file_path, 'r') as f:
            sql = f.read()
        cur.execute(sql)
        conn.commit()
        print("✅ Star schema transformation and cleanup complete.")

run_sql_script("load_star_schema.sql")  # Adjust path if needed
conn.close()
