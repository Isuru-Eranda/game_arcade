import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:game_arcade/games/game2/game.dart';

class ScoreText extends TextComponent with HasGameRef<FlappyBirdGame> {
  ScoreText():super(
    text: '0',
    textRenderer: TextPaint(
      style: const TextStyle(
        color: Colors.black, // Chanflge color to black
        fontSize: 48.0,
      ),
    ),
    priority: 3, // Set priority for score
  );

  //load 
  @override
  FutureOr<void> onLoad(){
    //set the position to  lower middle of the screen
    position= Vector2(
      // center horizontally
      (gameRef.size.x - size.x) / 2,
      // slightly abve th bottom
      gameRef.size.y - size.y - 50,
    );
      
    return super.onLoad();
  }

  // update 
  @override
  void update(double dt) {
    super.update(dt);
    final newText=gameRef.score.toString();
    if (text != newText) {
      text = newText;
    }
  }
}