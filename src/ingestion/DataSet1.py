# -*- coding: utf-8 -*-
"""
Created on Sat Sep 16 23:07:47 2023

@author: joshua.s.ness@ndsu.edu

This file provides methods and a main method to upload several data tables to Azure.
It is important to note, obtaining the most recent data for new games requires obtaining the 
data for the entire season. Hence, uploading just the new week would actually require more work, and I would never want to 
use a single weeks data for my business goal anyways. Therefore, I will upload the updated season data, overwriting the previous blob.
"""

import nfl_data_py as nfl
import pandas as pd
import sys
import re
from azure.storage.blob import BlobServiceClient
from io import BytesIO
from datetime import datetime
from dateutil.relativedelta import relativedelta
import os
from azure.core.exceptions import AzureError
import logging

logging.basicConfig(filename='nfl.log', filemode='a', format='%(asctime)s - %(levelname)s - %(message)s', level=logging.INFO)
logging.getLogger('azure.core.pipeline.policies.http_logging_policy').setLevel(logging.WARNING) #This prevents noisy audit style logs. I only want any errors here
logger = logging.getLogger('nfl-data-py')

def get_season():
    '''
    This method will effectively return the current NFL season. Since it goes into Janurary & February while still being
    the previous years season, we can just return the year a set number of months ago. Since the season does not start until September,
    we can safely do four months ago
    '''
    today = datetime.today()
    season = today - relativedelta(months=4)
    return season.year


def retrieve_player_stats(season_list):
    '''
    Takes in a list of season years, and returns a dataframe containing every player stats for every game in the given year(s).
    Given the current season, it will return all games that have happened so far.
    '''
    try:
        df = nfl.import_weekly_data(season_list)
        df.drop(columns=['headshot_url'], inplace=True) 
    except Exception as e:
        logger.error(f'Error retrieving player stats: {str(e)}')        
    return df

def retrieve_pbp_stats(season_list, week=-1):
    '''
    Takes in a list of season years, and returns a dataframe containing every single play from the season. From this, data will be able to be aggregated
    to get player stats
    '''
    try:
        full_pbp = nfl.import_pbp_data(season_list)
        if week == -1:
            week = full_pbp['week'].max()
        pbp = full_pbp.loc[full_pbp['week'] == week]
        fact_cols = ['game_id', 'play_id', 'qtr', 'complete_pass', 'incomplete_pass', 'passing_yards', 'pass_touchdown', 'interception',
                             'air_yards','sack', 'yards_after_catch', 'first_down_pass', 'rush_attempt', 'rushing_yards', 'rush_touchdown',
                             'first_down_rush', 'field_goal_attempt', 'extra_point_attempt', 'field_goal_result', 'extra_point_result', 'receiver_player_id',
                             'rusher_player_id', 'passer_player_id', 'kicker_player_id', 'stadium_id', 'week']
                                         
        df = pbp[fact_cols].copy()
        
        roster = nfl.import_seasonal_rosters(season_list)
        df = create_odds_ids(df, ['receiver_player_id', 'rusher_player_id', 'passer_player_id', 'kicker_player_id'], roster)
        
        #Return week as a formatted string
        if week<10:
            week = '0'+str(week)
        else:
            week = str(week)
        
    except Exception as e:
        logger.error(f'Error retrieving player stats: {str(e)}')        
    return df, str(week)

def retrieve_player_injuries(season_list):
    '''
    Takes in a list of season years, and returns a dataframe containing any players on a weekly basis who were dealing with injuries.
    Given the current season, it will return data that has already happened.
    '''
    try:
        df = nfl.import_injuries(season_list)
    except Exception as e:
        logger.error(f'Error retrieving player injuries: {str(e)}')
    return df

def retrieve_schedule(season_list):
    '''
    Given a list of season years, it will return the schedule (DataFrame format) for the entire season. If the game has already happened,
    it includes results of the game. Game odds also available if wanted.
    '''
    try:
        df = nfl.import_schedules(season_list)
        schedule = df[['game_id', 'season', 'game_type', 'week', 'gameday', 'weekday', 'gametime', 'away_team', 'away_score',
                       'home_team', 'home_score', 'div_game', 'location', 'result', 'total', 'overtime', 'gsis', 'nfl_detail_id', 'temp',
                       'wind', 'stadium_id']].copy()
    except Exception as e:
        logger.error(f'Error retrieving schedule: {str(e)}')
    return schedule

