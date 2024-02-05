import 'package:flutter/material.dart';
import '../entities/game.dart';
import 'package:intl/intl.dart';
import '../screens/game_detail_screen.dart';

class GameItem extends StatelessWidget {
  final Game game;

  const GameItem({Key? key, required this.game}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    Color primaryTextColor = Colors.black54;
    Color secondaryTextColor = Colors.black87;

    TextStyle teamStyle = TextStyle(
      color: primaryTextColor,
      fontWeight: FontWeight.bold,
      fontSize: 18,
    );
    TextStyle scoreStyle = TextStyle(
      color: secondaryTextColor,
      fontWeight: FontWeight.bold,
      fontSize: 24,
    );
    TextStyle dateStyle = const TextStyle(
      color: Colors.grey,
      fontSize: 16,
    );

    bool isGameFinished = game.awayScore != null && game.homeScore != null;
    String scoreText = isGameFinished ? '${game.awayScore} - ${game.homeScore}' : 'TBD';
    String gameDateTimeText = game.gameDay != null
        ? '${DateFormat('EEE, MMM d').format(game.gameDay!)} at ${DateFormat('h:mm a').format(game.gameDay!)}'
        : 'Date/Time TBD';

    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => GameDetailScreen(game: game),
          ),
        );
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey[300]!, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Icon(Icons.sports_football, size: 50, color: secondaryTextColor),
                        Text(game.awayTeam, style: teamStyle),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          isGameFinished ? 'Final' : 'Upcoming',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isGameFinished ? Colors.red : primaryTextColor,
                          ),
                        ),
                        Text(scoreText, style: scoreStyle),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Icon(Icons.sports_football, size: 50, color: secondaryTextColor),
                        Text(game.homeTeam, style: teamStyle),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(gameDateTimeText, style: dateStyle),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
