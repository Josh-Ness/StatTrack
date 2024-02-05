import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../entities/player.dart';
import '../entities/game.dart';
import '../entities/injury.dart';
import '../entities/play.dart';

class MockDataService {
  Future<List<Player>> loadMockPlayers() async {
    final String playersJsonString = await rootBundle.loadString('assets/data/mock_player.json');
    final List<dynamic> playerList = json.decode(playersJsonString) as List<dynamic>;
    return playerList.map((json) => Player.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<List<Game>> loadMockGames() async {
    final String gamesJsonString = await rootBundle.loadString('assets/data/mock_game.json');
    final List<dynamic> gameList = json.decode(gamesJsonString) as List<dynamic>;
    return gameList.map((json) => Game.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<List<Injury>> loadMockInjuries() async {
    final String injuriesJsonString = await rootBundle.loadString('assets/data/mock_injury.json');
    final List<dynamic> injuryList = json.decode(injuriesJsonString) as List<dynamic>;
    return injuryList.map((json) => Injury.fromJson(json as Map<String, dynamic>)).toList();
  }

  Future<List<PlayByPlay>> loadMockPlays() async {
    final String playsJsonString = await rootBundle.loadString('assets/data/mock_play.json');
    final List<dynamic> playList = json.decode(playsJsonString) as List<dynamic>;
    return playList.map((json) => PlayByPlay.fromJson(json as Map<String, dynamic>)).toList();
  }
}
