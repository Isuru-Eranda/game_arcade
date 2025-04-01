import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
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
  bool _isSubmitting = false;
  PlatformFile? _selectedGameFile;
  List<PlatformFile> _selectedGamePictures = [];

  // Method to pick the game file
  Future<void> _pickGameFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        _selectedGameFile = result.files.first;
      });
    }
  }

  // Method to pick multiple game pictures
  Future<void> _pickGamePictures() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );

    if (result != null) {
      setState(() {
        _selectedGamePictures = result.files;
      });
    }
  }

  // Method to submit the game
  Future<void> _submitGame() async {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _selectedGameFile == null ||
        _selectedGamePictures.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields and select files')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await _controller.submitGame(
        title: _titleController.text,
        description: _descriptionController.text,
        gameFile: _selectedGameFile!,
        gamePictures: _selectedGamePictures,
      );

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Game Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Game Description'),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _pickGameFile,
              child: const Text('Select Game File'),
            ),
            if (_selectedGameFile != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text('Selected Game File: ${_selectedGameFile!.name}'),
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
                      .map((picture) => Text('Selected Picture: ${picture.name}'))
                      .toList(),
                ),
              ),
            const SizedBox(height: 20),
            _isSubmitting
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _submitGame,
                    child: const Text('Submit'),
                  ),
          ],
        ),
      ),
    );
  }
}