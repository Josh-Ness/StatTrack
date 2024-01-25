import 'package:flutter/material.dart';


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

  factory Game.fromJson(Map<String, dynamic> json) {
    // Parse gameDay and gameTime to create a DateTime object
    DateTime? gameDateTime;
    if (json['GameDay'] != null && json['GameTime'] != null) {
      final datePart = DateTime.parse(json['GameDay'] as String);
      final timePart = TimeOfDay.fromDateTime(DateTime.parse('2000-01-01 ' + json['GameTime']));
      gameDateTime = DateTime(
        datePart.year,
        datePart.month,
        datePart.day,
        timePart.hour,
        timePart.minute,
      );
    }

    return Game(
      gameId: json['GameID'] as String,
      season: json['Season'] as int,
      week: json['Week'] as int,
      gameType: json['GameType'] as String,
      //gameDay: json['GameDay'] != null ? DateTime.parse(json['GameDay'] as String) : null,
      gameDay: gameDateTime, //Combined date time
      weekDay: json['WeekDay'] as String?,
      gameTime: json['GameTime'] as String?,
      location: json['Location'] as String?,
      awayTeam: json['AwayTeam'] as String,
      homeTeam: json['HomeTeam'] as String,
      divGame: json['DivGame'] == "1", //Loads in as a string, convert to bool
      awayScore: json['AwayScore'] as int?,
      homeScore: json['HomeScore'] as int?,
      total: json['Total'] as int?,
      overtime: json['Overtime'] == "1",
      result: json['Result'] as int?,
      awayRest: json['AwayRest'] as int?,
      homeRest: json['HomeRest'] as int?,
      stadiumID: json['StadiumID'] as String?,
      stadiumName: json['StadiumName'] as String?,
      roof: json['Roof'] as String?,
      surface: json['Surface'] as String?,
      temp: json['Temp'] as int?,
      wind: json['Wind'] as int?,
      awayMoneyline: json['AwayMoneyline'] as int?,
      homeMoneyline: json['HomeMoneyline'] as int?,
      spreadLine: json['SpreadLine'] as double?,
      homeSpreadOdds: json['HomeSpreadOdds'] as int?,
      awaySpreadOdds: json['AwaySpreadOdds'] as int?,
      totalLine: json['TotalLine'] as double?,
      underOdds: json['UnderOdds'] as int?,
      overOdds: json['OverOdds'] as int?,
    );
  }

}
