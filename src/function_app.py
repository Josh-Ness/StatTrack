import azure.functions as func
import logging
import pyodbc
import os
import pandas as pd
import io
import requests

logging.basicConfig(filename='nfl.log', filemode='a', format='%(asctime)s - %(levelname)s - %(message)s', level=logging.INFO)
logging.getLogger('azure.core.pipeline.policies.http_logging_policy').setLevel(logging.WARNING) #This prevents noisy audit style logs. I only want any errors here
logger = logging.getLogger('nfl-data-py')

app = func.FunctionApp()
# nfl-data-py container
@app.blob_trigger(arg_name="myblob", path="nfl/{name}", connection="AzureWebJobsStorage") 
def NFLDataPyBlobTriggerFunction(myblob: func.InputStream):
    logging.info(f"Python blob trigger function processed blob")
    logging.info(f"Name: {myblob.name}")

    # SAS Token
    sas_token = os.environ["NFL_DATA"]

    # Construct the Blob URL with SAS Token
    storage_account_name = "stattrack"  
    blob_url = f"https://{storage_account_name}.blob.core.windows.net/{myblob.name}?{sas_token}"

    # Extract folder name from blob path and map it to SQL table names
    folder_name = myblob.name.split('/')[1]
    table_mappings = {
        'rosters': 'dbo.Player',
        'schedules': 'dbo.Game',
        'injuries': 'dbo.Injury',
        'pbp-stats': 'dbo.PlayByPlay'
    }
    target_table = table_mappings.get(folder_name)

    if not target_table:
        logging.error(f"No table mapping found for folder: {folder_name}")
        return

    # Database connection string
    conn_str = os.environ["SQL_SPORTS_DEV_CON"]

    # Process the blob and insert data into the database
    try:
        conn = pyodbc.connect(conn_str)
        cursor = conn.cursor()
        logging.info("Connected to SQL Server")

        # Read the blob into a DataFrame
        response = requests.get(blob_url)
        blob_data = io.BytesIO(response.content)  # Adjust this based on your blob's data format
        df = pd.read_parquet(blob_data)  # Or pd.read_parquet for Parquet files
        df = df.astype(object).where(df.notna(), None)

        # Use fast_executemany for efficient bulk insert
        cursor.fast_executemany = True

        # Prepare the data for insert
        tuples = [tuple(x) for x in df.to_numpy()]

        # Construct the insert query based on the target table
        insert_query = insert_query_generator(target_table, df.columns)
        cursor.executemany(insert_query, tuples)
        conn.commit()

        cursor.close()
        conn.close()

    except Exception as e:
        logging.error(f"Error connecting to SQL Server: {e}")
        raise


# odds-api container

@app.blob_trigger(arg_name="myblob", path="odds-api/{name}", connection="AzureWebJobsStorage") 
def OddsDataPyBlobTriggerFunction(myblob: func.InputStream):
    logging.info(f"Python blob trigger function processed blob")
    logging.info(f"Name: {myblob.name}")

    # SAS Token
    sas_token = os.environ["NFL_DATA"]

    # Construct the Blob URL with SAS Token
    storage_account_name = "nfl1" 
    blob_url = f"https://{storage_account_name}.blob.core.windows.net/{myblob.name}?{sas_token}"

    # Extract folder name from blob path and map it to SQL table names
    folder_name = myblob.name.split('/')[1]
    table_mappings = {
        'player-props':'dbo.PlayerProp'
    }
    target_table = table_mappings.get(folder_name)

    if not target_table:
        logging.error(f"No table mapping found for folder: {folder_name}")
        return

    # Database connection string
    conn_str = os.environ["SQL_SPORTS_DEV_CON"]

    # Process the blob and insert data into the database
    try:
        conn = pyodbc.connect(conn_str)
        cursor = conn.cursor()
        logging.info("Connected to SQL Server")

        # Read the blob into a DataFrame
        response = requests.get(blob_url)
        blob_data = io.BytesIO(response.content)  # Adjust this based on your blob's data format
        df = pd.read_parquet(blob_data)  # Or pd.read_parquet for Parquet files
        df = df.astype(object).where(df.notna(), None)

        # Use fast_executemany for efficient bulk insert
        cursor.fast_executemany = True

        # Prepare the data for insert
        tuples = [tuple(x) for x in df.to_numpy()]

        # Construct the insert query based on the target table
        insert_query = insert_query_generator(target_table, df.columns)
        cursor.executemany(insert_query, tuples)
        conn.commit()
        try:
            cursor.execute('EXEC LoadStarSchema')
            conn.commit()
        except:
            logging.warning('Procedure "LoadStarSchema" Failed, possibly due to foreign key restrain data not being populated yet. Ensure data is loaded, then call procedure.')
        cursor.close()
        conn.close()

    except Exception as e:
        logging.error(f"Error connecting to SQL Server: {e}")
        raise



def insert_query_generator(table, columns):
    """
    Generates an SQL insert query for the specified table and columns.
    """
    column_list = ', '.join(columns)
    placeholders = ', '.join(['?' for _ in columns])
    return f"INSERT INTO {table} ({column_list}) VALUES ({placeholders})"
