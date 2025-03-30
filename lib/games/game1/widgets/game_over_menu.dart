import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

import 'package:game_arcade/games/game1/screens/main_menu.dart';

class GameOverMenu extends StatelessWidget {
  final int score;
  final VoidCallback onRestartpressed;
  const GameOverMenu({
    super.key,
    required this.score,
    required this.onRestartpressed,

    // ignore: unnecessary_null_comparison
  })  : assert(score != null),
        // ignore: unnecessary_null_comparison
        assert(onRestartpressed != null);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        // ignore: deprecated_member_use
        color: Colors.black.withOpacity(0.5),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 100.0, vertical: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Game Over',
                style: TextStyle(
                  fontFamily: 'Audiowide',
                  fontSize: 35.0,
                  color: BasicPalette.green.color,
                ),
              ),
              Text(
                'Your score is $score',
                style: TextStyle(
                  fontFamily: 'Audiowide',
                  fontSize: 35.0,
                  color: BasicPalette.green.color,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    icon: Icon(
                      Icons.refresh,
                      color: Colors.white,
                      size: 35.0,
                    ),
                    label: Text(
                      'Retry',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: BasicPalette.orange.color,
                    ),
                    onPressed: onRestartpressed, // Call the restart function
                  ),
                  ElevatedButton.icon(
                    icon: Icon(
                      Icons.home,
                      color: Colors.white,
                      size: 35.0,
                    ),
                    label: Text(
                      'Main Menu',
                      style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: BasicPalette.green.color,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => MainMenu(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
