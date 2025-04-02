import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:game_arcade/game.dart';

class Ground extends SpriteComponent with HasGameRef<FlappyBirdGame>, CollisionCallbacks {
  Ground() : super(priority: 1);

  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load('game2/ground.png');
    size = Vector2(gameRef.size.x, 50); // Example ground height
    position = Vector2(0, gameRef.size.y - 50); // Position at the bottom of the screen

    // Add a collision hitbox
    add(RectangleHitbox()..collisionType = CollisionType.passive);
  }
}