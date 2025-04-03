import 'package:flutter/material.dart';
import 'package:game_arcade/controllers/leaderboard_controller.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final leaderboardController = LeaderboardController();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Leaderboard'),
        backgroundColor: Colors.orange,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
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
              return ListTile(
                leading: CircleAvatar(
                  child: Text('${index + 1}'),
                  backgroundColor: index == 0 ? Colors.amber : 
                                 index == 1 ? Colors.grey[300] : 
                                 index == 2 ? Colors.brown : Colors.orange,
                ),
                title: Text(
                  user['username'],
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
                ),
                trailing: Text(
                  'Score: ${user['totalScore']}', 
                  style: TextStyle(color: Colors.orange, fontWeight: FontWeight.normal),
                ),
              );
            },
          );
        },
      ),
    );
  }
}