import 'package:flutter/material.dart';
import 'package:game_arcade/games/game2/screens/game_screen.dart' as game2;
import 'package:game_arcade/screens/dino_game.dart'; // Import DinoGame screen
import 'package:game_arcade/screens/game_submission_form.dart';
import 'package:game_arcade/screens/leaderboard_screen.dart';
import 'package:game_arcade/screens/notifications_screens.dart';
import 'package:game_arcade/screens/tetris_game_screen.dart'; // Add Tetris game screen import
import 'package:game_arcade/screens/user_profile_screen.dart';
import 'game_detail_screen.dart';
import 'package:flutter/material.dart';
import 'notification_screen.dart';

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
        showSelectedLabels: false, // Hide selected item labels
        showUnselectedLabels: false, // Hide unselected item labels
        iconSize: 40.0, // Increased icon size
        // Settings to bring icons closer to center
        landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
        unselectedIconTheme: const IconThemeData(size: 40.0),
        selectedIconTheme: const IconThemeData(size: 40.0),
        // Adding horizontal padding to push icons closer to center
        elevation: 0,
        items: [
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Icon(Icons.home),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: Icon(Icons.emoji_events),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NotificationScreen()),
                  );
                },
                tooltip: 'Notifications',
              ),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Icon(Icons.person),
            ),
            label: '',
          ),
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
          const SizedBox(height: 2),
          const Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 80.0),
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
          const SizedBox(
              height: 0), // Removed vertical space between title and grid
          Expanded(child: _buildGameGrid(context)),
        ],
      ),
    );
  }

  Widget _buildGameGrid(BuildContext context) {
    // Games list with FlappyBird as the second game in the first row
    List<String> games = [
      "Dino Run",
      "FlappyBird",
      "Adventure",
      "Sports",
      "Puzzle",
      "Tetris", // Added Tetris to the games list
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 70.0, vertical: 10.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 0, // Removed all horizontal spacing between icons
          mainAxisSpacing: 0, // Removed all vertical spacing between icons
          childAspectRatio: 0.9,
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
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.orange,
                          width: 4.0,
                        ),
                      ),
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: _buildGameIcon(games[index]),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 0),
                Text(
                  games[index],
                  style: const TextStyle(
                    color: Colors.orange,
                    fontSize: 20,
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
        Icons.grid_view,
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
        return Icons.grid_view;
      case "Shooter":
        return Icons.sports_esports;
      case "Strategy":
        return Icons.psychology;
      default:
        return Icons.videogame_asset;
    }
  }
}
