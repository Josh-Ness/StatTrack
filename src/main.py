from data_collection import get_season, retrieve_pbp_stats, retrieve_player_injuries, retrieve_schedule, retrieve_rosters, clean_dataframe
from db_insertion import upload_to_sql

TABLE_MAPPINGS = {
    'rosters': 'dbo_Player',
    'schedules': 'dbo_Game',
    'injuries': 'dbo_Injury',
    'pbp-stats': 'dbo_PlayByPlay'
}

def process_and_upload_data():
    current_season = get_season()
    current_season = 2024
    pbp_data, pbp_week = retrieve_pbp_stats([current_season])
    if not pbp_data.empty:
        table_name = TABLE_MAPPINGS['pbp-stats']
        pbp_data = clean_dataframe(pbp_data)
        upload_to_sql(pbp_data, table_name)

    # Process player injuries
    injuries, injury_week = retrieve_player_injuries([current_season])
    if not injuries.empty:
        table_name = TABLE_MAPPINGS['injuries']
        injuries = clean_dataframe(injuries)
        upload_to_sql(injuries, table_name)

    # Process schedule
    schedule = retrieve_schedule([current_season])
    if not schedule.empty:
        table_name = TABLE_MAPPINGS['schedules']
        schedule = clean_dataframe(schedule)
        upload_to_sql(schedule, table_name)

    # Process rosters
    rosters, roster_week = retrieve_rosters([current_season])
    if not rosters.empty:
        table_name = TABLE_MAPPINGS['rosters']
        rosters = clean_dataframe(rosters)
        upload_to_sql(rosters, table_name)


def main():
    process_and_upload_data()

if __name__ == '__main__':
    main()