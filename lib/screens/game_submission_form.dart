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
      appBar: AppBar(title: const Text('Submit Your Game')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Game Title'),
              ),
              TextField(
                controller: _descriptionController,
                decoration:
                    const InputDecoration(labelText: 'Game Description'),
                maxLines: 5,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickGameFile,
                child: const Text('Select Game File'),
              ),
              if (_gameFileName.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text('Selected Game File: $_gameFileName'),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickGamePictures,
                child: const Text('Select Game Pictures'),
              ),
              if (_selectedGamePictures.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _selectedGamePictures
                        .map((picture) =>
                            Text('Selected Picture: ${picture.name}'))
                        .toList(),
                  ),
                ),
              const SizedBox(height: 20),
              _isSubmitting
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submitGame,
                      child: const Text('Submit'),
                    ),
              if (kIsWeb)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.amber.withOpacity(0.2),
                    child: const Text(
                      'Note: The web version has different file handling than the mobile app.',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
