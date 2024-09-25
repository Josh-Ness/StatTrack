-- This script transforms data from the staging tables to the finalized star schema
-- Should any error occer, the error information is sent to its own table
ALTER PROCEDURE LoadStarSchema
AS
BEGIN


-- Dim_Player
BEGIN TRANSACTION;
BEGIN TRY
    MERGE INTO ss.Dim_Player AS Target
    USING (SELECT PlayerID, PlayerFirstName, PlayerLastName, PlayerFullName, JerseyNumber, Status, Team, Position, NgsPosition,
                DepthChartPosition, Age, YearsExp, BirthDate, Height, Weight, College, DraftNumber, DraftClub, EntryYear,
                RookieYear, HeadshotURL, FootballName, StatusDescriptionAbbr, Season, Week, GameType
        FROM dbo.Player) AS Source
    ON Target.PlayerID = Source.PlayerID
    WHEN MATCHED THEN
        UPDATE SET Target.PlayerFirstName = Source.PlayerFirstName, Target.PlayerLastName = Source.PlayerLastName, Target.PlayerFullName = Source.PlayerFullName, Target.JerseyNumber = Source.JerseyNumber,
        Target.Status = Source.Status, Target.Team = Source.Team, Target.Position = Source.Position, Target.NgsPosition = Source.NgsPosition, Target.DepthChartPosition = Source.DepthChartPosition,
        Target.Age = Source.Age, Target.YearsExp = Source.YearsExp, Target.BirthDate = Source.BirthDate, Target.Height = Source.Height, Target.Weight = Source.Weight, Target.College = Source.College,
        Target.DraftNumber = Source.DraftNumber, Target.DraftClub = Source.DraftClub, Target.EntryYear = Source.EntryYear, Target.RookieYear = Source.RookieYear, Target.HeadshotURL = Source.HeadshotURL,
        Target.FootballName = Source.FootballName, Target.StatusDescriptionAbbr = Source.StatusDescriptionAbbr, Target.Season = Source.Season, Target.Week = Source.Week,
        Target.GameType = Source.GameType, Target.StartDate = GETDATE()
    WHEN NOT MATCHED THEN
        INSERT (PlayerID, PlayerFirstName, PlayerLastName, PlayerFullName, JerseyNumber, Status, Team, Position,
                NgsPosition, DepthChartPosition, Age, YearsExp, BirthDate, Height, Weight, College, DraftNumber, DraftClub, EntryYear,
                RookieYear, HeadshotURL, FootballName, StatusDescriptionAbbr, Season, Week, GameType, StartDate)
        VALUES (Source.PlayerID, Source.PlayerFirstName, Source.PlayerLastName, Source.PlayerFullName, Source.JerseyNumber, Source.Status, Source.Team, Source.Position,
                Source.NgsPosition, Source.DepthChartPosition, Source.Age, Source.YearsExp, Source.BirthDate, Source.Height, Source.Weight, Source.College, Source.DraftNumber, Source.DraftClub, Source.EntryYear,
                Source.RookieYear, Source.HeadshotURL, Source.FootballName, Source.StatusDescriptionAbbr, Source.Season, Source.Week, Source.GameType, GETDATE());

    COMMIT TRANSACTION;
    DELETE FROM dbo.Player;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    INSERT INTO ErrorLog (ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, ErrorMessage)
    VALUES (ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE());
END CATCH

--Dim_Game
BEGIN TRANSACTION;
BEGIN TRY
    MERGE INTO ss.Dim_Game AS Target
    USING (SELECT GameID, Season, Week, GameType, GameDay, WeekDay, GameTime, Location, AwayTeam, HomeTeam, DivGame, AwayScore, HomeScore, Total, Overtime, Result, AwayRest, HomeRest, StadiumID, StadiumName,
    Roof, Surface, Temp, Wind, AwayMoneyline, HomeMoneyline, SpreadLine, HomeSpreadOdds, AwaySpreadOdds, TotalLine, UnderOdds, OverOdds
        FROM dbo.Game) AS Source
    ON Target.GameID = Source.GameID
    WHEN MATCHED THEN
        UPDATE SET Target.GameDay = Source.GameDay, Target.WeekDay = Source.WeekDay, Target.GameTime = Source.GameTime, Target.Location = Source.Location, Target.AwayScore = Source.AwayScore,
        Target.HomeScore = Source.HomeScore, Target.Total = Source.Total, Target.Overtime = Source.Overtime, Target.Result = Source.Result, Target.AwayRest = Source.AwayRest, Target.HomeRest = Source.HomeRest,
        Target.StadiumID = Source.StadiumID, Target.StadiumName = Source.StadiumName, Target.Roof = Source.Roof, Target.Surface = Source.Surface, Target.Temp = Source.Temp, Target.Wind = Source.Wind, Target.AwayMoneyLine = Source.AwayMoneyline,
        Target.HomeMoneyline = Source.HomeMoneyline, Target.SpreadLine = Source.SpreadLine, Target.HomeSpreadOdds = Source.HomeSpreadOdds,
        Target.AwaySpreadOdds = Source.AwaySpreadOdds, Target.TotalLine = Source.TotalLine, Target.UnderOdds = Source.UnderOdds, Target.OverOdds = Source.OverOdds
    WHEN NOT MATCHED THEN
        INSERT (GameID, Season, Week, GameType, GameDay, WeekDay, GameTime, Location, AwayTeam, HomeTeam, DivGame, AwayScore, HomeScore, Total, Overtime, Result, AwayRest, HomeRest, StadiumID, StadiumName,
        Roof, Surface, Temp, Wind, AwayMoneyline, HomeMoneyline, SpreadLine, HomeSpreadOdds, AwaySpreadOdds, TotalLine, UnderOdds, OverOdds)
        VALUES (Source.GameID, Source.Season, Source.Week, Source.GameType, Source.GameDay, Source.WeekDay, Source.GameTime, Source.Location, Source.AwayTeam, Source.HomeTeam, Source.DivGame, Source.AwayScore,
        Source.HomeScore, Source.Total, Source.Overtime, Source.Result, Source.AwayRest, Source.HomeRest, Source.StadiumID, Source.StadiumName, Source.Roof, Source.Surface, Source.Temp, Source.Wind,
        Source.AwayMoneyline, Source.HomeMoneyline, Source.SpreadLine, Source.HomeSpreadOdds, Source.AwaySpreadOdds, Source.TotalLine, Source.UnderOdds, Source.OverOdds);

    COMMIT TRANSACTION;
    DELETE FROM dbo.Game;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    INSERT INTO ErrorLog (ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, ErrorMessage)
    VALUES (ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE());
