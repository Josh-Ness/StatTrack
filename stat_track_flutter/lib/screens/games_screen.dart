import 'package:flutter/material.dart';
import '../entities/game.dart';
import '../widgets/game_item.dart';
import 'dart:convert';

class GamesScreen extends StatefulWidget {
  const GamesScreen({super.key});

  @override
  _GamesScreenState createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> {
  late Future<List<Game>> _gamesFuture;

  @override
  void initState() {
    super.initState();
    _gamesFuture = loadMockGames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NFL Games')),
      body: FutureBuilder<List<Game>>(
        future: _gamesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // If needed, display loading bar. Not expected to be relevant in current stages, maybe future.
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Error message if needed for debugging
            return Center(child: Text('Error: ${snapshot.error.toString()}'));
          } else if (!snapshot.hasData) {
            // If no recent or upcoming games, display message
            return const Center(child: Text('No games found'));
          } else {
            //Successful load
            List<Game> games = snapshot.data!;
            return ListView.builder(
              itemCount: games.length,
              itemBuilder: (context, index) {
                Game game = games[index];
                // Use the custom GameItem widget to display each game
                return GameItem(game: game);
              },
            );
          }
        },
      ),
    );
  }


  Future<List<Game>> loadMockGames() async {
    // This loads data from JSON but will need to be altered once connected to DB
    String jsonString = await DefaultAssetBundle.of(context).loadString('assets/data/mock_game.json');
    List<Game> allGames = (json.decode(jsonString) as List).map((e) => Game.fromJson(e)).toList();

    // Hardcode to filter for weeks 5 and 6
    List<int> hardcodedWeeks = [19,20];
    List<Game> gamesForSelectedWeeks = allGames.where((game) => hardcodedWeeks.contains(game.week)).toList();

    return gamesForSelectedWeeks;
  }
}