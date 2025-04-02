import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ScoreController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Save the score to Firestore
  Future<void> saveScore({
    required String gameName,
    required int score,
  }) async {
    try {
      // Get the current user's details
      final User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('User is not logged in.');
      }

      // Fetch the user's name from Firestore if displayName is not set
      String userName = user.displayName ?? 'Anonymous';
      if (user.displayName == null || user.displayName!.isEmpty) {
        final userDoc = await _firestore.collection('users').doc(user.uid).get();
        if (userDoc.exists) {
          userName = userDoc.data()?['name'] ?? 'Anonymous';
        }
      }

      // Save the score to Firestore
      await _firestore.collection('scores').add({
        'userId': user.uid,
        'userName': userName,
        'email': user.email ?? 'anonymous@example.com',
        'gameName': gameName,
        'score': score,
        'timestamp': FieldValue.serverTimestamp(),
      });

      print('Score saved successfully for game: $gameName');
    } catch (e) {
      print('Error saving score: $e');
    }
  }
}