import 'package:cloud_firestore/cloud_firestore.dart';

class LeaderboardController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch leaderboard data by aggregating scores from the 'scores' collection
  Future<List<Map<String, dynamic>>> fetchLeaderboard() async {
    try {
      print('Attempting to fetch leaderboard data from Firestore...');

      // Query the 'scores' collection to get all user scores
      QuerySnapshot scoresSnapshot = await _firestore.collection('scores').get();

      print('Received ${scoresSnapshot.docs.length} score documents from Firestore');

      // Map to store total scores grouped by userId
      Map<String, Map<String, dynamic>> userScores = {};

      for (var doc in scoresSnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        String userId = data['userId'] ?? '';
        String userName = data['userName'] ?? 'Unknown';
        int score = data['score'] ?? 0;

        if (userId.isNotEmpty) {
          if (!userScores.containsKey(userId)) {
            // Initialize user entry if not already present
            userScores[userId] = {
              'username': userName,
              'totalScore': 0,
            };
          }

          // Add the score to the user's total score
          userScores[userId]!['totalScore'] += score;
        }
      }

      // Convert the map to a sorted list
      List<Map<String, dynamic>> leaderboard = userScores.values.toList();

      // Sort the leaderboard by totalScore in descending order
      leaderboard.sort((a, b) => b['totalScore'].compareTo(a['totalScore']));

      print('Processed leaderboard data: $leaderboard');
      return leaderboard;
    } catch (e) {
      print('Error fetching leaderboard: $e');
      throw Exception('Failed to load leaderboard: $e');
    }
  }
}