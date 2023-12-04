# -*- coding: utf-8 -*-
"""
Created on Sun Oct  1 23:11:14 2023

@author: joshua.s.ness@ndsu.edu
"""


import requests
import pandas as pd
from datetime import datetime
from dateutil.relativedelta import relativedelta
from azure.storage.blob import BlobServiceClient
import os
from io import BytesIO #Allows us to operate in memory and send a CSV to Azure without every using local storage
from azure.core.exceptions import AzureError
import sys
import logging
import re
import nfl_data_py as nfl #This is soley needed to make a player ID. See 'create_odds_id' method

logging.basicConfig(filename='nfl.log', filemode='a', format='%(asctime)s - %(levelname)s - %(message)s', level=logging.INFO)
logging.getLogger('azure.core.pipeline.policies.http_logging_policy').setLevel(logging.WARNING) #This prevents noisy audit style logs. I only want any errors here
logger = logging.getLogger('odds-api')

def get_season():
    '''
    This method will effectively return the current NFL season. Since it goes into Janurary & February while still being
    the previous years season, we can just return the year a set number of months ago. Since the season does not start until September,
    we can safely do four months ago
    '''
    today = datetime.today()
    season = today - relativedelta(months=4)
    return season.year

def get_upcoming_nfl_games(api_key): # 1 request
    '''
    Running this method returns a dataframe of upcoming NFL games and their ID's.
    This is needed to get player props for each individual game, by using the eventID associated with each game here.
    This also returns the game odds for who wins, which will be added in the future to our data.
    '''

    # Define the URL for the API request
    endpoint = f'https://api.the-odds-api.com/v4/sports/americanfootball_nfl/odds?apiKey={api_key}&regions=us&oddsFormat=american'

    try:
        # Make the API request
        response = requests.get(endpoint)
    
        # Check for a valid response
        if response.status_code == 200:
            # Parse the JSON response
            data = response.json()
            
            # Convert the JSON data to a pandas DataFrame
            df = pd.json_normalize(data)
            
            #convert commence time to datetime value in eastern time zone
           
            df['commence_time'] = pd.to_datetime(df['commence_time']).dt.tz_convert('US/Eastern').dt.tz_localize(None)
            
            return df
        else:
            logger.error(f'Failed to retrieve upcoming games. Status code: {response.status_code}, Response: {response.text}')
            return None
    except requests.RequestException as e:
        logger.error(f'Request failed: {str(e)}')
        return None
    except Exception as e:
        logger.error(f'An unexpected error occurred: {str(e)}')
        return None

def get_props_for_event(props, eventId, apiKey):
    '''
    Parameters
    ----------
    props : list
    List of all the props we wish to get data for
    eventId : str
    The game id we are getting data for
    apiKey : str
    Authorized API key
    Returns
    -------
    DataFrame
    Consists of a single row for a single event ID. This row contains a exhaustive JSON column to be flattened containing all the props information.  
    
    number of requests used (cost)  number of events * number of prop markets requested AND available for the event
    '''
        
    markets = ','.join(props) #Contains all the props in a single string to condense the request from n to 1
    
    # Constructing the endpoint URL
    endpoint = f'https://api.the-odds-api.com/v4/sports/americanfootball_nfl/events/{eventId}/odds?apiKey={apiKey}&regions=us&markets={markets}'
    try:
        # Making the API request
        response = requests.get(endpoint)
        
        # Checking for a valid response
        if response.status_code == 200:
            # Parsing the JSON response
            data = response.json()
            
            # Converting the JSON data to a pandas DataFrame
            df = pd.json_normalize(data)
            df['commence_time'] = pd.to_datetime(df['commence_time']).dt.tz_convert('US/Eastern').dt.tz_localize(None)
            return df
        else:
            logger.error(f'Failed to retrieve props for event ID: {eventId}. Status code: {response.status_code}, Response: {response.text}')
            return None
    except requests.RequestException as e:
        logger.error(f'Request failed for eventId {eventId}: {str(e)}')
        return None
    except Exception as e:
        logger.error(f'An unexpected error occurred during getting props for event ID {eventId}: {str(e)}')
        return None


