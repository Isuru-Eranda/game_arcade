import 'package:flutter/material.dart';

class GameDetailScreen extends StatelessWidget {
  final String gameName;

  const GameDetailScreen({super.key, required this.gameName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(gameName),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Text(
          'Welcome to $gameName',
          style: const TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }
}
