import 'package:flutter/material.dart';

class GameOverDialog extends StatelessWidget {
  final VoidCallback onRestart;

  const GameOverDialog({super.key, required this.onRestart});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Game Over'),
      content: const Text('Would you like to play again?'),
      actions: [
        TextButton(
          onPressed: onRestart,
          child: const Text('Restart'),
        ),
      ],
    );
  }
}