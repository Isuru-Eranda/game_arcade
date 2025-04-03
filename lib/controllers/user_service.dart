import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all users
  Stream<QuerySnapshot> fetchUsers() {
    return _firestore.collection('users').snapshots();
  }

  // Update user status (block/unblock)
  Future<void> updateUserStatus(String userId, String status) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'status': status,
      });
    } catch (e) {
      throw Exception('Error updating user status: $e');
    }
  }

  // Update user role (promote/demote admin)
  Future<void> updateUserRole(String userId, bool isAdmin) async {
    try {
      await _firestore.collection('users').doc(userId).update({
        'isAdmin': isAdmin,
      });
    } catch (e) {
      throw Exception('Error updating user role: $e');
    }
  }
}