import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:game_arcade/models/game_submission.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;

class GameSubmissionController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload file to Firebase Storage and return the download URL
  Future<String> uploadFile(XFile file, String folder) async {
    try {
      final storageRef = _storage.ref().child('$folder/${file.name}');
      
      if (kIsWeb) {
        // For web, read the bytes
        final bytes = await file.readAsBytes();
        await storageRef.putData(bytes);
      } else {
        // For mobile, use the File
        final fileData = File(file.path);
        await storageRef.putFile(fileData);
      }
      
      return await storageRef.getDownloadURL();
    } catch (e) {
      throw Exception('File upload failed: $e');
    }
  }

  // Submit game metadata to Firestore for mobile
  Future<void> submitGame({
    required String title,
    required String description,
    required File gameFile,
    required String gameFileName,
    required List<XFile> gamePictures,
  }) async {
    try {
      // Get the current user's email
      final User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('You must be logged in to submit a game.');
      }
      final String email = user.email!;

      // Collect all game picture names
      final List<String> gamePictureNames = gamePictures.map((picture) => picture.name).toList();

      // Create a GameSubmission object
      final gameSubmission = GameSubmission(
        title: title,
        description: description,
        gameFileUrl: gameFileName, // Store the file name
        gamePictureUrl: gamePictureNames.join(','), // Store picture names as a comma-separated string
        email: email,
        status: 'pending',
        submittedAt: Timestamp.now(),
      );

      // Save metadata to Firestore
      await _firestore.collection('game_submissions').add(gameSubmission.toMap());
    } catch (e) {
      throw Exception('Game submission failed: $e');
    }
  }

  // Submit game metadata to Firestore for web
  Future<void> submitGameWeb({
    required String title,
    required String description,
    required XFile gameFile,
    required String gameFileName,
    required List<XFile> gamePictures,
  }) async {
    try {
      // Get the current user's email
      final User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('You must be logged in to submit a game.');
      }
      final String email = user.email!;

      // Collect all game picture names
      final List<String> gamePictureNames = gamePictures.map((picture) => picture.name).toList();

      // Create a GameSubmission object
      final gameSubmission = GameSubmission(
        title: title,
        description: description,
        gameFileUrl: gameFileName, // Store the file name
        gamePictureUrl: gamePictureNames.join(','), // Store picture names as a comma-separated string
        email: email,
        status: 'pending',
        submittedAt: Timestamp.now(),
      );

      // Save metadata to Firestore
      await _firestore.collection('game_submissions').add(gameSubmission.toMap());
    } catch (e) {
      throw Exception('Game submission failed: $e');
    }
  }

  // Fetch all game submissions
  Future<List<GameSubmission>> fetchGameSubmissions() async {
    try {
      final querySnapshot = await _firestore.collection('game_submissions').get();
      return querySnapshot.docs
          .map((doc) => GameSubmission.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch game submissions: $e');
    }
  }
}