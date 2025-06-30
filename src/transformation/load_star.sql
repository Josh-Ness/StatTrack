BEGIN;

-- load_dim_player
INSERT INTO dim_player (
    player_id, first_name, last_name, full_name, jersey_number, status, team,
    position, ngs_position, depth_chart_position, age, years_exp, birth_date,
    height, weight, college, draft_number, draft_club, entry_year, rookie_year,
    headshot_url, espn_id, sportradar_id, yahoo_id, rotowire_id, pff_id, pfr_id,
    fantasydata_id, sleeper_id, esb_id, gsis_it_id, smart_id, football_name,
    status_description_abbr, season, week, game_type
)
SELECT DISTINCT
    PlayerID, PlayerFirstName, PlayerLastName, PlayerFullName, JerseyNumber, Status, Team,
    Position, NgsPosition, DepthChartPosition, Age, YearsExp, BirthDate,
    Height, Weight, College, DraftNumber, DraftClub, EntryYear, RookieYear,
    HeadshotURL, EspnID, SportradarID, YahooID, RotowireID, PffID, PfrID,
    FantasyDataID, SleeperID, EsbID, GsisItID, SmartID, FootballName,
    StatusDescriptionAbbr, Season, Week, GameType
FROM dbo_player
WHERE PlayerID IS NOT NULL;

DELETE FROM dbo_player WHERE PlayerID IS NOT NULL;

-- load_dim_game
INSERT INTO dim_game (
    game_id, season, week, stadium_id, game_type, game_day, week_day,
    game_time, location, away_team, home_team, div_game, away_score,
    home_score, total, overtime, result, away_rest, home_rest, temp,
    wind, away_moneyline, home_moneyline, spread_line, home_spread_odds,
    away_spread_odds, total_line, under_odds, over_odds
)
SELECT DISTINCT
    GameID, Season, Week, StadiumID, GameType, GameDay, WeekDay,
    GameTime, Location, AwayTeam, HomeTeam, DivGame, AwayScore,
    HomeScore, Total, Overtime, Result, AwayRest, HomeRest, Temp,
    Wind, AwayMoneyline, HomeMoneyline, SpreadLine, HomeSpreadOdds,
    AwaySpreadOdds, TotalLine, UnderOdds, OverOdds
FROM dbo_game;

DELETE FROM dbo_game;

-- load_dim_injury
INSERT INTO dim_injury (
    season, week, gsis_id, first_name, last_name, full_name, game_type,
    team, position, report_primary_injury, report_secondary_injury,
    report_status, practice_primary_injury, practice_secondary_injury,
    practice_status, date_modified
)
SELECT DISTINCT
    Season, Week, GsisID, FirstName, LastName, FullName, GameType,
    Team, Position, ReportPrimaryInjury, ReportSecondaryInjury,
    ReportStatus, PracticePrimaryInjury, PracticeSecondaryInjury,
    PracticeStatus, DateModified
FROM dbo_injury;

DELETE FROM dbo_injury;

-- load_dim_stadium
INSERT INTO dim_stadium (
    stadium_id, stadium_name, roof, surface
)
SELECT DISTINCT
    StadiumID, StadiumName, Roof, Surface
FROM dbo_stadium;

DELETE FROM dbo_stadium;

-- load_dim_playerprops
INSERT INTO dim_playerprops (
    player_name, event_id, commence_time, away_team, home_team,
    bookmaker_key, bookmaker_title, market_key, outcome_name,
    price, point, refresh_time
)
SELECT DISTINCT
    PlayerName, EventID, CommenceTime, AwayTeam, HomeTeam,
    BookmakerKey, BookmakerTitle, MarketKey, OutcomeName,
    Price, Point, RefreshTime
FROM dbo_playerprops;

DELETE FROM dbo_playerprops;

-- load_fact_playbyplay
INSERT INTO fact_playbyplay (
    game_id, play_id, qtr, drive, down, shotgun, no_huddle, qb_dropback,
    qb_scramble, complete_pass, incomplete_pass, passing_yards, air_yards,
    yards_after_catch, first_down_pass, passing_touchdown, receiving_yards,
    interception, fumble, sack, rush_attempt, rushing_yards, rushing_touchdown,
    first_down_rush, field_goal_attempt, extra_point_attempt, punt_attempt,
    kickoff_attempt, field_goal_result, extra_point_result, safety, penalty,
    season, week, passer_player_id, receiver_player_id, rusher_player_id,
    kicker_player_id, stadium_id
)
SELECT
    GameID, PlayID, QTR, Drive, Down, Shotgun, NoHuddle, QbDropback,
    QbScramble, CompletePass, IncompletePass, PassingYards, AirYards,
    YardsAfterCatch, FirstDownPass, PassingTouchdown, ReceivingYards,
    Interception, Fumble, Sack, RushAttempt, RushingYards, RushingTouchdown,
    FirstDownRush, FieldGoalAttempt, ExtraPointAttempt, PuntAttempt,
    KickoffAttempt, FieldGoalResult, ExtraPointResult, Safety, Penalty,
    Season, Week, PasserPlayerID, ReceiverPlayerID, RusherPlayerID,
    KickerPlayerID, StadiumID
FROM dbo_playbyplay;

DELETE FROM dbo_playbyplay;

COMMIT;