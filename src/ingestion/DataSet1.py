# -*- coding: utf-8 -*-
"""
Created on Sat Sep 16 23:07:47 2023

@author: joshua.s.ness@ndsu.edu

This file provides methods and a main method to upload several data tables to Azure.
It is important to note, obtaining the most recent data for new games requires collection of
data for the entire season.
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


def retrieve_pbp_stats(season_list, week=-1):
    '''
    Takes in a list of season years, and returns a dataframe containing every single play from the season. From this, data will be able to be aggregated
    to get player stats
    '''
    week = int(week)
    try:
        full_pbp = nfl.import_pbp_data(season_list)
        if week == -1:
            week = full_pbp['week'].max()
        pbp = full_pbp.loc[full_pbp['week'] == week]
        fact_cols = ['game_id', 'play_id', 'qtr', 'drive', 'down', 'shotgun', 'no_huddle', 'qb_dropback', 'qb_scramble', 'complete_pass', 'incomplete_pass', 'passing_yards', 'air_yards', 'yards_after_catch', 'first_down_pass',
                     'pass_touchdown', 'receiving_yards', 'interception', 'fumble', 'sack', 'rush_attempt', 'rushing_yards', 'rush_touchdown', 'first_down_rush', 'field_goal_attempt', 'extra_point_attempt',
                     'punt_attempt', 'kickoff_attempt', 'field_goal_result', 'extra_point_result', 'safety', 'penalty', 'week', 'passer_player_id', 'receiver_player_id', 'rusher_player_id', 'kicker_player_id']                                  
        df = pbp[fact_cols].copy()
        new_column_names = ['GameID', 'PlayID', 'QTR', 'Drive', 'Down', 'Shotgun', 'NoHuddle', 'QbDropback', 'QbScramble', 'CompletePass', 
                    'IncompletePass', 'PassingYards', 'AirYards', 'YardsAfterCatch', 'FirstDownPass', 'PassingTouchdown', 
                    'ReceivingYards', 'Interception', 'Fumble', 'Sack', 'RushAttempt', 'RushingYards', 'RushingTouchdown', 
                    'FirstDownRush', 'FieldGoalAttempt', 'ExtraPointAttempt', 'PuntAttempt', 'KickoffAttempt', 
                    'FieldGoalResult', 'ExtraPointResult', 'Safety', 'Penalty', 'Week', 'PasserPlayerID', 
                    'ReceiverPlayerID', 'RusherPlayerID', 'KickerPlayerID']

        # Renaming the columns
        df.columns = new_column_names
        # Fill na with 0 for float columns, not strings where None could have a different meaning
        float_columns = df.select_dtypes(include='float32').columns

        df[float_columns] = df[float_columns].fillna(0)

        #Return week as a formatted string
        if week<10:
            week = '0'+str(week)
        else:
            week = str(week)
        
    except Exception as e:
        logger.error(f'Error retrieving player stats: {str(e)}')        
    return df, str(week)

def retrieve_player_injuries(season_list, week=-1):
    '''
    Takes in a list of season years, and returns a dataframe containing any players on a weekly basis who were dealing with injuries.
    Given the current season, it will return data that has already happened.
    '''
    week = int(week)
    try:
        df = nfl.import_injuries(season_list)
        df = df[['season', 'week', 'gsis_id', 'first_name', 'last_name', 'full_name', 'game_type', 'team', 'position', 'report_primary_injury',
                 'report_secondary_injury', 'report_status', 'practice_primary_injury', 'practice_secondary_injury', 'practice_status', 'date_modified']].copy()
        new_column_names = ['Season', 'Week', 'GsisID', 'FirstName', 'LastName', 'FullName', 'GameType', 'Team', 'Position', 
                    'ReportPrimaryInjury', 'ReportSecondaryInjury', 'ReportStatus', 'PracticePrimaryInjury', 
                    'PracticeSecondaryInjury', 'PracticeStatus', 'DateModified']

        # Renaming the columns
        df.columns = new_column_names
        if week == -1:
            week = df['Week'].max()
        df = df.loc[df['Week'] == week]
    except Exception as e:
        logger.error(f'Error retrieving player injuries: {str(e)}')
    #Return week as a formatted string
    if week<10:
        week = '0'+str(week)
    else:
        week = str(week)
    return df, str(week)

def retrieve_schedule(season_list):
    '''
    Given a list of season years, it will return the schedule (DataFrame format) for the entire season. If the game has already happened,
    it includes results of the game. Game odds also available if wanted.
    '''
    try:
        df = nfl.import_schedules(season_list)
       
        df = df[['game_id', 'season', 'week', 'game_type', 'gameday', 'weekday', 'gametime', 'location', 'away_team', 'home_team', 'div_game', 'away_score', 'home_score',
                 'total', 'overtime', 'result', 'away_rest', 'home_rest', 'stadium_id', 'stadium', 'roof', 'surface', 'temp', 'wind', 'away_moneyline', 'home_moneyline', 'spread_line',
                 'home_spread_odds', 'away_spread_odds', 'total_line', 'under_odds', 'over_odds']].copy()
        new_column_names = ['GameID', 'Season', 'Week', 'GameType', 'GameDay', 'WeekDay', 'GameTime', 'Location', 'AwayTeam', 
                    'HomeTeam', 'DivGame', 'AwayScore', 'HomeScore', 'Total', 'Overtime', 'Result', 'AwayRest', 'HomeRest', 
                    'StadiumID', 'StadiumName', 'Roof', 'Surface', 'Temp', 'Wind', 'AwayMoneyline', 'HomeMoneyLine', 
                    'SpreadLine', 'HomeSpreadOdds', 'AwaySpreadOdds', 'TotalLine', 'UnderOdds', 'OverOdds']

        # Renaming the columns
        df.columns = new_column_names
        #Lastly, there is a time column that we need to format
        df['GameTime'] = df['GameTime'].apply(lambda x: datetime.strptime(x, '%H:%M').time())
    except Exception as e:
        logger.error(f'Error retrieving schedule: {str(e)}')
    return df

def retrieve_rosters(season_list, week=-1):
    '''
    Returns the roster for the specified seasons. If the season is current, it gives the most up to data to reflect any roster changes
    '''
    try:
        df = nfl.import_seasonal_rosters(season_list)
        df = df[['player_id', 'first_name', 'last_name', 'player_name', 'jersey_number', 'status', 'team', 'position', 'ngs_position', 'depth_chart_position',
                 'age', 'years_exp', 'birth_date', 'height', 'weight', 'college', 'draft_number', 'draft_club', 'entry_year', 'rookie_year', 'headshot_url', 'espn_id', 'sportradar_id',
                 'yahoo_id', 'rotowire_id', 'pff_id', 'pfr_id', 'fantasy_data_id', 'sleeper_id', 'esb_id', 'gsis_it_id', 'smart_id', 'football_name', 'status_description_abbr',
                 'season', 'week', 'game_type']].copy()
        
        new_column_names = ['PlayerID', 'PlayerFirstName', 'PlayerLastName', 'PlayerFullName', 'JerseyNumber', 'Status', 'Team', 
                    'Position', 'NgsPosition', 'DepthChartPosition', 'Age', 'YearsExp', 'BirthDate', 'Height', 'Weight', 
                    'College', 'DraftNumber', 'DraftClub', 'EntryYear', 'RookieYear', 'HeadshotURL', 'EspnID', 'SportradarID', 
                    'YahooID', 'RotowireID', 'PffID', 'PfrID', 'FantasyDataID', 'SleeperID', 'EsbID', 'GsisItID', 'SmartID', 
                    'FootballName', 'StatusDescriptionAbbr', 'Season', 'Week', 'GameType']

        df.columns = new_column_names
        if week == -1:
            week = df['Week'].max()
        df = df.loc[df['Week'] == week]
    except Exception as e:
        logger.error(f'Error retrieving player stats: {str(e)}')
    #Return week as a formatted string
    if week<10:
        week = '0'+str(week)
    else:
        week = str(week)
    return df, str(week)


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
        # 'player-stats': f'weekly-player-stats/{season}_player_stats.parquet',
        'pbp-stats': f'pbp-stats/{season}/{season}_week{week}_pbp_stats.parquet',
        'player-injuries': f'injuries/{season}/{season}_week{week}_player_injuries.parquet',
        'schedules': f'schedules/{season}_schedule.parquet',
        'rosters': f'rosters/{season}/{season}_week{week}_roster.parquet',
        'stadiums':f'stadiums/{season}_stadiums.parquet'
        }
        
        blob_name = table_mapping.get(table_type)
        if blob_name is None:
            logger.error(f'Invalid table type provided: {table_type}')
        
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
            blob_client.upload_blob(buffer, blob_type='BlockBlob', overwrite=True)
        
    except AzureError as ae:
        logger.error(f'Azure specific error occurred: {str(ae)}')
    return

def main():
    # current_season = get_season()
    current_season = 2023
    pbp_data, pbp_week = retrieve_pbp_stats([current_season], 21)
    upload_file(pbp_data, 'pbp-stats', current_season, pbp_week)
    injuries, injury_week = retrieve_player_injuries([current_season], 21)
    upload_file(injuries, 'player-injuries', current_season, injury_week)
    upload_file(retrieve_schedule([current_season]), 'schedules', current_season)
    rosters, roster_week = retrieve_rosters([current_season], 21)
    upload_file(rosters, 'rosters', current_season, roster_week)
    logger.info('All nfl-data-py data ingested and uploaded successfully')
    return

if __name__ == '__main__':
    main()