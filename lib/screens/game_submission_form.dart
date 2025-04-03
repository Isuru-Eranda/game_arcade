import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:game_arcade/controllers/game_submission_controller.dart';

class GameSubmissionForm extends StatefulWidget {
  const GameSubmissionForm({super.key});

  @override
  State<GameSubmissionForm> createState() => _GameSubmissionFormState();
}

class _GameSubmissionFormState extends State<GameSubmissionForm> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final GameSubmissionController _controller = GameSubmissionController();
  final ImagePicker _picker = ImagePicker();
  bool _isSubmitting = false;
  File? _selectedGameFile;
  XFile? _webGameFile;
  String _gameFileName = '';
  List<XFile> _selectedGamePictures = [];

  // Theme color for all text
  final Color _textColor = Colors.orange;

  // Method to pick the game file
  Future<void> _pickGameFile() async {
    try {
      final XFile? result = await _picker.pickMedia();

      if (result != null) {
        setState(() {
          if (kIsWeb) {
            _webGameFile = result;
          } else {
            _selectedGameFile = File(result.path);
          }
          _gameFileName = result.name;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking file: $e')),
      );
    }
  }

  // Method to pick multiple game pictures
  Future<void> _pickGamePictures() async {
    try {
      final List<XFile>? result = await _picker.pickMultiImage();

      if (result != null) {
        setState(() {
          _selectedGamePictures = result;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking images: $e')),
      );
    }
  }

  // Method to submit the game
  Future<void> _submitGame() async {
    // Different validation for web and mobile
    if (kIsWeb) {
      if (_titleController.text.isEmpty ||
          _descriptionController.text.isEmpty ||
          _webGameFile == null ||
          _selectedGamePictures.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please fill in all fields and select files')),
        );
        return;
      }
    } else {
      if (_titleController.text.isEmpty ||
          _descriptionController.text.isEmpty ||
          _selectedGameFile == null ||
          _selectedGamePictures.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Please fill in all fields and select files')),
        );
        return;
      }
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      if (kIsWeb) {
        await _controller.submitGameWeb(
          title: _titleController.text,
          description: _descriptionController.text,
          gameFile: _webGameFile!,
          gameFileName: _gameFileName,
          gamePictures: _selectedGamePictures,
        );
      } else {
        await _controller.submitGame(
          title: _titleController.text,
          description: _descriptionController.text,
          gameFile: _selectedGameFile!,
          gameFileName: _gameFileName,
          gamePictures: _selectedGamePictures,
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Game submitted successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Submit Your Game', 
          style: TextStyle(
            color: _textColor,
            fontSize: 32.0, // Increased font size from default
            fontWeight: FontWeight.normal,
          )
        ),
        toolbarHeight: 80, // Increased height of the AppBar
        titleSpacing: 0,
        centerTitle: true, // Center the title
        iconTheme: IconThemeData(color: Colors.orange), // Makes the back button orange
        // Add top padding to push content down from top of screen
        flexibleSpace: Container(
          padding: EdgeInsets.only(top: 26.0),
        ),
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
          textTheme: Theme.of(context).textTheme.apply(
                bodyColor: _textColor,
                displayColor: _textColor,
              ),
          inputDecorationTheme: InputDecorationTheme(
            labelStyle: TextStyle(color: _textColor),
            hintStyle: TextStyle(color: _textColor),
          ),
          // Add theme-wide text selection color and cursor color
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: Colors.orange,
            selectionColor: Colors.orange.withOpacity(0.3),
            selectionHandleColor: Colors.orange,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.black,
              textStyle: const TextStyle(
                fontWeight: FontWeight.normal,
                fontFamily: 'Jersey10',
                fontSize: 24,
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Game Title',
                    labelStyle: TextStyle(color: _textColor),
                  ),
                  style: TextStyle(color: _textColor),
                  cursorColor: Colors.orange,
                  cursorWidth: 2.0,
                ),
                const SizedBox(height: 16.0),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Game Description',
                    labelStyle: TextStyle(color: _textColor),
                  ),
                  style: TextStyle(color: _textColor),
                  cursorColor: Colors.orange,
                  cursorWidth: 2.0,
                  maxLines: 5,
                ),
                const SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: _pickGameFile,
                  child: Text(
                    'Select Game File',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                if (_gameFileName.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      'Selected Game File: $_gameFileName',
                      style: TextStyle(color: _textColor),
                    ),
                  ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _pickGamePictures,
                  child: Text(
                    'Select Game Pictures',
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                if (_selectedGamePictures.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _selectedGamePictures
                          .map((picture) => Text(
                                'Selected Picture: ${picture.name}',
                                style: TextStyle(color: _textColor),
                              ))
                          .toList(),
                    ),
                  ),
                const SizedBox(height: 20),
                _isSubmitting
                    ? Center(
                        child: CircularProgressIndicator(
                          color: _textColor,
                        ),
                      )
                    : ElevatedButton(
                        onPressed: _submitGame,
                        child: Text(
                          'Submit',
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                if (kIsWeb)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      color: Colors.amber.withOpacity(0.2),
                      child: Text(
                        'Note: The web version has different file handling than the mobile app.',
                        style: TextStyle(
                          color: _textColor,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
