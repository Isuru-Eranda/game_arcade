import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:game_arcade/games/game2/game.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget(
        game: FlappyBirdGame(),
      ),
    );
  }
}