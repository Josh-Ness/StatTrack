import 'package:flutter/material.dart';
import 'games_screen.dart';
import 'players_screen.dart';
import 'teams_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // Start with index 0 (GamesScreen)

  // Widgets activated upon respective tab being clicked
  final List<Widget> _widgetOptions = <Widget>[
    GamesScreen(),
    PlayersScreen(),
    TeamsScreen(),

  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Updates index when a _widgetOption is selected
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_football),
            label: 'Games',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Players',
          ),
        BottomNavigationBarItem(
        icon: Icon(Icons.sports_football),
        label: 'Teams',
        ),

        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
