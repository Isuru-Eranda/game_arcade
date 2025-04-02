import 'package:cloud_firestore/cloud_firestore.dart';

class ScoreModel {
  final String userId;
  final String userName;
  final String email;
  final String gameName;
  final int score;
  final Timestamp timestamp;

  ScoreModel({
    required this.userId,
    required this.userName,
    required this.email,
    required this.gameName,
    required this.score,
    required this.timestamp,
  });

  // Convert Firestore document to ScoreModel object
  factory ScoreModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ScoreModel(
      userId: data['userId'] ?? '',
      userName: data['userName'] ?? 'Anonymous',
      email: data['email'] ?? '',
      gameName: data['gameName'] ?? '',
      score: data['score'] ?? 0,
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }

  // Convert ScoreModel object to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'email': email,
      'gameName': gameName,
      'score': score,
      'timestamp': timestamp,
    };
  }
}