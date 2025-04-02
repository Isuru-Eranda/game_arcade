import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:game_arcade/game.dart'; // Import your FlappyBirdGame class

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flappy Bird'),
        backgroundColor: Colors.orange,
      ),
      body: GameWidget(
        game: FlappyBirdGame(), // Use your FlappyBirdGame instance here
      ),
    );
  }
}