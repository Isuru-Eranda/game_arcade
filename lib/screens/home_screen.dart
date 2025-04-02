import 'package:flutter/material.dart';
import 'package:game_arcade/screens/dino_game.dart'; 
import 'package:game_arcade/screens/game_submission_form.dart';
import 'package:game_arcade/screens/leaderboard_screen.dart';
import 'package:game_arcade/screens/notifications_screens.dart';
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
          BottomNavigationBarItem(icon: Icon(Icons.emoji_events), label: 'Leaderboard'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifications'),
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
                  MaterialPageRoute(builder: (context) => const GameSubmissionForm()),
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
        crossAxisAlignment: CrossAxisAlignment.center, // Changed to center
        children: [
          const SizedBox(height: 10),
          const Center( // Added Center widget
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: Text(
                'GAME HUB',
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.normal, // Changed from bold to normal
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
    // Take only the first 4 games for a 2x2 grid
    List<String> games = [
      "Dino Run",
      "Adventure",
      "Sports",
      "Puzzle",
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
              } else {
                // Navigate to GameDetailScreen for other games
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GameDetailScreen(gameName: games[index]),
                  ),
                );
              }
            },
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.25, // Adjusted container size
                      height: MediaQuery.of(context).size.width * 0.25, // Adjusted container size
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange, width: 2), // Made border thinner
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0), // Small padding inside the border
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: index == 0 ? 
                            Image.asset(
                              'assets/images/dono.jpg',
                              fit: BoxFit.contain, // Changed to contain to prevent cropping
                            ) :
                            Container(
                              color: Colors.grey[800],
                              child: Center(
                                child: Icon(
                                  _getIconForGame(games[index]),
                                  size: 40, // Adjusted icon size
                                  color: Colors.white,
                                ),
                              ),
                            ),
                        ),
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
                    fontWeight: FontWeight.normal, // Changed from bold to normal
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  IconData _getIconForGame(String gameName) {
    switch (gameName) {
      case "Adventure":
        return Icons.castle;
      case "Sports":
        return Icons.sports_soccer;
      case "Puzzle":
        return Icons.extension;
      case "Shooter":
        return Icons.sports_esports;
      case "Strategy":
        return Icons.psychology;
      default:
        return Icons.videogame_asset;
    }
  }
}
