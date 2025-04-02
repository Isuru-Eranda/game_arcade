import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:game_arcade/games/game3/piece.dart';
import 'package:game_arcade/games/game3/pixel.dart';
import 'package:game_arcade/games/game3/values.dart';
import 'package:game_arcade/controllers/score_controller.dart';

/*
GAME BOARD
This is a 2x2 grid with null representing an empty space.
A non empty space will have the color to represent the landed pieces
*/

// create game board 
List<List<Tetromino?>> gameBoard = List.generate(
  colLength,
  (i) => List.generate(
  rowLength,
  (j) => null,
  ),
  );

class GameBoard extends StatefulWidget {
  const GameBoard({super.key});

  @override
  State<GameBoard> createState() => _GameBoardState();
}

class _GameBoardState extends State<GameBoard> {
  //current tetris piece
  Piece currentPiece = Piece(type: Tetromino.L);

  //current score
  int currentScore = 0;

  // game over status
  bool gameOver = false;

  // Score controller for saving scores
  final ScoreController _scoreController = ScoreController();

  @override
  void initState() {
    super.initState();

    // start game when app starts
    startGame();
  }

  void startGame() {
    currentPiece.initializePiece();

    //frame refresh rate
    Duration frameRate = const Duration(milliseconds: 500);
    gameLoop(frameRate);
  }

  //game loop
  void gameLoop(Duration frameRate) {
    Timer.periodic(
      frameRate, 
    (timer) {
      setState(() {
        // clear lines
        clearLines();

        // check landing
        checkLanding();

        // check if game is over
        if (gameOver == true) {
          timer.cancel();
          showGameOverDialog();
        }

        //move current piece down
        currentPiece.movePiece(Direction.down);
      });
    },
    );
  }