END CATCH


--Injury
BEGIN TRANSACTION;
BEGIN TRY

    INSERT INTO ss.DIM_Injury (Season, Week, GsisID, FirstName, LastName, FullName, GameType, Team, Position, ReportPrimaryInjury, ReportSecondaryInjury, ReportStatus, PracticePrimaryInjury, PracticeSecondaryInjury, PracticeStatus, DateModified)
    SELECT DISTINCT Season, Week, GsisID, FirstName, LastName, FullName, GameType, Team, Position, ReportPrimaryInjury, ReportSecondaryInjury, ReportStatus, PracticePrimaryInjury, PracticeSecondaryInjury, PracticeStatus, DateModified
    FROM dbo.Injury
    WHERE NOT EXISTS (
        SELECT 1
        FROM ss.DIM_Injury as di
        WHERE di.Season = dbo.Injury.Season
        AND di.Week = dbo.Injury.Week
        AND di.GsisID = dbo.Injury.GsisID
        AND di.DateModified = dbo.Injury.DateModified
    );

    COMMIT TRANSACTION;
    DELETE FROM dbo.Injury;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    INSERT INTO ErrorLog (ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, ErrorMessage)
    VALUES (ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE());
END CATCH

--PlayerProp
BEGIN TRANSACTION;
BEGIN TRY

    INSERT INTO ss.Dim_PlayerProp (PlayerName, EventID, CommenceTime, AwayTeam, HomeTeam, BookmakerKey, BookmakerTitle, MarketKey, OutcomeName, Price, Point, RefreshTime, Week, Season, PlayerID)
    SELECT DISTINCT PlayerName, EventID, CommenceTime, AwayTeam, HomeTeam, BookmakerKey, BookmakerTitle, MarketKey, OutcomeName, Price, Point, RefreshTime, Week, Season, PlayerID
    FROM dbo.PlayerProp;
        COMMIT TRANSACTION;
        DELETE FROM dbo.PlayerProp;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    INSERT INTO ErrorLog (ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, ErrorMessage)
    VALUES (ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE());
END CATCH

--PlayByPlay
BEGIN TRANSACTION;
BEGIN TRY

    INSERT INTO ss.Fact_PlayByPlay(GameID, PlayID, QTR, Drive, Down, Shotgun, NoHuddle, QbDropback, QbScramble, CompletePass, IncompletePass, PassingYards, AirYards, YardsAfterCatch, FirstDownPass,
    PassingTouchdown, ReceivingYards, Interception, Fumble, Sack, RushAttempt, RushingYards, RushingTouchdown, FirstDownRush, FieldGoalAttempt, ExtraPointAttempt, PuntAttempt, KickoffAttempt,
    FieldGoalResult, ExtraPointResult, Safety, Penalty, Season, Week, PasserPlayerID, ReceiverPlayerID, RusherPlayerID, KickerPlayerID)
    SELECT DISTINCT GameID, PlayID, QTR, Drive, Down, Shotgun, NoHuddle, QbDropback, QbScramble, CompletePass, IncompletePass, PassingYards, AirYards, YardsAfterCatch, FirstDownPass,
    PassingTouchdown, ReceivingYards, Interception, Fumble, Sack, RushAttempt, RushingYards, RushingTouchdown, FirstDownRush, FieldGoalAttempt, ExtraPointAttempt, PuntAttempt, KickoffAttempt,
    -- Transformation for FieldGoalResult
    CASE 
        WHEN FieldGoalResult = 'made' THEN 1
        WHEN FieldGoalResult IS NOT NULL THEN 0
        ELSE NULL
    END AS FieldGoalResult,
    -- Transformation for ExtraPointResult
    CASE 
        WHEN ExtraPointResult = 'good' THEN 1
        WHEN ExtraPointResult IS NOT NULL THEN 0
        ELSE NULL
    END AS ExtraPointResult,
    Safety, Penalty, Season, Week, PasserPlayerID, ReceiverPlayerID, RusherPlayerID, KickerPlayerID
    FROM dbo.PlayByPlay
    WHERE NOT EXISTS (
        SELECT 1
        FROM ss.Fact_PlayByPlay as fpbp
        WHERE fpbp.GameID = dbo.PlayByPlay.GameID
        AND fpbp.PlayID = dbo.PlayByPlay.PlayID
    );

    COMMIT TRANSACTION;
    DELETE FROM dbo.PlayByPlay;
END TRY
BEGIN CATCH
    ROLLBACK TRANSACTION;
    INSERT INTO ErrorLog (ErrorNumber, ErrorSeverity, ErrorState, ErrorProcedure, ErrorLine, ErrorMessage)
    VALUES (ERROR_NUMBER(), ERROR_SEVERITY(), ERROR_STATE(), ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE());
END CATCH

END;