import 'package:flutter/material.dart';
import 'package:game_arcade/controllers/leaderboard_controller.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final leaderboardController = LeaderboardController();

    return Scaffold(
      backgroundColor: Colors.transparent,
      // Removed app bar as requested
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Added extra padding at the top to lower the title
              const SizedBox(height: 40),
              // New title with orange color and size 28
              const Center(
                child: Text(
                  'Leaderboard',
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 28,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              // Increased the gap between title and content
              const SizedBox(height: 30),
              Expanded(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: leaderboardController.fetchLeaderboard(),
                  builder: (context, snapshot) {
                    // Debug info
                    print('LeaderboardScreen connection state: ${snapshot.connectionState}');
                    print('LeaderboardScreen error: ${snapshot.error}');
                    print('LeaderboardScreen has data: ${snapshot.hasData}');
                    
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(color: Colors.orange),
                            SizedBox(height: 20),
                            Text('Loading leaderboard...', style: TextStyle(color: Colors.orange)),
                          ],
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error, color: Colors.red, size: 48),
                            SizedBox(height: 16),
                            Text('Error: ${snapshot.error}', style: TextStyle(color: Colors.orange)),
                            ElevatedButton(
                              onPressed: () => Navigator.pushReplacement(
                                context, 
                                MaterialPageRoute(builder: (_) => const LeaderboardScreen()),
                              ),
                              child: Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.leaderboard, color: Colors.grey, size: 48),
                            SizedBox(height: 16),
                            Text('No leaderboard data available', style: TextStyle(color: Colors.orange)),
                          ],
                        ),
                      );
                    }

                    final leaderboard = snapshot.data!;

                    return ListView.builder(
                      itemCount: leaderboard.length,
                      itemBuilder: (context, index) {
                        final user = leaderboard[index];
                        // Changed to use Card widget instead of ListTile
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6.0),
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(
                                color: Colors.orange,
                                width: 2.0,
                              ),
                            ),
                            color: Colors.black45,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  // Rank circle
                                  CircleAvatar(
                                    radius: 24,
                                    child: Text(
                                      '${index + 1}',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    backgroundColor: index == 0 ? Colors.amber : 
                                                     index == 1 ? Colors.grey[300] : 
                                                     index == 2 ? Colors.brown : Colors.orange,
                                  ),
                                  const SizedBox(width: 16),
                                  // Username
                                  Expanded(
                                    child: Text(
                                      user['username'],
                                      style: const TextStyle(
                                        color: Colors.white, 
                                        fontWeight: FontWeight.normal,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                  // Score
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      'Score: ${user['totalScore']}', 
                                      style: const TextStyle(
                                        color: Colors.orange, 
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}