// Import DinoGame

import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Import for SystemChrome
import 'package:flame/flame.dart';
import 'package:game_arcade/games/game1/game.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set full-screen and landscape mode
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  runApp(const DinoRunApp());
}

class DinoRunApp extends StatelessWidget {
  const DinoRunApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dino Run',
      theme: ThemeData(
        fontFamily: 'Audiowide',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Dino Run'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    // Create the DinoGame instance
    final DinoGame game = DinoGame();

    return Scaffold(
      body: GameWidget(
        game: game, // Pass the DinoGame instance here
      ),
    );
  }
}
