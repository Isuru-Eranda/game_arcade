import 'package:flutter/material.dart';
import 'package:game_arcade/games/game2/screens/game_screen.dart' as game2;
import 'package:game_arcade/screens/dino_game.dart'; // Import DinoGame screen
import 'package:game_arcade/screens/game_submission_form.dart';
import 'package:game_arcade/screens/leaderboard_screen.dart';
import 'package:game_arcade/screens/notification_screen.dart'; // Using existing file
import 'package:game_arcade/screens/tetris_game_screen.dart'; // Add Tetris game screen import
import 'package:game_arcade/screens/user_profile_screen.dart';

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
    const NotificationScreen(), // Notifications screen
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
        items: const [
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
              child: Icon(Icons.notifications),
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
      body: Stack(
        children: [
          IndexedStack(
            index: _selectedIndex,
            children: _screens,
          ),
          // Show the Add Game button only on the Home tab
          if (_selectedIndex == 0)
            Positioned(
              left: 0,
              right: 0,
              bottom: 40, // Position above the bottom navigation bar
              child: Center(
                child: SizedBox(
                  width: 250, // Set width for the long button
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const GameSubmissionForm()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32.0),
                      ),
                    ),
                    child: const Text(
                      'Add Game',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
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
              padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 60.0), // Reduced vertical padding from 80.0 to 40.0
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
          Expanded(child: _buildGameGrid(context)), // Removed SizedBox height between title and grid
        ],
      ),
    );
  }

  Widget _buildGameGrid(BuildContext context) {
    // Kept only the three specified games
    List<String> games = [
      "Dino Run",
      "FlappyBird",
      "Tetris",
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 70.0, vertical: 10.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Changed to 1 column since we only have 3 games now
          crossAxisSpacing: 0,
          mainAxisSpacing: 20, // Added some vertical spacing between games
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
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.orange,
                          width: 4.0,
                        ),
                      ),
                      padding: EdgeInsets.zero,
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
      return ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.asset(
          'assets/images/dino.png',
          height: 100,
          width: 100,
          fit: BoxFit.cover,
        ),
      );
    } else if (gameName == "FlappyBird") {
      return ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.asset(
          'assets/images/flappybird.png',
          height: 100,
          width: 100,
          fit: BoxFit.cover,
        ),
      );
    } else if (gameName == "Tetris") {
      return ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: Image.asset(
          'assets/images/tetris.png',
          height: 100,
          width: 100,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return Icon(
        Icons.videogame_asset,
        size: 40,
        color: Colors.white,
      );
    }
  }
}
