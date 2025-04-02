import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:game_arcade/models/game_submission.dart';

class GameSubmissionController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload file to Firebase Storage and return the download URL
  Future<String> uploadFile(File file, String folder, String fileName) async {
    try {
      final storageRef = _storage.ref().child('$folder/$fileName');
      await storageRef.putFile(file);
      return await storageRef.getDownloadURL();
    } catch (e) {
      throw Exception('File upload failed: $e');
    }
  }
  
  // Web-specific upload method
  Future<String> uploadBytes(
      Uint8List bytes, String folder, String fileName) async {
    try {
      final storageRef = _storage.ref().child('$folder/$fileName');
      await storageRef.putData(bytes);
      return await storageRef.getDownloadURL();
    } catch (e) {
      throw Exception('File upload failed: $e');
    }
  }

  // Web-specific submit game method
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

      // Upload the game file - for web we need to read the file as bytes
      final Uint8List gameBytes = await gameFile.readAsBytes();
      final String gameFileUrl =
          await uploadBytes(gameBytes, 'games', gameFileName);

      // Upload all game pictures and collect their URLs
      final List<String> gamePictureUrls = [];
      for (var picture in gamePictures) {
        final Uint8List pictureBytes = await picture.readAsBytes();
        final String pictureUrl =
            await uploadBytes(pictureBytes, 'game_pictures', picture.name);
        gamePictureUrls.add(pictureUrl);
      }

      // Create a GameSubmission object
      final gameSubmission = GameSubmission(
        title: title,
        description: description,
        gameFileUrl: gameFileUrl,
        gamePictureUrl:
            gamePictureUrls.join(','), // Store URLs as a comma-separated string
        email: email,
        status: 'pending',
        submittedAt: Timestamp.now(),
      );

      // Save metadata to Firestore
      await _firestore
          .collection('game_submissions')
          .add(gameSubmission.toMap());
    } catch (e) {
      throw Exception('Game submission failed: $e');
    }
  }

  // Submit game metadata to Firestore (Mobile version)
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

      // Upload the game file
      final String gameFileUrl =
          await uploadFile(gameFile, 'games', gameFileName);

      // Upload all game pictures and collect their URLs
      final List<String> gamePictureUrls = [];
      for (var picture in gamePictures) {
        final String pictureUrl =
            await uploadFile(File(picture.path), 'game_pictures', picture.name);
        gamePictureUrls.add(pictureUrl);
      }

      // Create a GameSubmission object
      final gameSubmission = GameSubmission(
        title: title,
        description: description,
        gameFileUrl: gameFileUrl,
        gamePictureUrl:
            gamePictureUrls.join(','), // Store URLs as a comma-separated string
        email: email,
        status: 'pending',
        submittedAt: Timestamp.now(),
      );

      // Save metadata to Firestore
      await _firestore
          .collection('game_submissions')
          .add(gameSubmission.toMap());
    } catch (e) {
      throw Exception('Game submission failed: $e');
    }
  }

  // Fetch all game submissions
  Future<List<GameSubmission>> fetchGameSubmissions() async {
    try {
      final querySnapshot =
          await _firestore.collection('game_submissions').get();
      return querySnapshot.docs
          .map((doc) => GameSubmission.fromFirestore(doc))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch game submissions: $e');
    }
  }
}
