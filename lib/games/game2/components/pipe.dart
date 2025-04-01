import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:game_arcade/games/game2/game.dart';

class Pipe extends SpriteComponent with CollisionCallbacks, HasGameRef<FlappyBirdGame> {
  //detect if pipe is top or bottom
  final bool isTopPipe;
  // score

  bool scored = false;

  //init 
  Pipe(Vector2 position, Vector2 size, {required this.isTopPipe, int priority = 0})
      : super(position: position, size: size, priority: priority);

  @override
  FutureOr<void> onLoad() async{
    //load pipe image
    sprite = await Sprite.load(isTopPipe ? 'pipe_top.png' : 'pipe_bottom.png');
    //add collision shape
    add(RectangleHitbox());

    // UPADATE
  }

  @override
  void update(double dt){
    // move pipe to the left
    position.x -= gameRef.groundScrollingSpeed * dt;
    // check if the bird has passed the pipe
    if(!scored&& position.x<gameRef.bird.position.x){
      scored=true;
      // only increment for top pipes to avoid double counting
      if(isTopPipe){
        gameRef.incrementScore();
      }
    }
    // if pipe is out of screen, remove it
    if(position.x <= -size.x){
      removeFromParent();
    }
  }
}