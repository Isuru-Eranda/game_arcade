import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:game_arcade/games/game3/piece.dart';
import 'package:game_arcade/games/game3/pixel.dart';
import 'package:game_arcade/games/game3/values.dart';
import 'package:game_arcade/controllers/score_controller.dart';

// Create game board
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
  // Current tetris piece
  Piece currentPiece = Piece(type: Tetromino.L);

  // Current score
  int currentScore = 0;

  // Game over status
  bool gameOver = false;

  // Pause state
  bool isPaused = false;

  // Score controller for saving scores
  final ScoreController _scoreController = ScoreController();

  @override
  void initState() {
    super.initState();

    // Start game when app starts
    startGame();
  }

  void startGame() {
    currentPiece.initializePiece();
    isPaused = false;

    // Frame refresh rate
    Duration frameRate = const Duration(milliseconds: 500);
    gameLoop(frameRate);
  }

  // Game loop
  void gameLoop(Duration frameRate) {
    Timer.periodic(
      frameRate,
      (timer) {
        if (isPaused || gameOver) {
          return; // Skip game logic if paused or game over
        }

        setState(() {
          // Clear lines
          clearLines();

          // Check landing
          checkLanding();

          // Check if game is over
          if (gameOver == true) {
            timer.cancel();
            showGameOverDialog();
          }

          // Move current piece down
          currentPiece.movePiece(Direction.down);
        });
      },
    );
  }

  // Toggle pause state
  void togglePause() {
    setState(() {
      isPaused = !isPaused;
    });
  }

  void checkLanding() {
    // if going down is occupied 
    if (checkCollision(Direction.down)) {
      // mark position as occupied on the gameboard
      for (int i = 0; i < currentPiece.position.length; i++) {
        int row = (currentPiece.position[i] / rowLength).floor();
        int col = currentPiece.position[i] % rowLength;
        if (row >= 0 && col >= 0) {
          gameBoard[row][col] = currentPiece.type;
        }
      }
      // once landed, create the next piece
      createNewPiece();
    }
  }

  void createNewPiece() {
    // create a random object to generate random tetromino types
    Random rand = Random();

    // create a new piece with random type
    Tetromino randomType = Tetromino.values[rand.nextInt(Tetromino.values.length)];
    currentPiece = Piece(type: randomType);
    currentPiece.initializePiece();

    if (isGameOver()) {
      gameOver = true;
    }
  }

  // Add the missing isGameOver method
  bool isGameOver() {
    // Check if any columns in the top row are filled
    for (int col = 0; col < rowLength; col++) {
      if (gameBoard[0][col] != null) {
        return true;
      }
    }
    return false;
  }

  void clearLines() {
    // Loop through each row from bottom to top
    for (int row = colLength - 1; row >= 0; row--) {
      bool rowIsFull = true;

      // Check if row is full
      for (int col = 0; col < rowLength; col++) {
        if (gameBoard[row][col] == null) {
          rowIsFull = false;
          break;
        }
      }

      // Clear full row and move rows down
      if (rowIsFull) {
        for (int r = row; r > 0; r--) {
          gameBoard[r] = List.from(gameBoard[r - 1]);
        }
        gameBoard[0] = List.generate(rowLength, (index) => null);
        currentScore++;
      }
    }
  }

  void moveLeft() {
    if (!checkCollision(Direction.left)) {
      setState(() {
        currentPiece.movePiece(Direction.left);
      });
    }
  }

  void moveRight() {
    if (!checkCollision(Direction.right)) {
      setState(() {
        currentPiece.movePiece(Direction.right);
      });
    }
  }

  void rotatePiece() {
    setState(() {
      currentPiece.rotatePiece();
    });
  }

  bool checkCollision(Direction direction) {
    for (int i = 0; i < currentPiece.position.length; i++) {
      int row = (currentPiece.position[i] / rowLength).floor();
      int col = currentPiece.position[i] % rowLength;

      if (direction == Direction.left) {
        col -= 1;
      } else if (direction == Direction.right) {
        col += 1;
      } else if (direction == Direction.down) {
        row += 1;
      }

      if (row >= colLength || col < 0 || col >= rowLength) {
        return true;
      }

      if (row >= 0 && col >= 0 && gameBoard[row][col] != null) {
        return true;
      }
    }
    return false;
  }

  // Game over message
  void showGameOverDialog() {
    // Save the score to Firestore
    _scoreController.saveScore(
      gameName: 'Tetris',
      score: currentScore,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Game Over'),
        content: Text("Your score is $currentScore"),
        actions: [
          TextButton(
            onPressed: () {
              // Reset the game
              resetGame();

              Navigator.pop(context);
            },
            child: const Text('Play Again'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Return to arcade
            },
            child: const Text('Main Menu'),
          ),
        ],
      ),
    );
  }

  // Reset game
  void resetGame() {
    // Clear the game board
    gameBoard = List.generate(
      colLength,
      (i) => List.generate(
        rowLength,
        (j) => null,
      ),
    );

    // New game
    gameOver = false;
    currentScore = 0;

    // Create new piece
    createNewPiece();

    // Start game again
    startGame();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main game content
        Column(
          children: [
            // GAME GRID
            Expanded(
              child: GridView.builder(
                itemCount: rowLength * colLength,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: rowLength,
                ),
                itemBuilder: (context, index) {
                  // Get row and col of each index
                  int row = (index / rowLength).floor();
                  int col = index % rowLength;

                  // Current piece
                  if (currentPiece.position.contains(index)) {
                    return Pixel(
                      color: currentPiece.color,
                    );
                  }

                  // Landed pieces
                  else if (gameBoard[row][col] != null) {
                    final Tetromino? tetrominoType = gameBoard[row][col];
                    return Pixel(
                      color: tetrominoColors[tetrominoType] ?? Colors.white,
                    );
                  }

                  // Blank pixel
                  else {
                    return Pixel(
                      color: Colors.grey[900] ?? Colors.grey,
                    );
                  }
                },
              ),
            ),

            // SCORE
            Padding(
              padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
              child: Text(
                'Score: $currentScore',
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),

            // GAME CONTROLS
            Padding(
              padding: const EdgeInsets.only(bottom:20.0, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Left
                  IconButton(
                    onPressed: moveLeft,
                    color: Colors.white,
                    icon: const Icon(Icons.arrow_back_ios, size: 30),
                  ),

                  // Rotate
                  IconButton(
                    onPressed: rotatePiece,
                    color: Colors.white,
                    icon: const Icon(Icons.rotate_right, size: 30),
                  ),

                  // Right
                  IconButton(
                    onPressed: moveRight,
                    color: Colors.white,
                    icon: const Icon(Icons.arrow_forward_ios, size: 30),
                  ),

                  // Pause/Resume
                  IconButton(
                    onPressed: togglePause,
                    color: Colors.white,
                    icon: Icon(
                      isPaused ? Icons.play_arrow : Icons.pause,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        // Pause overlay
        if (isPaused)
          Container(
            color: Colors.black.withAlpha(179), // Replace deprecated withOpacity
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'PAUSED',
                    style: TextStyle(
                      fontSize: 24,
                      color: const Color(0xFFFAFAFA),
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    onPressed: togglePause,
                    child: const Text('Resume Game'),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}