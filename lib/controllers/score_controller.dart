import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'notification_controller.dart';
import 'package:game_arcade/models/notification_model.dart';

class ScoreController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // Define milestone values
  final List<int> milestones = [1000, 5000, 10000];
  final NotificationController _notificationController =
      NotificationController();

  // Function to check and send milestone notification
  Future<void> checkAndNotifyMilestone(String userId) async {
    try {
      // Retrieve total score of the user
      QuerySnapshot scoresSnapshot = await _firestore
          .collection("scores")
          .where("userId", isEqualTo: userId)
          .get();

      int totalScore = scoresSnapshot.docs.fold(0, (sum, doc) {
        return sum + (doc["score"] as int);
      });

      print("User $userId total score: $totalScore");

      // Find the highest milestone reached
      int? milestoneReached = milestones
          .lastWhere((milestone) => totalScore >= milestone, orElse: () => -1);

      if (milestoneReached != -1) {
        // Retrieve user's FCM token from Firestore (assuming it's stored)
        DocumentSnapshot userDoc =
            await _firestore.collection("users").doc(userId).get();

        String title = "🎉 Milestone Reached!";
        String body =
            "You've reached $milestoneReached total points across all games!";

        // Safely check if FCM token exists before using it
        if (userDoc.exists &&
            userDoc.data() != null &&
            (userDoc.data() as Map<String, dynamic>).containsKey("fcmToken") &&
            userDoc["fcmToken"] != null) {
          String userToken = userDoc["fcmToken"];
          await sendNotification(userToken, title, body);
        } else {
          // No FCM token available, just add in-app notification
          addInAppNotification(title, body);
        }

        // Record milestone in Firestore to prevent duplicate notifications
        await _firestore.collection("user_milestones").add({
          'userId': userId,
          'milestone': milestoneReached,
          'achievedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print("Error checking milestone: $e");
    }
  }

  // Function to send notification - now supporting both push and in-app
  Future<void> sendNotification(String token, String title, String body) async {
    try {
      // 1. Implement your FCM push notification logic here
      print("Sending push notification to $token: $title - $body");

      // 2. Also add the notification to the in-app notification system
      addInAppNotification(title, body);
    } catch (e) {
      print("Error sending notification: $e");
    }
  }

  // Helper method to add in-app notification
  void addInAppNotification(String title, String body) {
    _notificationController.addNotification(NotificationItem(
      title: title,
      message: body,
      time: _getCurrentTime(),
      isRead: false,
    ));
  }

  // Get current time formatted for notifications
  String _getCurrentTime() {
    final now = DateTime.now();
    return "Just now";
  }

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
        final userDoc =
            await _firestore.collection('users').doc(user.uid).get();
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
      checkAndNotifyMilestone(user.uid);
    } catch (e) {
      print('Error saving score: $e');
    }
  }
}
