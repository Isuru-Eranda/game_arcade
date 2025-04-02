import 'package:cloud_firestore/cloud_firestore.dart';

class GameSubmission {
  final String title;
  final String description;
  final String gameFileUrl;
  final String gamePictureUrl;
  final String email;
  final String status;
  final Timestamp submittedAt;

  GameSubmission({
    required this.title,
    required this.description,
    required this.gameFileUrl,
    required this.gamePictureUrl,
    required this.email,
    required this.status,
    required this.submittedAt,
  });

  // Convert Firestore document to GameSubmission object
  factory GameSubmission.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GameSubmission(
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      gameFileUrl: data['gameFileUrl'] ?? '',
      gamePictureUrl: data['gamePictureUrl'] ?? '',
      email: data['email'] ?? '',
      status: data['status'] ?? 'pending',
      submittedAt: data['submittedAt'] ?? Timestamp.now(),
    );
  }

  // Convert GameSubmission object to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'gameFileUrl': gameFileUrl,
      'gamePictureUrl': gamePictureUrl,
      'email': email,
      'status': status,
      'submittedAt': submittedAt,
    };
  }
}