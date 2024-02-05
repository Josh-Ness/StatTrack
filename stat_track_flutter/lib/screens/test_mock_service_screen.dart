import 'package:flutter/material.dart';
import '../entities/player.dart';
import '../entities/game.dart';
import '../entities/injury.dart';
import '../entities/play.dart';
import '../services/mock_data_service.dart';

class TestMockDataServiceScreen extends StatelessWidget {
  final MockDataService mockDataService = MockDataService();

  TestMockDataServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Test Mock Data Service'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Players'),
              Tab(text: 'Games'),
              Tab(text: 'Injuries'),
              Tab(text: 'Plays'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildPlayersTab(),
            _buildGamesTab(),
            _buildInjuriesTab(),
            _buildPlaysTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildPlayersTab() {
    return FutureBuilder<List<Player>>(
      future: mockDataService.loadMockPlayers(),
      builder: (context, snapshot) => _buildListSnapshot(
          snapshot, (player) => Text(player.fullName ?? 'No Name')),
    );
  }

  Widget _buildGamesTab() {
    return FutureBuilder<List<Game>>(
      future: mockDataService.loadMockGames(),
      builder: (context, snapshot) => _buildListSnapshot(
          snapshot, (game) => Text('${game.homeTeam} vs ${game.awayTeam}')),
    );
  }

  Widget _buildInjuriesTab() {
    return FutureBuilder<List<Injury>>(
      future: mockDataService.loadMockInjuries(),
      builder: (context, snapshot) => _buildListSnapshot(snapshot,
          (injury) => Text('${injury.fullName ?? 'Unknown'} - ${injury.team}')),
    );
  }

  Widget _buildPlaysTab() {
    return FutureBuilder<List<PlayByPlay>>(
      future: mockDataService.loadMockPlays(),
      builder: (context, snapshot) => _buildListSnapshot(
          snapshot, (play) => Text('Play ID: ${play.playId}')),
    );
  }

  Widget _buildListSnapshot<T>(
      AsyncSnapshot<List<T>> snapshot, Widget Function(T) itemBuilder) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    } else if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const Center(child: Text('No data found'));
    } else {
      return ListView.builder(
        itemCount: snapshot.data!.length,
        itemBuilder: (context, index) => ListTile(
          title: itemBuilder(snapshot.data![index]),
        ),
      );
    }
  }
}