def process_row(row):
    '''
    Flattens the JSON containing player props returned by the get_props_for_event method into many tabular rows.

    Parameters
    ----------
    row : DataFrame Row
        Likely passed via apply function on a whole DataFrame. 

    Returns
    -------
    results : DateFrame
        Flattened, tabular dataframe representing the passed row and all the associated props.

    '''
    # We need to save the data in the columns that don't need to be flattened, because we want to keep them also.
    event_id = row['id']
    commence_time = row['commence_time']
    away_team = row['away_team']
    home_team = row['home_team']
    refresh_time = row['refresh_time']
    
    # Process bookmakers JSON data
    results = []
    bookmakers = row['bookmakers']


    for bookmaker in bookmakers:
        bookmaker_key = bookmaker['key']
        bookmaker_title = bookmaker['title']
        for market in bookmaker['markets']:
            market_key = market['key']
            for outcome in market['outcomes']:
                results.append({
                    'Player Name': outcome['description'],
                    'Event ID': event_id,
                    'Commence Time': commence_time,
                    'Away Team': away_team,
                    'Home Team': home_team,
                    'Bookmaker Key': bookmaker_key,
                    'Bookmaker Title': bookmaker_title,
                    'Market Key': market_key,
                    'Outcome Name': outcome['name'],
                    'Price': outcome['price'],
                    'Point': outcome.get('point'),
                    'Refresh Time' : refresh_time
                })                
    return results

def get_current_props(api_key, prop_markets, current_season):
    '''
    Parameters
    ----------
    api_key : str
        Authorized API key

    Returns
    -------
    flattened_betting_data : DataFrame
        Finalized DataFrame containing all player props over games happening within the next 5 days, over the specified markets

    '''
    
    # Get dataframe of upcoming games:
    games_df = get_upcoming_nfl_games(api_key)
    
    #I only want to include games in the next 5 days (including current day). If no props are available yet, doesnt cost a request. 
    today = pd.Timestamp.now(tz='US/Eastern').normalize()
    
    end_date = today + pd.Timedelta(days=5)
    games_df = games_df[(games_df['commence_time'].dt.date >= today.date()) & (games_df['commence_time'].dt.date <= end_date.date())]                       
    game_ids = games_df['id'].unique().tolist()
    
    dfs = []
    # Iterate over each event ID
    for event_id in game_ids: 
        # Get the DataFrame for the current event ID
        df = get_props_for_event(prop_markets, event_id, api_key)
        
        # Append the DataFrame to the list (if df is not None)
        if df is not None:
            #add refresh time
            df['refresh_time'] = pd.Timestamp.now(tz='US/Eastern').tz_localize(None)
            dfs.append(df)
    
    # Concatenate all DataFrames into one
    props_df = pd.concat(dfs, ignore_index=True)
    # Use apply method for more efficient row-wise processing
    flattened_betting_data = props_df.apply(process_row, axis=1)
    
    # Convert the Series of lists to a single list
    flattened_betting_data = [item for sublist in flattened_betting_data for item in sublist]
    
    # Convert the list of dictionaries to a DataFrame
    flattened_betting_data = pd.DataFrame(flattened_betting_data)

    flattened_betting_data.drop_duplicates(inplace=True)
    #Add week information
    df = add_week_information(flattened_betting_data, current_season)
    #Abbreviate teams
    df = abbr_teams(df)
    #Create player IDs
    df = create_player_id(df, current_season)
    
    # flattened_betting_data = create_odds_id(flattened_betting_data, current_season)
    new_column_names = ['PlayerName', 'EventID', 'CommenceTime', 'AwayTeam', 'HomeTeam', 'BookmakerKey', 'BookmakerTitle',
                        'MarketKey', 'OutcomeName', 'Price', 'Point', 'RefreshTime', 'Week', 'Season', 'PlayerID']

    # Renaming the columns
    df.columns = new_column_names
    return df


def upload_file(df, season):
    '''
    Uploads a DataFrame to Azure as a timestamped CSV
    
    Parameters
    ----------
    df : DataFrame
        The data to be uploaded to Azure
    season : int
        Used to organize the files in a hierarchy
    '''
    try:
        connection_string = os.getenv('NFL_STORAGE')
        if not connection_string:
            logger.error('Application stopped: NFL_STORAGE environment variable is not set.')
            sys.exit('Error: The NFL_STORAGE environment variable is not set.')
        container_name = "odds-api"
        timestamp_str = datetime.now().strftime("%Y-%m-%d-%H-%M-%S")
        blob_name = f'player-props/{season}/NFL_data_{timestamp_str}.parquet'
        
        # Create a buffer
        with BytesIO() as buffer:
            # Save the DataFrame to the buffer in parquet format
            df.to_parquet(buffer, index=False)
            
            # Rewind the buffer's position to the start
            buffer.seek(0)
        
            # Create a blob client
            blob_service_client = BlobServiceClient.from_connection_string(connection_string)
            blob_client = blob_service_client.get_blob_client(container=container_name, blob=blob_name)
            
            # Upload the byte data of the CSV file
            blob_client.upload_blob(buffer, blob_type="BlockBlob", overwrite=True)
    except AzureError as ae:
        logger.error(f'Azure specific error occurred: {str(ae)}')
    return

