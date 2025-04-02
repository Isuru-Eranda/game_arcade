import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:game_arcade/models/signup_model.dart';

class AuthController with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners(); // Notify UI about changes
  }

  User? get currentUser => _auth.currentUser;

  // Sign up user using SignupModel
  Future<String> signupUser(SignupModel signupModel) async {
    setLoading(true); // Set loading to true
    try {
      // Create user in Firebase Authentication
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: signupModel.email,
        password: signupModel.password,
      );

      // Save user data to Firestore
      await _firestore.collection('users').doc(cred.user!.uid).set({
        'name': signupModel.name,
        'email': signupModel.email,
        'uid': cred.user!.uid,
        'createdAt': Timestamp.now(),
      });

      setLoading(false); // Set loading to false
      return "success";
    } catch (e) {
      setLoading(false); // Set loading to false
      return e.toString();
    }
  }

  // Log in user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    setLoading(true); // Set loading to true
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      setLoading(false); // Set loading to false
      return "success";
    } catch (e) {
      setLoading(false); // Set loading to false
      return e.toString();
    }
  }

  // Sign out user
  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners(); // Notify UI about changes
  }
}