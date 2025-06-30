import nfl_data_py as nfl
import pandas as pd
from datetime import datetime
import logging
from dateutil.relativedelta import relativedelta

logger = logging.getLogger('nfl-data-py')

def get_season():
    today = datetime.today()
    season = today - relativedelta(months=4)
    return season.year

def retrieve_pbp_stats(season_list, week=-1):
    week = int(week)
    try:
        full_pbp = nfl.import_pbp_data(season_list, include_participation=False)
        if week == -1:
            week = full_pbp['week'].max()
        pbp = full_pbp.loc[full_pbp['week'] == week]

        fact_cols = [
            'game_id', 'play_id', 'qtr', 'drive', 'down', 'shotgun', 'no_huddle', 'qb_dropback',
            'qb_scramble', 'complete_pass', 'incomplete_pass', 'passing_yards', 'air_yards', 'yards_after_catch',
            'first_down_pass', 'pass_touchdown', 'receiving_yards', 'interception', 'fumble', 'sack', 'rush_attempt',
            'rushing_yards', 'rush_touchdown', 'first_down_rush', 'field_goal_attempt', 'extra_point_attempt',
            'punt_attempt', 'kickoff_attempt', 'field_goal_result', 'extra_point_result', 'safety', 'penalty',
            'season', 'week', 'passer_player_id', 'receiver_player_id', 'rusher_player_id', 'kicker_player_id'
        ]

        df = pbp[fact_cols].copy()
        new_column_names = [
            'GameID', 'PlayID', 'QTR', 'Drive', 'Down', 'Shotgun', 'NoHuddle', 'QbDropback', 'QbScramble',
            'CompletePass', 'IncompletePass', 'PassingYards', 'AirYards', 'YardsAfterCatch', 'FirstDownPass',
            'PassingTouchdown', 'ReceivingYards', 'Interception', 'Fumble', 'Sack', 'RushAttempt', 'RushingYards',
            'RushingTouchdown', 'FirstDownRush', 'FieldGoalAttempt', 'ExtraPointAttempt', 'PuntAttempt',
            'KickoffAttempt', 'FieldGoalResult', 'ExtraPointResult', 'Safety', 'Penalty', 'Season', 'Week',
            'PasserPlayerID', 'ReceiverPlayerID', 'RusherPlayerID', 'KickerPlayerID'
        ]
        df.columns = new_column_names

        float_columns = df.select_dtypes(include='float32').columns
        df[float_columns] = df[float_columns].fillna(0)

        if week < 10:
            week = f"0{week}"
        else:
            week = str(week)

    except Exception as e:
        logger.error(f"Error retrieving player stats: {e}")
        return pd.DataFrame(), str(week)
    return df, str(week)

# Similar retrieval functions for other datasets like injuries, schedules, and rosters.
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
        return pd.DataFrame(), str(week)
    #Return week as a formatted string
    if week<10:
        week = '0'+str(week)
    else:
        week = str(week)
    return df, str(week)

def retrieve_schedule(season_list): #dbo.game
    '''
    Given a list of season years, it will return the schedule (DataFrame format) for the entire season. If the game has already happened,
    it includes results of the game. Game odds also available if wanted.
    '''
    try:
        df = nfl.import_schedules(season_list)
       
        df = df[['game_id', 'season', 'week', 'game_type', 'gameday', 'weekday', 'gametime', 'location', 'away_team', 'home_team', 'div_game', 'away_score', 'home_score',
                 'total', 'overtime', 'result', 'away_rest', 'home_rest', 'stadium_id', 'temp', 'wind', 'away_moneyline', 'home_moneyline', 'spread_line',
                 'home_spread_odds', 'away_spread_odds', 'total_line', 'under_odds', 'over_odds']].copy()
        new_column_names = ['GameID', 'Season', 'Week', 'GameType', 'GameDay', 'WeekDay', 'GameTime', 'Location', 'AwayTeam', 
                    'HomeTeam', 'DivGame', 'AwayScore', 'HomeScore', 'Total', 'Overtime', 'Result', 'AwayRest', 'HomeRest', 
                    'StadiumID', 'Temp', 'Wind', 'AwayMoneyline', 'HomeMoneyLine', 
                    'SpreadLine', 'HomeSpreadOdds', 'AwaySpreadOdds', 'TotalLine', 'UnderOdds', 'OverOdds']

        # Renaming the columns
        df.columns = new_column_names
        #Lastly, there is a time column that we need to format
        df['GameTime'] = df['GameTime'].apply(lambda x: datetime.strptime(x, '%H:%M').time())
        df = df.astype(object).where(df.notna(), None)

    except Exception as e:
        print(e)
        logger.error(f'Error retrieving schedule: {str(e)}')
        return pd.DataFrame()
    return df

def retrieve_rosters(season_list, week=-1): #dbo.player
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
        return pd.DataFrame(), str(week)
    #Return week as a formatted string
    if week<10:
        week = '0'+str(week)
    else:
        week = str(week)
    #df.to_csv('player_data_before_upload.csv', index=False)
    df = df.astype(object).where(df.notna(), None)
    return df, str(week)

'''
def process_historical_data(years):
    """
    This function processes historical NFL data for the given list of years.
    It loops through each year and processes each week until an error occurs (likely due to missing data).
    
    Parameters:
    ----------
    years : list
        A list of years to process.
    """
    for year in years:
        print(f'Year: {year}')
        week = 1
        while True:
            print(f'Week: {week}')
            try:
                # Retrieve and upload play-by-play stats
                pbp_data, pbp_week = retrieve_pbp_stats([year], week)
                if pbp_data.empty:
                    break
                upload_file(pbp_data, 'pbp-stats', year, pbp_week)
                
                # Retrieve and upload player injuries
                injuries, injury_week = retrieve_player_injuries([year], week)
                upload_file(injuries, 'player-injuries', year, injury_week)
                
                # Retrieve and upload rosters
                rosters, roster_week = retrieve_rosters([year], week)
                upload_file(rosters, 'rosters', year, roster_week)
                
                logger.info(f'Successfully processed data for Year: {year}, Week: {week}')
                
                # Increment to the next week
                week += 1
            
            except Exception as e:
            #     # Break out of the loop if an error occurs, likely due to missing data
            #     logger.warning(f'Stopping processing for Year: {year} at Week: {week} due to error: {str(e)}')
                break
        
    logger.info('Historical data processing completed.')
    return
'''

def clean_dataframe(df):
    # Convert NaNs to None (nulls for SQL)
    df = df.astype(object).where(df.notna(), None)

    # Infer and coerce booleans (0/1 or 0.0/1.0) to actual bools
    for col in df.columns:
        if df[col].dropna().nunique() <= 2:
            unique_vals = set(df[col].dropna().unique())
            if unique_vals.issubset({0, 1, 0.0, 1.0, True, False}):
                df[col] = df[col].apply(lambda x: bool(x) if x is not None else None)

    return df