-- This script defined a initial schema for the staging tables
-- Player Table
CREATE TABLE dbo.Player (
    PlayerID NVARCHAR(20),
    PlayerFirstName NVARCHAR(30),
    PlayerLastName NVARCHAR(30),
    PlayerFullName NVARCHAR(60),
    JerseyNumber INT,
    Status NVARCHAR(5) NOT NULL,
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
    EspnID NVARCHAR(20),
    SportradarID NVARCHAR(100),
    YahooID NVARCHAR(20),
    RotowireID NVARCHAR(20),
    PffID NVARCHAR(20),
    PfrID NVARCHAR(20),
    FantasyDataID NVARCHAR(20),
    SleeperID NVARCHAR(20),
    EsbID NVARCHAR(20),
    GsisItID NVARCHAR(20),
    SmartID NVARCHAR(100),
    FootballName NVARCHAR(30),
    StatusDescriptionAbbr NVARCHAR(5),
    Season INT,
    Week INT,
    GameType NVARCHAR(5)
);
GO

-- Schedule Table
CREATE TABLE dbo.Game (
    GameID NVARCHAR(20) PRIMARY KEY,
    Season INT NOT NULL,
    Week INT NOT NULL,
    StadiumID NVARCHAR(10),
    GameType NVARCHAR(5),
    gameDay DATE,
    WeekDay NVARCHAR(10),
    GameTime TIME,
    Location NVARCHAR(10),
    AwayTeam NVARCHAR(5) NOT NULL,
    HomeTeam NVARCHAR(5) NOT NULL,
    DivGame BIT,
    AwayScore FLOAT,
    HomeScore FLOAT,
    Total FLOAT,
    Overtime BIT,
    Result FLOAT,
    AwayRest INT,
    HomeRest INT,
    Temp INT,
    Wind INT,
    AwayMoneyline FLOAT,
    HomeMoneyline FLOAT,
    SpreadLine FLOAT,
    HomeSpreadOdds FLOAT,
    AwaySpreadOdds FLOAT,
    TotalLine FLOAT,
    UnderOdds FLOAT,
    OverOdds FLOAT
);
GO

-- Injury Table
CREATE TABLE dbo.Injury (
    Season INT,
    Week INT,
    GsisID NVARCHAR(20),
    PRIMARY KEY (Season, Week, GsisID),
    FirstName NVARCHAR(30),
    LastName NVARCHAR(30),
    FullName NVARCHAR(30),
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

-- Stadium Table
CREATE TABLE dbo.Stadium (
    StadiumID NVARCHAR(10) PRIMARY KEY,
    StadiumName NVARCHAR(100) NOT NULL,
    Roof NVARCHAR(20),
    Surface NVARCHAR(20)
);
GO

-- Props Table
CREATE TABLE PlayerProps (
    PlayerName NVARCHAR(60) NOT NULL,
    EventID NVARCHAR(50) NOT NULL,
    CommenceTime DATETIME,
    AwayTeam NVARCHAR(50) NOT NULL,
    HomeTeam NVARCHAR(50) NOT NULL,
    BookmakerKey NVARCHAR(50),
    BookmakerTitle NVARCHAR(50),
    MarketKey NVARCHAR(100),
    OutcomeName NVARCHAR(10),
    Price FLOAT,
    Point FLOAT,
    RefreshTime DATETIME
);
GO

-- Play By Play Table
CREATE TABLE PlayByPlay (
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
    PassingYards DECIMAL(10,1),
    AirYards DECIMAL(10,1),
    YardsAfterCatch DECIMAL(10,1),
    FirstDownPass BIT,
    PassingTouchdown BIT,
    ReceivingYards DECIMAL(10,1),
    Interception BIT,
    Fumble BIT,
    Sack BIT,
    RushAttempt BIT,
    RushingYards DECIMAL(10,1),
    RushingTouchdown BIT,
    FirstDownRush BIT,
    FieldGoalAttempt BIT,
    ExtraPointAttempt BIT,
    FieldGoalResult NVARCHAR(10),
    ExtraPointRusult NVARCHAR(10),
    Safety BIT,
    Penalty BIT,
    Week INT,
    -- Foreign Keys
    PasserPlayerID NVARCHAR(20),
    ReceiverPlayerID NVARCHAR(20),
    RusherPlayerID NVARCHAR(20),
    KickerPlayerID NVARCHAR(20),
    StadiumID NVARCHAR(10),
    -- FK Constraints
    CONSTRAINT FK_PlayByPlay_PasserPlayerID FOREIGN KEY (PasserPlayerID) REFERENCES dbo.Player(PlayerID),
    CONSTRAINT FK_PlayByPlay_ReceiverPlayerID FOREIGN KEY (ReceiverPlayerID) REFERENCES dbo.Player(PlayerID),
    CONSTRAINT FK_PlayByPlay_RusherPlayerID FOREIGN KEY (RusherPlayerID) REFERENCES dbo.Player(PlayerID),
    CONSTRAINT FK_PlayByPlay_KickerPlayerID FOREIGN KEY (KickerPlayerID) REFERENCES dbo.Player(PlayerID),
    CONSTRAINT FK_PlayByPlay_StadiumID FOREIGN KEY (StadiumID) REFERENCES dbo.Stadium(StadiumID)
);
GO