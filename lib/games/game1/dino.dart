import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/foundation.dart';

import 'package:game_arcade/games/game1/constant.dart';

class Dino extends SpriteAnimationComponent {
  late SpriteAnimation _runAnimation;
  late SpriteAnimation _hitAnimation;
  late Timer _timer;
  bool _isHit = false;

  double speedY = 0.0;
  double yMax = 0.0;

  ValueNotifier<int> life;

  Dino() : life = ValueNotifier<int>(4);

  @override
  Future<void> onLoad() async {
    super.onLoad();

    final spriteSheet = SpriteSheet(
      image: await Flame.images.load('DinoSprites - tard.png'),
      srcSize: Vector2(24, 24),
    );

    spriteSheet.createAnimation(
      row: 0,
      from: 0,
      to: 3,
      stepTime: 0.1,
    );

    _runAnimation = spriteSheet.createAnimation(
      row: 0,
      from: 4,
      to: 10,
      stepTime: 0.1,
    );

    _hitAnimation = spriteSheet.createAnimation(
      row: 0,
      from: 14,
      to: 16,
      stepTime: 0.1,
    );

    animation = _runAnimation;
    _timer = Timer(1, onTick: () {
      run();
    });
    _isHit = false;
    anchor = Anchor.center;

    life = ValueNotifier(4);
  }

  @override
  void update(double dt) {
    super.update(dt);
    //v=u+at
    speedY += gravity * dt;

    //d=s0 + s*t
    y += speedY * dt;

    if (isOnGround()) {
      y = yMax;
      speedY = 0.0;
    }
    _timer.update(dt);
  }

  bool isOnGround() {
    return (y >= yMax);
  }

  void run() {
    _isHit = false;
    animation = _runAnimation;
  }

  void hit() {
    if (!_isHit) {
      animation = _hitAnimation;
      _timer.start();
      _isHit = true;
      life.value -= 1;
    }
  }

  void jump() {
    if (isOnGround()) {
      speedY = -500;
    }
  }
}
