import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:game_arcade/games/game2/components/ground.dart';
import 'package:game_arcade/games/game2/constants.dart';
import 'package:game_arcade/games/game2/game.dart';
import 'pipe.dart';

class Bird extends SpriteComponent with HasGameRef<FlappyBirdGame>, CollisionCallbacks {
  Bird()
      : super(
            position: Vector2(birdStartX, birdStartY),
            size: Vector2(birdWidth, birdHeight),
            priority: 2); // Set priority for bird

  // Physical world properties
  double velocity = 0;

  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load('bird.png');
    position = Vector2(gameRef.size.x / 4, gameRef.size.y / 2);

    // Add a collision hitbox
    add(RectangleHitbox()..collisionType = CollisionType.active);
  }

  // Jump / fly
  void flap() {
    velocity = jumpStrength;
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Apply gravity
    velocity += gravity * dt;

    // Update bird position based on velocity
    position.y += velocity * dt;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    // Check if bird is colliding with the ground
    if (other is Ground) {
      (parent as FlappyBirdGame).gameOver();
    }

    // Check if bird is colliding with pipes
    if (other is Pipe) {
      (parent as FlappyBirdGame).gameOver();
    }
  }
}
