import 'package:flutter/material.dart';
import 'package:game_arcade/games/game3/board.dart';

class TetrisGameScreen extends StatelessWidget {
  const TetrisGameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Tetris'),
        backgroundColor: Colors.purple,
      ),
      body: const GameBoard(),
    );
  }
}