import 'package:flutter/material.dart';

void main() {
  runApp(const TicTacToe());
}

class TicTacToe extends StatelessWidget {
  const TicTacToe({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
        primaryColor: Colors.blue,
        hintColor: Colors.red,
        fontFamily: 'Roboto',
      ),
      home: Scaffold(
        backgroundColor: Colors.green.shade100,
        appBar: AppBar(
          title: const Text('Tic Tac Toe'),
        ),
        body: Board(),
      ),
    );
  }
}

class Board extends StatefulWidget {
  const Board({super.key});

  @override
  _BoardState createState() => _BoardState();
}

class _BoardState extends State<Board> {
  late List<List<int>> _board;
  late bool _playerX;
  late bool _gameOver;

  @override
  void initState() {
    super.initState();
    _initializeBoard();
  }

  void _initializeBoard() {
    _board = List.generate(4, (_) => List.filled(4, 0));
    _playerX = true;
    _gameOver = false;
  }

  void _resetBoard() {
    setState(() {
      _initializeBoard();
    });
  }

  void _placeMarker(int row, int col) {
    if (_board[row][col] == 0 && !_gameOver) {
      setState(() {
        _board[row][col] = _playerX ? 1 : 2;
        _playerX = !_playerX;
        _checkWinner();
      });
    }
  }

  void _checkWinner() {
    // Check rows
    for (int i = 0; i < 4; i++) {
      if (_board[i][0] != 0 &&
          _board[i][0] == _board[i][1] &&
          _board[i][1] == _board[i][2] &&
          _board[i][2] == _board[i][3]) {
        _gameOver = true;
        _showWinner(_board[i][0]);
        return;
      }
    }

    // Check columns
    for (int i = 0; i < 4; i++) {
      if (_board[0][i] != 0 &&
          _board[0][i] == _board[1][i] &&
          _board[1][i] == _board[2][i] &&
          _board[2][i] == _board[3][i]) {
        _gameOver = true;
        _showWinner(_board[0][i]);
        return;
      }
    }

    // Check diagonals
    if (_board[0][0] != 0 &&
        _board[0][0] == _board[1][1] &&
        _board[1][1] == _board[2][2] &&
        _board[2][2] == _board[3][3]) {
      _gameOver = true;
      _showWinner(_board[0][0]);
      return;
    }

    if (_board[0][3] != 0 &&
        _board[0][3] == _board[1][2] &&
        _board[1][2] == _board[2][1] &&
        _board[2][1] == _board[3][0]) {
      _gameOver = true;
      _showWinner(_board[0][3]);
      return;
    }

    // Check for draw
    bool isBoardFull = true;
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (_board[i][j] == 0) {
          isBoardFull = false;
          break;
        }
      }
    }
    if (isBoardFull) {
      _gameOver = true;
      _showWinner(0); // 0 indicates draw
    }
  }

  void _showWinner(int winner) {
    String message;
    if (winner == 1) {
      message = 'Player X wins!';
    } else if (winner == 2) {
      message = 'Player O wins!';
    } else {
      message = 'It\'s a draw!';
    }
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Game Over', style: TextStyle(color: Colors.blue)),
        content: Text(
          message,
          style: const TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetBoard();
            },
            child: const Text(
              'Play Again',
              style: TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String currentPlayer = _playerX ? 'Player X' : 'Player O';
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Current Turn: $currentPlayer',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4),
          itemCount: 16,
          itemBuilder: (BuildContext context, int index) {
            int row = index ~/ 4;
            int col = index % 4;
            return GestureDetector(
              onTap: () => _placeMarker(row, col),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Center(
                  child: _buildMarker(_board[row][col]),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        _gameOver
            ? ElevatedButton(
                onPressed: _resetBoard,
                child: const Text(
                  'Play Again',
                  style: TextStyle(color: Colors.red),
                ),
              )
            : const SizedBox(),
      ],
    );
  }

  Widget _buildMarker(int player) {
    if (player == 1) {
      return const Icon(Icons.close, size: 50, color: Colors.blue);
    } else if (player == 2) {
      return const Icon(Icons.panorama_fish_eye, size: 50, color: Colors.red);
    } else {
      return const SizedBox();
    }
  }
}
