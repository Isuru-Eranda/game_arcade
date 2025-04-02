import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:game_arcade/games/game1/screens/game_play.dart';
import 'package:game_arcade/screens/home_screen.dart';

class Menu extends StatelessWidget {
  final Function onSettingsPressed;

  const Menu({
    super.key,
    required this.onSettingsPressed,
  // ignore: unnecessary_null_comparison
  }) : assert(onSettingsPressed != null);

  @override
  Widget build(BuildContext context) {
    // Define a consistent button width
    const double buttonWidth = 200.0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Dino Run',
          style: TextStyle(fontSize: 60, color: BasicPalette.green.color),
        ),
        const SizedBox(height: 30),
        SizedBox(
          width: buttonWidth, // Fixed width for Play button
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => GamePlay(),
                ),
              );
            },
            child: Text(
              'Play',
              style: TextStyle(fontSize: 30, color: BasicPalette.green.color),
            ),
          ),
        ),
        const SizedBox(height: 15),
        SizedBox(
          width: buttonWidth, // Fixed width for Home button
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(), // Navigate to HomeScreen
                ),
              );
            },
            child: Text(
              'Home',
              style: TextStyle(fontSize: 30, color: BasicPalette.green.color),
            ),
          ),
        ),
      ], // <-- This closes the children list of the Column widget
    ); // <-- This closes the Column widget
  }
}
