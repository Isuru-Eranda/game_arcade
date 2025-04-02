import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame/parallax.dart';
import 'package:flutter/material.dart';
import 'package:game_arcade/games/game1/constant.dart';
import 'package:game_arcade/games/game1/dino.dart';
import 'package:game_arcade/games/game1/enemy.dart';

import 'package:game_arcade/games/game1/enemy_manager.dart';
import 'package:game_arcade/games/game1/widgets/game_over_menu.dart';
import 'package:game_arcade/games/game1/widgets/hud.dart';
import 'package:game_arcade/games/game1/widgets/pause_menu.dart';

class DinoGame extends FlameGame with TapDetector, HasCollisionDetection {
  late final Dino _dino;
  late final ParallaxComponent _parallaxComponent;
  late final TextComponent _scoreText;
  double _elapsedTime = 0;
  late final EnemyManager _enemyManager;
  int score = 0;

  DinoGame() {
    _dino = Dino();
    final textPaint = TextPaint(
      style: TextStyle(
        fontFamily: 'Audiowide',
        fontSize: 35.0,
        color: BasicPalette.green.color,
      ),
    );

    _scoreText = TextComponent(
      text: score.toString(),
      textRenderer: textPaint,
      position: Vector2(0, 0),
      anchor: Anchor.topCenter,
    );
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    _parallaxComponent = await ParallaxComponent.load(
      [
        ParallaxImageData('parallax/plx-1.png'),
        ParallaxImageData('parallax/plx-2.png'),
        ParallaxImageData('parallax/plx-3.png'),
        ParallaxImageData('parallax/plx-4.png'),
        ParallaxImageData('parallax/plx-5.png'),
        ParallaxImageData('parallax/plx-6.png'),
      ],
      baseVelocity: Vector2(100, 0),
      velocityMultiplierDelta: Vector2(1.2, 1.0),
    );
    add(_parallaxComponent);

    add(_dino);

    _enemyManager = EnemyManager();
    add(_enemyManager);

    add(_scoreText);

    // Register overlays
    overlays.addEntry('Hud',
        (context, game) => HUD(onpausePressed: pauseGame, life: _dino.life));
    overlays.addEntry(
        'PauseMenu', (context, game) => PauseMenu(onResumePressed: resumeGame));
    overlays.addEntry('GameOverMenu',
        (context, game) => GameOverMenu(score: score, onRestartpressed: reset));

    overlays.add('Hud');
  }

  @override
  void onTapDown(TapDownInfo info) {
    _dino.jump();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    _dino.size = Vector2(
        size.x / numberOfTilesAlongWidth, size.x / numberOfTilesAlongWidth);
    _dino.position = Vector2(
        100, size.y - groundHeight - (_dino.size.y / 2) + dinoTopBottomSpacing);
    _dino.yMax = _dino.y;

    _scoreText.position = Vector2(size.x / 2, 0);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _elapsedTime += dt;
    if (_elapsedTime >(1/60)) {
      _elapsedTime = 0;
      score+= 1;
      _scoreText.text = score.toString();
    }
    

    children.whereType<Enemy>().forEach((enemy) {
      if (_dino.distance(enemy) < 30) {
        _dino.hit();
      }
    });
    if (_dino.life.value <= 0) {
      gameOver();
    }
  }

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    super.lifecycleStateChange(state);
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        pauseGame();
        break;
      case AppLifecycleState.paused:
        pauseGame();
        break;
      case AppLifecycleState.detached:
        pauseGame();
        break;
      case AppLifecycleState.hidden:
        pauseGame();
        break;
    }
  }

  void pauseGame() {
    pauseEngine();
    _enemyManager.pause();
    overlays.add('PauseMenu');
    overlays.addEntry(
        'PauseMenu', (context, game) => PauseMenu(onResumePressed: resumeGame));
  }

  void resumeGame() {
    overlays.remove('PauseMenu');
    _enemyManager.resume();
    resumeEngine();
  }

  void gameOver() {
    pauseEngine();
    overlays.add('GameOverMenu');
  }

  void reset() {
    score = 0;
    _dino.life.value = 4;
    _dino.run();
    _enemyManager.reset();

    children.whereType<Enemy>().forEach((enemy) {
      enemy.removeFromParent();
    });
    overlays.remove('GameOverMenu');
    resumeEngine();
  }
}
