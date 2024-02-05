import 'package:flutter/material.dart';
import '../entities/game.dart';

class GameOdds extends StatelessWidget {
  final Game game;

  const GameOdds({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('SPREAD', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('TOTAL', style: TextStyle(fontWeight: FontWeight.bold)),
              Text('MONEYLINE', style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 8.0), // Spacing between the headers and the values
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Assuming these fields exist in your Game class
              Text('${game.spreadLine != null ? (game.spreadLine! > 0 ? "+" : "") + game.spreadLine!.toString() : "N/A"} (${game.homeSpreadOdds?.toString() ?? "N/A"})'),
              Text('O${game.totalLine.toString()} (${game.overOdds})\nU${game.totalLine.toString()} (${game.underOdds})'),
              Text(
                  '${game.awayMoneyline != null ? (game.awayMoneyline! > 0 ? "+" : "") + game.awayMoneyline!.toString() : "N/A"}\n'
                      '${game.homeMoneyline != null ? (game.homeMoneyline! > 0 ? "+" : "") + game.homeMoneyline!.toString() : "N/A"}'
              ),
            ],
          ),
        ],
      ),
    );
  }
}
