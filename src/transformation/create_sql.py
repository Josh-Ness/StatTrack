from pathlib import Path


import os
import psycopg2
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Connect to PostgreSQL
conn = psycopg2.connect(
    dbname=os.getenv("DB_NAME"),
    user=os.getenv("DB_USER"),
    password=os.getenv("DB_PASSWORD"),
    host=os.getenv("DB_HOST"),
    port=os.getenv("DB_PORT")
)

def execute_sql_file(filename):
    with open(filename, "r") as file:
        sql = file.read().strip()

    if not sql:
        print(f"⚠️  Skipped {filename}: file was empty.")
        return

    with conn.cursor() as cur:
        statements = sql.split(";")
        for statement in statements:
            statement = statement.strip()
            if statement:
                cur.execute(statement)
        print(f"Executed: {filename}")

try:
    execute_sql_file("src/transformation/staging_schema.sql")
    execute_sql_file("src/transformation/star_schema.sql")
    conn.commit()
    print("All schema files executed successfully.")
except Exception as e:
    print(f"Error: {e}")
    conn.rollback()
finally:
    conn.close()