import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileController with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Get current user profile data
  Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        final DocumentSnapshot userDoc = 
            await _firestore.collection('users').doc(user.uid).get();
        
        if (userDoc.exists) {
          return userDoc.data() as Map<String, dynamic>;
        }
      }
      return null;
    } catch (e) {
      print('Error getting user profile: $e');
      return null;
    }
  }

  // Get user game statistics
  Future<List<Map<String, dynamic>>> getUserGameStats() async {
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        final QuerySnapshot scoreSnapshot = await _firestore
            .collection('scores')
            .where('userId', isEqualTo: user.uid)
            .get();
        
        // Group scores by game
        Map<String, int> gameHighScores = {};
        
        for (var doc in scoreSnapshot.docs) {
          final data = doc.data() as Map<String, dynamic>;
          final String gameId = data['gameId'] ?? '';
          final String gameName = data['gameName'] ?? 'Unknown Game';
          final int score = data['score'] ?? 0;
          
          final String gameKey = '$gameId:$gameName';
          
          if (!gameHighScores.containsKey(gameKey) || score > gameHighScores[gameKey]!) {
            gameHighScores[gameKey] = score;
          }
        }
        
        // Convert to list of game stats
        List<Map<String, dynamic>> gameStats = [];
        gameHighScores.forEach((key, score) {
          final parts = key.split(':');
          final gameId = parts[0];
          final gameName = parts.length > 1 ? parts[1] : 'Unknown Game';
          
          gameStats.add({
            'gameId': gameId,
            'gameName': gameName,
            'highScore': score,
          });
        });
        
        return gameStats;
      }
      return [];
    } catch (e) {
      print('Error getting user game stats: $e');
      return [];
    }
  }
  
  // Update user profile
  Future<String> updateProfile({
    required String name,
    required String email,
  }) async {
    String result = "Error updating profile";
    setLoading(true);
    
    try {
      final User? user = _auth.currentUser;
      if (user != null) {
        // Update email in Firebase Auth if it changed
        if (user.email != email) {
          await user.updateEmail(email);
        }
        
        // Update profile data in Firestore
        await _firestore.collection("users").doc(user.uid).update({
          'name': name,
          'email': email,
        });
        
        result = "success";
      }
    } catch (e) {
      result = e.toString();
    } finally {
      setLoading(false);
    }
    
    return result;
  }
  
  // Update user password
  Future<String> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    String result = "Error updating password";
    setLoading(true);
    
    try {
      final User? user = _auth.currentUser;
      if (user != null && user.email != null) {
        // Reauthenticate user with current password
        AuthCredential credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );
        
        await user.reauthenticateWithCredential(credential);
        
        // Update password
        await user.updatePassword(newPassword);
        
        result = "success";
      }
    } catch (e) {
      result = e.toString();
    } finally {
      setLoading(false);
    }
    
    return result;
  }
  
  // Sign out user
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      notifyListeners();
    } catch (e) {
      print('Error signing out: $e');
    }
  }
}