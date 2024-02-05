import 'package:flutter/material.dart';
import '../entities/game.dart';
import '../widgets/matchup_stats.dart';
import '../widgets/game_odds.dart';

class GameDetailScreen extends StatelessWidget {
  final Game game;

  const GameDetailScreen({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> content;

    if (game.isUpcoming) {
      // Widgets for upcoming games
      content = [
        MatchupStats(game: game),
        GameOdds(game: game),

      ];
    } else {
      // Widgets for past games
      content = [
        MatchupStats(game: game),
        GameOdds(game: game),

      ];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${game.awayTeam} vs ${game.homeTeam}'),
      ),
      body: ListView(children: content),
    );
  }
}


