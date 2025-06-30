import os
import pyodbc
import logging
import psycopg2
from dotenv import load_dotenv

# Load environment variables once when module is imported
load_dotenv()

logger = logging.getLogger('nfl-data-py')

def insert_query_generator(table, columns):
    column_list = ', '.join(columns)
    placeholders = ', '.join(['%s' for _ in columns])
    return f"INSERT INTO {table} ({column_list}) VALUES ({placeholders})"

def upload_to_sql(df, table_name):
    try:
        conn = psycopg2.connect(
            dbname=os.getenv("DB_NAME"),
            user=os.getenv("DB_USER"),
            password=os.getenv("DB_PASSWORD"),
            host=os.getenv("DB_HOST"),
            port=os.getenv("DB_PORT")
        )

        cursor = conn.cursor()
        query = insert_query_generator(table_name, df.columns)
        cursor.executemany(query, df.values.tolist())
        conn.commit()
        cursor.close()
        conn.close()

        logger.info(f"✅ Uploaded to {table_name}")

    except Exception as e:
        logger.error(f"Error uploading to {table_name}: {e}")
        raise