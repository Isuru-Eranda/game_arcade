import 'package:cloud_firestore/cloud_firestore.dart';

class AdminService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Approve a submission
  Future<void> approveSubmission(String documentId) async {
    try {
      await _firestore.collection('game_submissions').doc(documentId).update({
        'status': 'approved',
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