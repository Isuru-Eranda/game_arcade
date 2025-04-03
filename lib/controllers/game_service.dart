import 'package:cloud_firestore/cloud_firestore.dart';

class GameService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all games
  Stream<QuerySnapshot> fetchGames() {
    return _firestore.collection('games').snapshots();
  }

  // Add a new game
  Future<void> addGame(Map<String, dynamic> gameData) async {
    try {
      await _firestore.collection('games').add(gameData);
    } catch (e) {
      throw Exception('Error adding game: $e');
    }
  }

  // Update a game
  Future<void> updateGame(String gameId, Map<String, dynamic> updatedData) async {
    try {
      await _firestore.collection('games').doc(gameId).update(updatedData);
    } catch (e) {
      throw Exception('Error updating game: $e');
    }
  }

  // Delete a game
  Future<void> deleteGame(String gameId) async {
    try {
      await _firestore.collection('games').doc(gameId).delete();
    } catch (e) {
      throw Exception('Error deleting game: $e');
    }
  }
}