import psycopg2
import os
from dotenv import load_dotenv

load_dotenv()

with psycopg2.connect(
    dbname=os.getenv("DB_NAME"),
    user=os.getenv("DB_USER"),
    password=os.getenv("DB_PASSWORD"),
    host=os.getenv("DB_HOST"),
    port=os.getenv("DB_PORT")
) as conn:
    with conn.cursor() as cur:
        with open("staging_schema_postgres.sql", "r") as f:
            cur.execute(f.read())
        conn.commit()

print("Staging schema created in PostgreSQL.")