-- FACT TABLE: fact_playbyplay
CREATE TABLE fact_playbyplay (
    game_id VARCHAR(20),
    play_id INTEGER,
    qtr INTEGER,
    drive INTEGER,
    down INTEGER,
    shotgun BOOLEAN,
    no_huddle BOOLEAN,
    qb_dropback BOOLEAN,
    qb_scramble BOOLEAN,
    complete_pass BOOLEAN,
    incomplete_pass BOOLEAN,
    passing_yards NUMERIC(10,1),
    air_yards NUMERIC(10,1),
    yards_after_catch NUMERIC(10,1),
    first_down_pass BOOLEAN,
    passing_touchdown BOOLEAN,
    receiving_yards NUMERIC(10,1),
    interception BOOLEAN,
    fumble BOOLEAN,
    sack BOOLEAN,
    rush_attempt BOOLEAN,
    rushing_yards NUMERIC(10,1),
    rushing_touchdown BOOLEAN,
    first_down_rush BOOLEAN,
    field_goal_attempt BOOLEAN,
    extra_point_attempt BOOLEAN,
    punt_attempt BOOLEAN,
    kickoff_attempt BOOLEAN,
    field_goal_result VARCHAR(10),
    extra_point_result VARCHAR(10),
    safety BOOLEAN,
    penalty BOOLEAN,
    season INTEGER,
    week INTEGER,
    passer_player_id VARCHAR(20),
    receiver_player_id VARCHAR(20),
    rusher_player_id VARCHAR(20),
    kicker_player_id VARCHAR(20),
    stadium_id VARCHAR(10),
    PRIMARY KEY (game_id, play_id)
);

-- DIMENSION TABLE: dim_game
CREATE TABLE dim_game (
    game_id VARCHAR(20) PRIMARY KEY,
    season INTEGER NOT NULL,
    week INTEGER NOT NULL,
    stadium_id VARCHAR(10),
    game_type VARCHAR(5),
    game_day DATE,
    week_day VARCHAR(10),
    game_time TIME,
    location VARCHAR(10),
    away_team VARCHAR(5) NOT NULL,
    home_team VARCHAR(5) NOT NULL,
    div_game BOOLEAN,
    away_score FLOAT,
    home_score FLOAT,
    total FLOAT,
    overtime BOOLEAN,
    result FLOAT,
    away_rest INTEGER,
    home_rest INTEGER,
    temp INTEGER,
    wind INTEGER,
    away_moneyline FLOAT,
    home_moneyline FLOAT,
    spread_line FLOAT,
    home_spread_odds FLOAT,
    away_spread_odds FLOAT,
    total_line FLOAT,
    under_odds FLOAT,
    over_odds FLOAT
);

-- DIMENSION TABLE: dim_injury
CREATE TABLE dim_injury (
    season INTEGER,
    week INTEGER,
    gsis_id VARCHAR(20),
    first_name VARCHAR(30),
    last_name VARCHAR(30),
    full_name VARCHAR(30),
    game_type VARCHAR(5),
    team VARCHAR(5) NOT NULL,
    position VARCHAR(5) NOT NULL,
    report_primary_injury VARCHAR(100),
    report_secondary_injury VARCHAR(100),
    report_status VARCHAR(25),
    practice_primary_injury VARCHAR(100),
    practice_secondary_injury VARCHAR(100),
    practice_status VARCHAR(100),
    date_modified TIMESTAMP,
    PRIMARY KEY (season, week, gsis_id)
);

-- DIMENSION TABLE: dim_player
CREATE TABLE dim_player (
    player_id VARCHAR(20),
    first_name VARCHAR(30),
    last_name VARCHAR(30),
    full_name VARCHAR(60),
    jersey_number INTEGER,
    status VARCHAR(5) NOT NULL,
    team VARCHAR(5),
    position VARCHAR(5),
    ngs_position VARCHAR(20),
    depth_chart_position VARCHAR(5),
    age INTEGER,
    years_exp INTEGER,
    birth_date TIMESTAMP,
    height INTEGER,
    weight INTEGER,
    college VARCHAR(50),
    draft_number INTEGER,
    draft_club VARCHAR(5),
    entry_year INTEGER,
    rookie_year INTEGER,
    headshot_url VARCHAR(200),
    espn_id VARCHAR(20),
    sportradar_id VARCHAR(100),
    yahoo_id VARCHAR(20),
    rotowire_id VARCHAR(20),
    pff_id VARCHAR(20),
    pfr_id VARCHAR(20),
    fantasydata_id VARCHAR(20),
    sleeper_id VARCHAR(20),
    esb_id VARCHAR(20),
    gsis_it_id VARCHAR(20),
    smart_id VARCHAR(100),
    football_name VARCHAR(30),
    status_description_abbr VARCHAR(5),
    season INTEGER,
    week INTEGER,
    game_type VARCHAR(5)
);

-- DIMENSION TABLE: dim_stadium
CREATE TABLE dim_stadium (
    stadium_id VARCHAR(10) PRIMARY KEY,
    stadium_name VARCHAR(100) NOT NULL,
    roof VARCHAR(20),
    surface VARCHAR(20)
);

-- DIMENSION TABLE: dim_playerprops
CREATE TABLE dim_playerprops (
    player_name VARCHAR(60) NOT NULL,
    event_id VARCHAR(50) NOT NULL,
    commence_time TIMESTAMP,
    away_team VARCHAR(50) NOT NULL,
    home_team VARCHAR(50) NOT NULL,
    bookmaker_key VARCHAR(50),
    bookmaker_title VARCHAR(50),
    market_key VARCHAR(100),
    outcome_name VARCHAR(10),
    price FLOAT,
    point FLOAT,
    refresh_time TIMESTAMP
);