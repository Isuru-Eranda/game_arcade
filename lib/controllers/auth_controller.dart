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
    String res = "Some error occurred";
    try {
      if (signupModel.email.isNotEmpty &&
          signupModel.password.isNotEmpty &&
          signupModel.name.isNotEmpty) {
        // Register user in Firebase Authentication
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: signupModel.email,
          password: signupModel.password,
        );

        // Add user to Firestore
        await _firestore.collection("users").doc(cred.user!.uid).set({
          'name': signupModel.name,
          'uid': cred.user!.uid,
          'email': signupModel.email,
          'isAdmin': signupModel.isAdmin, // Save isAdmin field
        });

        res = "success";
      } else {
        res = "Please fill in all fields";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // Log in user
  Future<String> loginUser({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        // Log in user with email and password
        UserCredential cred = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Fetch user data from Firestore
        final userDoc = await _firestore.collection("users").doc(cred.user!.uid).get();
        final isAdmin = userDoc.data()?['isAdmin'] ?? false;

        // Redirect based on isAdmin field
        if (isAdmin) {
          Navigator.pushReplacementNamed(context, '/adminPanel'); // Redirect to Admin Panel
        } else {
          Navigator.pushReplacementNamed(context, '/home'); // Redirect to Home Screen
        }

        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  // Sign out user
  Future<void> signOut() async {
    await _auth.signOut();
    notifyListeners(); // Notify UI about changes
  }
}

Future<void> createAdminUser() async {
  try {
    // Create admin user in Firebase Authentication
    UserCredential cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: "admin@example.com",
      password: "admin123", // Use a secure password
    );

    // Add admin user to Firestore
    await FirebaseFirestore.instance.collection("users").doc(cred.user!.uid).set({
      "name": "Admin User",
      "email": "admin@example.com",
      "uid": cred.user!.uid,
      "isAdmin": true, // Set admin privileges
    });

    print("Admin user created successfully!");
  } catch (e) {
    print("Error creating admin user: $e");
  }
}