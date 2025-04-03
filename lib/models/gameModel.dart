import 'package:cloud_firestore/cloud_firestore.dart';

class Game {
  final String id;
  final String title;
  final String description;
  final String category;
  final String status;
  final Timestamp createdAt;

  Game({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.status,
    required this.createdAt,
  });

  // Convert Firestore document to Game object
  factory Game.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Game(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      status: data['status'] ?? 'active',
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  // Convert Game object to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'status': status,
      'createdAt': createdAt,
    };
  }
}