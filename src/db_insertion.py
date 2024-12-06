import os
import pyodbc
import logging

logger = logging.getLogger('nfl-data-py')

def insert_query_generator(table, columns):
    column_list = ', '.join(columns)
    placeholders = ', '.join(['?' for _ in columns])
    return f"INSERT INTO {table} ({column_list}) VALUES ({placeholders})"

def upload_to_sql(df, table_name):
    try:
        conn_str = os.environ["SQL_SPORTS_DEV_CON"]
        with pyodbc.connect(conn_str) as conn:
            cursor = conn.cursor()
            query = insert_query_generator(table_name, df.columns)
            cursor.fast_executemany = True
            cursor.executemany(query, df.values.tolist())
            conn.commit()
        logger.info(f"Data successfully uploaded to {table_name}")
    except Exception as e:
        logger.error(f"Error uploading to SQL table {table_name}: {e}")
        raise