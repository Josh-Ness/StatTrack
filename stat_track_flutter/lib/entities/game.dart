class Game {
  final String gameId;
  final int season;
  final int week;
  final String gameType;
  final DateTime? gameDay;
  final String? weekDay;
  final String? gameTime;
  final String? location;
  final String awayTeam;
  final String homeTeam;
  final bool? divGame;
  final int? awayScore;
  final int? homeScore;
  final int? total;
  final bool? overtime;
  final int? result;
  final int? awayRest;
  final int? homeRest;
  final String? stadiumID;
  final String? stadiumName;
  final String? roof;
  final String? surface;
  final int? temp;
  final int? wind;
  final int? awayMoneyline;
  final int? homeMoneyline;
  final double? spreadLine;
  final int? homeSpreadOdds;
  final int? awaySpreadOdds;
  final double? totalLine;
  final int? underOdds;
  final int? overOdds;

  Game({
    required this.gameId,
    required this.season,
    required this.week,
    required this.gameType,
    this.gameDay,
    this.weekDay,
    this.gameTime,
    this.location,
    required this.awayTeam,
    required this.homeTeam,
    this.divGame,
    this.awayScore,
    this.homeScore,
    this.total,
    this.overtime,
    this.result,
    this.awayRest,
    this.homeRest,
    this.stadiumID,
    this.stadiumName,
    this.roof,
    this.surface,
    this.temp,
    this.wind,
    this.awayMoneyline,
    this.homeMoneyline,
    this.spreadLine,
    this.homeSpreadOdds,
    this.awaySpreadOdds,
    this.totalLine,
    this.underOdds,
    this.overOdds,
  });
}
