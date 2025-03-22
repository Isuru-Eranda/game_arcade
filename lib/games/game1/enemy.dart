import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';

import 'package:game_arcade/games/game1/constant.dart';

enum EnemyType { angryPig, bat, rino }

class EnemyData {
  final String imageName;
  final int textureWidth;
  final int textureHeight;
  final int ncolumns;
  final int nrows;
  final bool canFly;
  final int speed;

  const EnemyData({
    required this.imageName,
    required this.textureWidth,
    required this.textureHeight,
    required this.ncolumns,
    required this.nrows,
    required this.canFly,
    required this.speed,
  });
}

class Enemy extends SpriteAnimationComponent {
  late EnemyData _myData;
  static final Random _random = Random();

  static const Map<EnemyType, EnemyData> _enemyDetails = {
    EnemyType.angryPig: EnemyData(
      imageName: 'AngryPig/Walk (36x30).png',
      textureWidth: 36,
      textureHeight: 30,
      ncolumns: 16,
      nrows: 1,
      canFly: false,
      speed: 250,
    ),
    EnemyType.bat: EnemyData(
      imageName: 'Bat/Flying (46x30).png',
      textureWidth: 46,
      textureHeight: 30,
      ncolumns: 7,
      nrows: 1,
      canFly: true,
      speed: 300,
    ),
    EnemyType.rino: EnemyData(
      imageName: 'Rino/Run (52x34).png',
      textureWidth: 52,
      textureHeight: 34,
      ncolumns: 6,
      nrows: 1,
      canFly: false,
      speed: 350,
    ),
  };

  Enemy(EnemyType enemyType) : super() {
    _myData = _enemyDetails[enemyType]!;
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();

    final spriteSheet = SpriteSheet(
      image: await Flame.images.load(_myData.imageName),
      srcSize: Vector2(
          _myData.textureWidth.toDouble(), _myData.textureHeight.toDouble()),
    );

    animation = spriteSheet.createAnimation(
      row: 0,
      from: 0,
      to: _myData.ncolumns - 1,
      stepTime: 0.1,
    );

    anchor = Anchor.center;
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);

    double scaleFactor =
        size.x / numberOfTilesAlongWidth / _myData.textureWidth;

    height = _myData.textureHeight * scaleFactor;
    width = _myData.textureWidth * scaleFactor;

    x = size.x + width;
    y = size.y - groundHeight - height / 2;

    if (_myData.canFly && _random.nextBool()) {
      y -= height;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    x -= _myData.speed * dt;
  }

  bool shouldRemove() {
    return x < (-width);
  }
}