  // game over message
  void showGameOverDialog() {
    // Save the score to Firestore
    _scoreController.saveScore(
      gameName: 'Tetris',
      score: currentScore,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Game Over'),
        content: Text("Your score is $currentScore"),
        actions: [
          TextButton(
            onPressed: () {
              // reset the game
              resetGame();

              Navigator.pop(context);
            },
            child: Text('Play Again'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Return to arcade
            },
            child: Text('Main Menu'),
          ),
        ],
      ),
    );
  }

  //reset game
  void resetGame() {
    // clear the game board
    gameBoard = List.generate(
      colLength, 
      (i) => List.generate(
        rowLength, 
        (j) => null,
      ),
    );

    // new game 
    gameOver = false;
    currentScore = 0;

    // create new piece
    createNewPiece();

    // start game again
    startGame();
  }

  // check for collision in a future position
  // returns true -> there is a collision
  // returns false -> there is no collision
  bool checkCollision(Direction direction) {
    // loop through each position of the current piece
    for (int i = 0; i < currentPiece.position.length; i++) {
      // calculate the row and column of the current position
      int row = (currentPiece.position[i] / rowLength).floor();
      int col = currentPiece.position[i] % rowLength;

      // adjust the row and col based on the direction
      if (direction == Direction.left) {
        col -= 1;
      } else if (direction == Direction.right) {
        col += 1;
      } else if (direction == Direction.down) {
        row += 1;
      }

      // check if the piece is out of bounds (either too low or too far to the left or right)
      if (row >= colLength || col < 0 || col >= rowLength) {
        return true;
      }
    
      // check if the current position is already occupied by another piece in the game board
      if (row >= 0 && col >= 0) {
        if (gameBoard[row][col] != null) {
          return true;
        }
      }
    }

    // if no collisions are detected, return false
    return false;
  }

  void checkLanding() {
    // if going down is occupied 
    if (checkCollision(Direction.down)) {
      // mark position as occupied on the gameboard
      for (int i=0; i < currentPiece.position.length; i++) {
        int row = (currentPiece.position[i] / rowLength).floor();
        int col = currentPiece.position[i] % rowLength;
        if (row>=0 && col>=0) {
          gameBoard[row][col] = currentPiece.type;
        }
      }

      // once landed, create the next piece
      createNewPiece();
    }
  }

  void createNewPiece(){
    // create a random object to generate random tetromino types
    Random rand = Random();

    // create a new piece with random type
    Tetromino randomType = 
    Tetromino.values[rand.nextInt(Tetromino.values.length)];
    currentPiece = Piece(type: randomType);
    currentPiece.initializePiece();

    /*
    Since our game over condition is if there is a piece at the top level,
    you want to check if the game is over when you create a new piece
    instead of checking every frame, because new pieces are allowed to go through the top level
    but if there is already a piece in the top level when the new piece is created,
    then game is over 
    */
    if (isGameOver()) {
      gameOver = true;
    }
  }

  // move left
  void moveLeft() {
    //make sure the move is valid before moving there
    if (!checkCollision(Direction.left)) {
      setState(() {
        currentPiece.movePiece(Direction.left);
      });
    }
  }

  // move right
  void moveRight() {
    //make sure the move is valid before moving there
    if (!checkCollision(Direction.right)) {
      setState(() {
        currentPiece.movePiece(Direction.right);
      });
    }
  }

  //rotate piece
  void rotatePiece() {
    setState(() {
      currentPiece.rotatePiece();
    });
  }
 
  // clear lines 
  void clearLines() {
    // step 1: Loop through each row of the game board from the bottom to top
    for (int row = colLength - 1; row >= 0; row--) {
      // step 2: Initialize a variable to track if the row is full
      bool rowIsFull = true;

      // step 3: Check if the row is full (all columns in the row are filled with pieces)
      for (int col = 0; col < rowLength; col++) {
        // If there's an empty column, set rowIsFull to false and break the loop
        if (gameBoard[row][col] == null) {
          rowIsFull = false;
          break;
        }
      }

      // step 4: If the row is full, clear the row and shift rows down
      if (rowIsFull) {
        // step 5: move all rows above the cleared row down by one position
        for (int r = row; r > 0; r--) {
          //copy the row above to the current row
         gameBoard[r] = List.from(gameBoard[r - 1]); 
        }

        // step 6: set the top row to empty
        gameBoard[0] = List.generate(rowLength, (index) => null);

        // step 7: Increment the score!
        currentScore++;
      }
    }
  }

  //GAME OVER METHOD
  bool isGameOver() {
    // check if any columns in the top row are filled
    for (int col = 0; col < rowLength; col++) {
      if (gameBoard[0][col] != null) {
        return true; 
      }
    }

    // if the top row is empty, the game is not over
    return false; 
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //GAME GRID
        Expanded(
          child: GridView.builder(
            itemCount: rowLength * colLength,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: rowLength),
            itemBuilder: (context, index) { 
              //get row and col of each index
              int row = (index / rowLength).floor();
              int col = index % rowLength;
            
              //current piece
              if (currentPiece.position.contains(index)) {
                return Pixel(
                  color: currentPiece.color, 
                );
              }
            
              // landed pieces
              else if(gameBoard[row][col] != null){
                final Tetromino? tetrominoType = gameBoard[row][col];
                return Pixel(
                  // Fix: Use null-aware operator to provide a default color if the lookup returns null
                  color: tetrominoColors[tetrominoType] ?? Colors.white
                );
              }  
              //blank pixel
              else {
                return Pixel(
                  color: Colors.grey[900] ?? Colors.grey,
                );
              }
            },
          ),
        ),

        //SCORE
        Padding(
          padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
          child: Text(
            'Score: $currentScore',
            style: TextStyle(color: Colors.white, fontSize: 20)
          ),
        ),

        //GAME CONTROLS
        Padding(
          padding: const EdgeInsets.only(bottom: 50.0, top: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // left
              IconButton(
                onPressed: moveLeft,
                color: Colors.white,
                icon: Icon(Icons.arrow_back_ios, size: 30),
              ),
              
              //rotate
              IconButton(
                onPressed: rotatePiece,
                color: Colors.white, 
                icon: Icon(Icons.rotate_right, size: 30),
              ),
          
              //right
              IconButton(
                onPressed: moveRight,
                color: Colors.white, 
                icon: Icon(Icons.arrow_forward_ios, size: 30),
              ),
            ],
          ),
        )
      ],
    );
  }
}