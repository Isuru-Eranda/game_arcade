import 'package:flutter/material.dart';
import 'package:game_arcade/games/game2/screens/game_screen.dart' as game2;
import 'package:game_arcade/screens/dino_game.dart'; // Import DinoGame screen
import 'package:game_arcade/screens/game_submission_form.dart';
import 'package:game_arcade/screens/leaderboard_screen.dart'; // Import Leaderboard screen
import 'package:game_arcade/screens/notifications_screens.dart'; // Import Notifications screen
import 'package:game_arcade/screens/user_profile_screen.dart'; // Import User Profile screen
import 'game_detail_screen.dart';
import 'package:game_arcade/screens/flappy_bird_game_screen.dart';

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
      backgroundColor: Colors.black,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Text(
              'GAME HUB',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 10),
          _buildCategoryTabs(),
          Expanded(child: _buildGameGrid(context)),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    List<String> categories = ["Adventure", "Sports", "Puzzle", "Shooter"];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: categories
              .map(
                (category) => Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Chip(
                    label: Text(category),
                    backgroundColor: Colors.grey[800],
                    labelStyle: const TextStyle(color: Colors.white),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildGameGrid(BuildContext context) {
    List<String> games = [
      "Adventure",
      "Sports",
      "Puzzle",
      "Shooter",
      "Dino Run",
      "FlappyBird" // Add FlappyBird to the list
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const game2.GameScreen(), // Correctly points to FlappyBirdGame
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
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (games[index] == "Dino Run")
                    Image.asset(
                      'assets/images/dono.jpg', // Path to Dino Run image
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                  if (games[index] == "FlappyBird")
                    Image.asset(
                      'assets/images/flappybird_icon.png', // Path to FlappyBird image
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                  const SizedBox(height: 10),
                  Text(
                    games[index],
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
