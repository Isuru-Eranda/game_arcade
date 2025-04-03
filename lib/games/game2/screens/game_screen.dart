import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:game_arcade/game.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final FlappyBirdGame _game = FlappyBirdGame();
  bool _isPaused = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Game widget
          GameWidget(
            game: _game,
          ),

          // Overlay buttons
          Positioned(
            top: 20,
            right: 20,
            child: Column(
              children: [
                // Pause/Play Button
                IconButton(
                  icon: Icon(
                    _isPaused ? Icons.play_arrow : Icons.pause,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _isPaused = !_isPaused;
                      if (_isPaused) {
                        _game.pauseEngine();
                      } else {
                        _game.resumeEngine();
                      }
                    });
                  },
                ),

                // Restart Button
                IconButton(
                  icon: const Icon(
                    Icons.restart_alt,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _game.resetGame();
                      _isPaused = false;
                    });
                  },
                ),

                // Main Menu Button
                IconButton(
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    // Navigate back to the main menu
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}