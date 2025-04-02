import 'dart:math';
import 'package:flame/components.dart';
import 'package:game_arcade/games/game2/constants.dart';
import 'package:game_arcade/games/game2/game.dart';
import 'package:game_arcade/games/game2/components/pipe.dart';


class PipeManager extends Component with HasGameRef<FlappyBirdGame> {
  double pipeSpawnTimer = 0.0;

  @override
  void update(double dt) {
    // generate new pipe every given interval
    pipeSpawnTimer += dt;
   

    if (pipeSpawnTimer >= pipeInterval) {
      pipeSpawnTimer = 0;
      spawnPipe();
    }
  }

  // spawn pipe
  void spawnPipe() {
    final double screenHeight = gameRef.size.y;
    const double pipeGap = 200;
    const double minPipeHeight = 50;
    const double pipeWidth = 60;
    const double groundHeight = 50; // Adjust this value to match the actual ground height

    // generate random height for the bottom pipe

    // max possible height
    final double maxPipeHeight = screenHeight - pipeGap - minPipeHeight;

    // generate height of bottom pipe
    final double bottomPipeHeight =
        minPipeHeight + Random().nextDouble() * (maxPipeHeight - minPipeHeight);

    // height of top pipe
    final double topPipeHeight =
        screenHeight - groundHeight - bottomPipeHeight - pipeGap;

    // Create BOTTOM pipe
    final bottomPipe = Pipe(
      // position
      Vector2(gameRef.size.x, screenHeight - groundHeight - bottomPipeHeight),
      // size
      Vector2(pipeWidth, bottomPipeHeight),
      isTopPipe: false,
      priority: 0, // Set priority for pipes
    );

    // Create TOP pipe
    final topPipe = Pipe(
      // position
      Vector2(gameRef.size.x, 0),
      // size
      Vector2(pipeWidth, topPipeHeight),
      isTopPipe: true,
      priority: 0, // Set priority for pipes
    );

    // add pipes to the game
    gameRef.add(bottomPipe as Component);
    gameRef.add(topPipe as Component);
  }
}
