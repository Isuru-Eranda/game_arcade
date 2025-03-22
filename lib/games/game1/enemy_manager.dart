import 'dart:math';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flutter/foundation.dart';

import 'package:game_arcade/games/game1/enemy.dart';
import 'package:game_arcade/games/game1/game.dart';

class EnemyManager extends Component with HasGameRef<DinoGame> {
  late Random _random;
  late Timer _timer;
  int _spawnLevel = 0;

  EnemyManager() {
    _random = Random();

    _timer = Timer(4, repeat: true, onTick: () {
      spawnRandomEnemy();
    });
  }

  void spawnRandomEnemy() {
    final randomNumber = _random.nextInt(EnemyType.values.length);
    final randomEnemyType = EnemyType.values.elementAt(randomNumber);
    final enemy = Enemy(randomEnemyType);
    gameRef.add(enemy);
  }

  @override
  void onMount() {
    super.onMount();
    _timer.start();
  }

  @override
  void render(Canvas canvas) {
    // No rendering needed for the manager itself
  }

  @override
  void update(double dt) {
    _timer.update(dt);
    var newSpawnLevel = (gameRef.score ~/ 500);
    if (_spawnLevel < newSpawnLevel) {
      _spawnLevel = newSpawnLevel;

      var newWaitTime = (4 / (1 + (0.1 * _spawnLevel)));
      debugPrint(newWaitTime.toString());

      _timer.stop();

      _timer = Timer(newWaitTime, repeat: true, onTick: () {
        spawnRandomEnemy();
      });
      _timer.start();
    }
  }

  void pause() {
    _timer.stop();
  }

  void resume() {
    _timer.start();
  }

  void reset() {
    _spawnLevel = 0;
    _timer = Timer(4, repeat: true, onTick: () {
      spawnRandomEnemy();
    });
  }
}
