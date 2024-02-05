import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import '../entities/player.dart';
import '../utils/jersey_painter.dart'; // Make sure this path is correct

class PlayersScreen extends StatefulWidget {
  @override
  _PlayersScreenState createState() => _PlayersScreenState();
}

class _PlayersScreenState extends State<PlayersScreen> {
  List<Player> _players = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMockData();
  }

  Future<void> _loadMockData() async {
    try {
      // Load the JSON data from assets
      final String jsonString = await rootBundle.loadString('assets/data/mock_player.json');
      final List<dynamic> playerJsonList = json.decode(jsonString) as List<dynamic>;

      // Use your Player.fromJson here
      final List<Player> players = playerJsonList.map((json) => Player.fromJson(json)).toList();

      setState(() {
        _players = players;
        _isLoading = false;
      });
    } catch (e) {
      // Handle errors, such as a failed JSON load or parse error
      setState(() {
        _isLoading = false;
      });
      print('Error loading mock data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Players'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _players.length,
        itemBuilder: (context, index) {
          final player = _players[index];
          // Determine the jersey color for each team (you will need to implement this method)
          Color jerseyColor = _getJerseyColorForTeam(player.team);
          return ListTile(
            title: Text(player.fullName),
            subtitle: Text('${player.position} - ${player.team}'),
            leading: CustomPaint(
              painter: JerseyIconPainter(jerseyColor: jerseyColor), // Your JerseyIconPainter
              child: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                child: Text(
                  player.jerseyNumber?.toString() ?? '',
                  style: TextStyle(
                    color: Colors.white, // Make sure this is visible on the jersey
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Color _getJerseyColorForTeam(String? team) {
    // Define a method that returns a color based on the team's name
    // For demonstration, let's assume all jerseys are blue
    return Colors.blue;
    // You would have logic here to return different colors for different teams
  }
}
