-- This script defines the finalized star schema, with appropriate data types and constraints
-- Create a new schema for the star schema
CREATE SCHEMA ss;
GO


-- Player Table
CREATE TABLE ss.Dim_Player (
    PlayerID NVARCHAR(20) PRIMARY KEY,
    PlayerFirstName NVARCHAR(30) NOT NULL,
    PlayerLastName NVARCHAR(30) NOT NULL,
    PlayerFullName NVARCHAR(60) NOT NULL,
    JerseyNumber INT,
    Status NVARCHAR(5),
    Team NVARCHAR(5),
    Position NVARCHAR(5),
    NgsPosition NVARCHAR(20),
    DepthChartPosition NVARCHAR(5),
    Age INT,
    YearsExp INT,
    BirthDate DATETIME,
    Height INT,
    Weight INT,
    College NVARCHAR(50),
    DraftNumber INT,
    DraftClub NVARCHAR(5),
    EntryYear INT,
    RookieYear INT,
    HeadshotURL NVARCHAR(200),
    FootballName NVARCHAR(30),
    StatusDescriptionAbbr NVARCHAR(5),
    Season INT,
    Week INT,
    GameType NVARCHAR(5),
    StartDate DATETIME,
    --EndDate DATETIME,
    --IsCurrent BIT,
    --PRIMARY KEY(PlayerID, StartDate)
);
GO

-- Schedule Table
CREATE TABLE ss.Dim_Game (
    GameID NVARCHAR(20) PRIMARY KEY,
    Season INT NOT NULL,
    Week INT NOT NULL,
    GameType NVARCHAR(5) NOT NULL,
    gameDay DATE,
    WeekDay NVARCHAR(10),
    GameTime TIME,
    Location NVARCHAR(10),
    AwayTeam NVARCHAR(5) NOT NULL,
    HomeTeam NVARCHAR(5) NOT NULL,
    DivGame BIT,
    AwayScore INT,
    HomeScore INT,
    Total INT,
    Overtime BIT,
    Result INT,
    AwayRest INT,
    HomeRest INT,
    StadiumID NVARCHAR(10),
    StadiumName NVARCHAR(100),
    Roof NVARCHAR(20),
    Surface NVARCHAR(20),
    Temp INT,
    Wind INT,
    AwayMoneyline INT,
    HomeMoneyline INT,
    SpreadLine DECIMAL(3,1),
    HomeSpreadOdds INT,
    AwaySpreadOdds INT,
    TotalLine DECIMAL(3,1),
    UnderOdds INT,
    OverOdds INT
);
GO

-- Injury Table
CREATE TABLE ss.Dim_Injury (
    Season INT,
    Week INT,
    GsisID NVARCHAR(20),
    PRIMARY KEY (Season, Week, GsisID),
    FirstName NVARCHAR(30),
    LastName NVARCHAR(30),
    FullName NVARCHAR(60),
    GameType NVARCHAR(5),
    Team NVARCHAR(5) NOT NULL,
    Position NVARCHAR(5) NOT NULL,
    ReportPrimaryInjury NVARCHAR(100),
    ReportSecondaryInjury NVARCHAR(100),
    ReportStatus NVARCHAR(25),
    PracticePrimaryInjury NVARCHAR(100),
    PracticeSecondaryInjury NVARCHAR(100),
    PracticeStatus NVARCHAR(100),
    DateModified DATETIME
);
GO

-- Props Table
CREATE TABLE ss.Dim_PlayerProp (
    PropID INT IDENTITY(1,1) PRIMARY KEY,
    PlayerName NVARCHAR(100) NOT NULL,
    EventID NVARCHAR(50) NOT NULL,
    CommenceTime DATETIME,
    AwayTeam NVARCHAR(5) NOT NULL,
    HomeTeam NVARCHAR(5) NOT NULL,
    BookmakerKey NVARCHAR(50),
    BookmakerTitle NVARCHAR(50),
    MarketKey NVARCHAR(100),
    OutcomeName NVARCHAR(10),
    Price DECIMAL(7,3),
    Point DECIMAL(7,3),
    RefreshTime DATETIME,
    Week INT,
    Season INT,
    PlayerID NVARCHAR(20)
);
GO

-- Play By Play Table
CREATE TABLE ss.Fact_PlayByPlay (
    GameID NVARCHAR(20),
    PlayID INT,
    PRIMARY KEY (GameID, PlayID),
    QTR INT NOT NULL,
    Drive INT NOT NULL,
    Down INT,
    Shotgun BIT,
    NoHuddle BIT,
    QbDropback BIT,
    QbScramble BIT,
    CompletePass BIT,
    IncompletePass BIT,
    PassingYards DECIMAL(6,1),
    AirYards DECIMAL(6,1),
    YardsAfterCatch DECIMAL(6,1),
    FirstDownPass BIT,
    PassingTouchdown BIT,
    ReceivingYards DECIMAL(6,1),
    Interception BIT,
    Fumble BIT,
    Sack BIT,
    RushAttempt BIT,
    RushingYards DECIMAL(6,1),
    RushingTouchdown BIT,
    FirstDownRush BIT,
    FieldGoalAttempt BIT,
    ExtraPointAttempt BIT,
    PuntAttempt BIT,
    KickoffAttempt BIT,
    FieldGoalResult BIT,
    ExtraPointRusult BIT,
    Safety BIT,
    Penalty BIT,
    Week INT,
    -- Foreign Keys
    PasserPlayerID NVARCHAR(20),
    ReceiverPlayerID NVARCHAR(20),
    RusherPlayerID NVARCHAR(20),
    KickerPlayerID NVARCHAR(20),
    -- FK Constraints
    CONSTRAINT FK_PlayByPlay_PasserPlayerID FOREIGN KEY (PasserPlayerID) REFERENCES ss.Dim_Player(PlayerID),
    CONSTRAINT FK_PlayByPlay_ReceiverPlayerID FOREIGN KEY (ReceiverPlayerID) REFERENCES ss.Dim_Player(PlayerID),
    CONSTRAINT FK_PlayByPlay_RusherPlayerID FOREIGN KEY (RusherPlayerID) REFERENCES ss.Dim_Player(PlayerID),
    CONSTRAINT FK_PlayByPlay_KickerPlayerID FOREIGN KEY (KickerPlayerID) REFERENCES ss.Dim_Player(PlayerID),

    CONSTRAINT FK_PlayByPlay_GameID FOREIGN KEY (GameID) REFERENCES ss.Dim_Game(GameID)
);
GO
    
    

    