import 'package:cloud_firestore/cloud_firestore.dart';

class AdminService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Approve a submission and add it to the games collection
  Future<void> approveSubmission(String documentId, Map<String, dynamic> gameData) async {
    try {
      // Update the status of the submission to "approved"
      await _firestore.collection('game_submissions').doc(documentId).update({
        'status': 'approved',
      });

      // Add the approved game to the "games" collection
      await _firestore.collection('games').add({
        'title': gameData['title'],
        'description': gameData['description'],
        'category': gameData['category'] ?? 'Uncategorized', // Default category
        'status': 'active',
        'createdAt': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Error approving game: $e');
    }
  }

  // Reject a submission
  Future<void> rejectSubmission(String documentId) async {
    try {
      await _firestore.collection('game_submissions').doc(documentId).update({
        'status': 'rejected',
      });
    } catch (e) {
      throw Exception('Error rejecting game: $e');
    }
  }

  // Fetch pending submissions
  Stream<QuerySnapshot> fetchPendingSubmissions() {
    return _firestore
        .collection('game_submissions')
        .where('status', isEqualTo: 'pending')
        .snapshots();
  }
}