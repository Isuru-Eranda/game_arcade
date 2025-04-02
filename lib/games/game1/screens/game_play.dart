import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for SystemChrome
import 'package:flame/game.dart'; // Import GameWidget from Flame
import 'package:game_arcade/games/game1/game.dart'; // Import your DinoGame class

class GamePlay extends StatelessWidget {
  final DinoGame _dinoGame = DinoGame();

  GamePlay({super.key});

  @override
  Widget build(BuildContext context) {
    // Set landscape mode when entering the game
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        // Reset to portrait mode when exiting the game
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
        return true;
      },
      child: Scaffold(
        body: GameWidget(
          game: _dinoGame, // Use GameWidget to display the game
        ),
      ),
    );
  }
}