def add_week_information(odds_df, season):
    odds_df['Commence Date'] = pd.to_datetime(odds_df['Commence Time']).dt.date
    # Importing the schedule and preparing it for merging
    schedule_df = nfl.import_schedules([season])
    schedule_df['gameday'] = pd.to_datetime(schedule_df['gameday']).dt.date
    schedule_df.drop_duplicates(subset=['gameday'], inplace=True)

    # Merging with schedule dataframe
    odds_df = pd.merge(odds_df, schedule_df[['gameday', 'week']], left_on='Commence Date', right_on='gameday', how='left')
    odds_df.drop(['gameday', 'Commence Date'], axis=1, inplace=True)
    odds_df['season'] = season
    return odds_df
    
def abbr_teams(odds_df):
    # Replacing team names with abbreviations using a dictionary
    team_abbreviations = get_team_abbreviations()
    odds_df.replace({'Home Team': team_abbreviations, 'Away Team': team_abbreviations}, inplace=True)
    return odds_df

def create_player_id(odds_df, season):
    # Creating player IDs in a vectorized way
    roster = nfl.import_seasonal_rosters([season])   
    #Regular expression for removing spaces, periods, hyphens, and other special characters
    regex_pattern = '[\s\.\-]+'
    odds_df['merged_name'] = odds_df['Player Name'].str.replace('Jr.', '')
    odds_df['merged_name'] = odds_df['merged_name'].apply(lambda x: re.sub(regex_pattern, '', x.lower()) if pd.notna(x) else x)
    roster['merged_name'] = roster['player_name'].apply(lambda x: re.sub(regex_pattern, '', x.lower()) if pd.notna(x) else x)
    merged_df = odds_df.merge(roster[['merged_name', 'player_id']], on='merged_name', how = 'left')
    merged_df.drop(['merged_name'], axis=1, inplace=True)
    return merged_df
    
def get_team_abbreviations():
    team_abbreviations = {
    "Arizona Cardinals": "ARI",
    "Atlanta Falcons": "ATL",
    "Baltimore Ravens": "BAL",
    "Buffalo Bills": "BUF",
    "Carolina Panthers": "CAR",
    "Chicago Bears": "CHI",
    "Cincinnati Bengals": "CIN",
    "Cleveland Browns": "CLE",
    "Dallas Cowboys": "DAL",
    "Denver Broncos": "DEN",
    "Detroit Lions": "DET",
    "Green Bay Packers": "GB",
    "Houston Texans": "HOU",
    "Indianapolis Colts": "IND",
    "Jacksonville Jaguars": "JAX",
    "Kansas City Chiefs": "KC",
    "Las Vegas Raiders":"LV",
    "Los Angeles Chargers": "LAC",
    "Los Angeles Rams": "LAR",
    "Miami Dolphins": "MIA",
    "Minnesota Vikings": "MIN",
    "New England Patriots": "NE",
    "New Orleans Saints": "NO",
    "New York Giants": "NYG",
    "New York Jets": "NYJ",
    "Oakland Raiders": "OAK",
    "Philadelphia Eagles": "PHI",
    "Pittsburgh Steelers": "PIT",
    "Seattle Seahawks": "SEA",
    "San Francisco 49ers": "SF",
    "Saint Louis Rams": "STL",
    "Tampa Bay Buccaneers": "TB",
    "Tennessee Titans": "TEN",
    "Washington Commanders": "WAS"
    }
    return team_abbreviations    

def main():
    current_season = get_season()
    api_key = os.getenv('ODDS_API_KEY')
    if not api_key:
        logger.error('Application stopped: ODDS_API_KEY environment variable is not set.')
        sys.exit('Error: The ODDS_API_KEY environment variable is not set.')
    
    prop_markets = ['player_pass_tds', 'player_pass_yds', 'player_pass_completions', 'player_pass_interceptions', 'player_rush_yds', 
                    'player_receptions', 'player_reception_yds', 'player_kicking_points', 'player_field_goals', 'player_anytime_td']
    
    df = get_current_props(api_key, prop_markets, current_season)
    upload_file(df, current_season)
    logger.info('All odds-api data ingested and uploaded successfully')

if __name__ == '__main__':
    main()

