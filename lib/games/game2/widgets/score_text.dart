import 'package:flutter/material.dart';

class ScoreText extends StatelessWidget {
  final int score;

  const ScoreText({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Score: $score',
      style: const TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.normal,
        color: Colors.white,
      ),
    );
  }
}