def retrieve_rosters(season_list):
    '''
    Returns the roster for the specified seasons. If the season is current, it gives the most up to data to reflect any roster changes
    '''
    try:
        df = nfl.import_seasonal_rosters(season_list)
        df.drop(columns=['headshot_url'], inplace=True)
    except Exception as e:
        logger.error(f'Error retrieving player stats: {str(e)}')
    return df


def retrieve_stadiums(season_list):
    df = nfl.import_schedules(season_list)
    stadiums = df[['stadium_id', 'stadium', 'roof', 'surface']].copy()
    stadiums.drop_duplicates(inplace=True)
    stadiums.dropna(inplace=True)
    return stadiums

def create_odds_ids(df, columns, roster):
    '''
    Takes a list of player_name columns and converts it to a custom ID corresponding to a custom ID in The Odds data source
    '''
    
    ### Create full name column
    new_cols = []
    for col in columns:
        # Perform the merge
        merged = pd.merge(df[[col]], roster[['player_id', 'player_name']], 
                          left_on=col, right_on='player_id', how='left')   
        # Add the new column to df
        column_name = col.replace('id', 'odds_id')
        new_cols.append(column_name)
        df[column_name] = merged['player_name']
        
    for col in new_cols:
        if col in df.columns:
            df[col] = df.game_id + '_' + df[col]
    # Regular expression for removing spaces, periods, hyphens, and other special characters
    regex_pattern = '[\s\.\-]+'

    # Iterate over each specified column and apply the cleaning
    for col in new_cols:
        if col in df.columns:
            # Apply transformations only on non-NaN rows
            df[col] = df[col].apply(
                lambda x: re.sub(regex_pattern, '', x.lower()) if pd.notna(x) else x)
    return df

def upload_file(df, table_type, season, week=None): 
    '''
    Uplaods a dataframe as a CSV to azure, path determined by parameters
    
    Parameters
    ----------
    df : DataFrame
        The data to be uploaded to Azure
    table_type : Str
        Name of table. Must be one of ['player-stats', 'player-injuries', 'schedules', 'rosters']
    season : int
        Used to organize the files in a hierarchy
    '''
    try:
        connection_string = os.getenv('NFL_STORAGE')
        if not connection_string:
            logger.error('Application stopped: NFL_STORAGE environment variable is not set.')
            sys.exit('Error: The NFL_STORAGE environment variable is not set.')
        container_name = 'nfl-data-py'

        table_mapping = {
        'player-stats': f'weekly-player-stats/{season}_player_stats.parquet',
        'pbp-stats': f'pbp-stats/{season}/week{week}_pbp_stats.parquet',
        'player-injuries': f'weekly-player-injuries/{season}_player_injuries.parquet',
        'schedules': f'schedules/{season}_schedule.parquet',
        'rosters': f'rosters/{season}_roster.parquet',
        'stadiums':f'stadiums/{season}_stadiums.parquet'
        }
        
        blob_name = table_mapping.get(table_type)
        if blob_name is None:
            logger.error(f'Invalid table type provided: {table_type}')
        
        # Create a buffer
        with BytesIO() as buffer:
            # Save the DataFrame to the buffer in CSV format
            df.to_parquet(buffer, index=False)
            
            # Rewind the buffer's position to the start
            buffer.seek(0)
        
            # Create a blob client
            blob_service_client = BlobServiceClient.from_connection_string(connection_string)
            blob_client = blob_service_client.get_blob_client(container=container_name, blob=blob_name)
            
            # Upload the byte data of the CSV file
            blob_client.upload_blob(buffer, blob_type='BlockBlob', overwrite=True)
        
    except AzureError as ae:
        logger.error(f'Azure specific error occurred: {str(ae)}')
    return

def main():
    current_season = get_season()
    upload_file(retrieve_player_stats([current_season]), 'player-stats', current_season)
    pbp_data, pbp_week = retrieve_pbp_stats([current_season])
    upload_file(pbp_data, 'pbp-stats', current_season, pbp_week)
    upload_file(retrieve_player_injuries([current_season]), 'player-injuries', current_season)
    upload_file(retrieve_schedule([current_season]), 'schedules', current_season)
    upload_file(retrieve_rosters([current_season]), 'rosters', current_season)
    upload_file(retrieve_stadiums([current_season]), 'stadiums', current_season)
    logger.info('All nfl-data-py data ingested and uploaded successfully')
    return

if __name__ == '__main__':
    main()
