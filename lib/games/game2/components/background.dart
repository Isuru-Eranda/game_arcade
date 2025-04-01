import 'dart:async';
import 'package:flame/components.dart';
import 'package:game_arcade/games/game2/game.dart';

class Background extends SpriteComponent with HasGameRef<FlappyBirdGame> {
  Background() : super(priority: -1); // Set priority for background

  @override
  FutureOr<void> onLoad() async {
    size = gameRef.size;
    position = Vector2.zero();
    sprite = await Sprite.load('background.png');
  }
}