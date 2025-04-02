import 'dart:async';
import 'package:flame/components.dart';
import 'package:game_arcade/game.dart';

class Background extends SpriteComponent with HasGameRef<FlappyBirdGame> {
  Background() : super(priority: -1); // Set priority for background

  @override
  FutureOr<void> onLoad() async {
    size = gameRef.size;
    position = Vector2.zero();
    sprite = await Sprite.load('game2/background.png');
    print('Loaded background:game2/background.png');
  }
}