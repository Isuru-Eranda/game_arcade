import 'package:flutter/material.dart';

class GameDetailScreen extends StatelessWidget {
  final String gameName;

  const GameDetailScreen({Key? key, required this.gameName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(gameName),
        backgroundColor: Colors.black,
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
