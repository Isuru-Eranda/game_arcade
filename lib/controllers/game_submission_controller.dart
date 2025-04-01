import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:file_picker/file_picker.dart';
import 'package:game_arcade/models/game_submission.dart';

class GameSubmissionController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload file to Firebase Storage and return the download URL
  Future<String> uploadFile(PlatformFile file, String folder) async {
    try {
      final storageRef = _storage.ref().child('$folder/${file.name}');
      await storageRef.putData(file.bytes!);
      return await storageRef.getDownloadURL();
    } catch (e) {
      throw Exception('File upload failed: $e');
    }
  }

  // Submit game metadata to Firestore
  Future<void> submitGame({
    required String title,
    required String description,
    required PlatformFile gameFile,
    required List<PlatformFile> gamePictures,
  }) async {
    try {
      // Get the current user's email
      final User? user = _auth.currentUser;
      if (user == null) {
        throw Exception('You must be logged in to submit a game.');
      }
      final String email = user.email!;

      // Upload the game file
      final String gameFileUrl = await uploadFile(gameFile, 'games');

      // Upload all game pictures and collect their URLs
      final List<String> gamePictureUrls = [];
      for (var picture in gamePictures) {
        final String pictureUrl = await uploadFile(picture, 'game_pictures');
        gamePictureUrls.add(pictureUrl);
      }

      // Create a GameSubmission object
      final gameSubmission = GameSubmission(
        title: title,
        description: description,
        gameFileUrl: gameFileUrl,
        gamePictureUrl: gamePictureUrls.join(','), // Store URLs as a comma-separated string
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