import 'package:flutter/material.dart';
import 'package:game_arcade/games/game2/screens/game_screen.dart' as game2;
import 'package:game_arcade/screens/dino_game.dart'; // Import DinoGame screen
import 'package:game_arcade/screens/game_submission_form.dart';
import 'package:game_arcade/screens/leaderboard_screen.dart';
import 'package:game_arcade/screens/notifications_screens.dart';
import 'package:game_arcade/screens/tetris_game_screen.dart'; // Add Tetris game screen import
import 'package:game_arcade/screens/user_profile_screen.dart';
import 'game_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Track the selected tab

  // List of screens for each tab
  final List<Widget> _screens = [
    const HomeContent(), // Home content
    const LeaderboardScreen(), // Leaderboard screen
    const NotificationsScreen(), // Notifications screen
    const UserProfileScreen(), // User Profile screen
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFFD9801),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.emoji_events), label: 'Leaderboard'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'Notifications'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const GameSubmissionForm()),
                );
              },
              backgroundColor: Colors.orange,
              child: const Icon(Icons.add),
            )
          : null, // Show FAB only on the Home tab
    );
  }
}

// Home content widget
class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 10),
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: Text(
                'GAME HUB',
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.normal,
                  color: Colors.orange,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(child: _buildGameGrid(context)),
        ],
      ),
    );
  }

  Widget _buildGameGrid(BuildContext context) {
    // Games list including Dino Run and FlappyBird
    List<String> games = [
      "Dino Run",
      "Adventure",
      "Sports",
      "Puzzle",
      "FlappyBird",
      "Tetris", // Add Tetris to the games list
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 36.0, vertical: 36.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 28,
          mainAxisSpacing: 28,
          childAspectRatio: 0.85, // Adjusted for name below icon
        ),
        itemCount: games.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              if (games[index] == "Dino Run") {
                // Navigate to DinoGame
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyHomePage(title: 'Dino Run'),
                  ),
                );
              } else if (games[index] == "FlappyBird") {
                // Navigate to FlappyBird (game2) screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const game2.GameScreen(),
                  ),
                );
              } else if (games[index] == "Tetris") {
                // Navigate to Tetris game screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TetrisGameScreen(),
                  ),
                );
              } else {
                // Navigate to GameDetailScreen for other games
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        GameDetailScreen(gameName: games[index]),
                  ),
                );
              }
            },
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Container(
                      // Using styling from the shiraz branch
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: _buildGameIcon(games[index]),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  games[index],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // Helper method to build the game icon or image
  Widget _buildGameIcon(String gameName) {
    if (gameName == "Dino Run") {
      return Image.asset(
        'assets/images/dono.jpg', // Path to Dino Run image
        height: 80,
        width: 80,
        fit: BoxFit.cover,
      );
    } else if (gameName == "FlappyBird") {
      return Image.asset(
        'assets/images/flappybird_icon.png', // Path to FlappyBird image
        height: 80,
        width: 80,
        fit: BoxFit.cover,
      );
    } else if (gameName == "Tetris") {
      // Use a special icon for Tetris
      return Icon(
        Icons.grid_3x3,
        size: 40,
        color: Colors.purple,
      );
    } else {
      return Icon(
        _getIconForGame(gameName),
        size: 40,
        color: Colors.white,
      );
    }
  }

  IconData _getIconForGame(String gameName) {
    switch (gameName) {
      case "Adventure":
        return Icons.castle;
      case "Sports":
        return Icons.sports_soccer;
      case "Puzzle":
        return Icons.extension;
      case "Tetris":
        return Icons.grid_3x3;
      case "Shooter":
        return Icons.sports_esports;
      case "Strategy":
        return Icons.psychology;
      default:
        return Icons.videogame_asset;
    }
  }
}
