import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const GameArcadeApp());
}

class GameArcadeApp extends StatelessWidget {
  const GameArcadeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Game Arcade',
      theme: ThemeData.dark(),
      home: SplashScreen(),
    );
  }
}