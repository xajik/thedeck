/*
 *
 *  *
 *  * Created on 1 4 2023
 *
 */

import 'dart:math';

import '../game_board.dart';

class ConnectFourGameField extends GameField {
  static const int empty = 0;
  static const int yellow = 1;
  static const int red = 2;
  static const int _draw = 3;

  final int rows;
  final int cols;
  final List<List<int>> field;

  var _lastTurn = empty;
  var _winner = empty;

  get winner => _winner;

  get winnerIsYellow => _winner == yellow;

  get isDraw => _winner == _draw;

  get lastTurn => _lastTurn;

  ConnectFourGameField({this.rows = 6, this.cols = 7})
      : field = List.generate(rows, (_) => List.filled(cols, empty));

  bool makeMove(int col, bool isYellow) {
    if (isGameOver) {
      return false;
    }
    if (!_isTurn(isYellow)) {
      return false;
    }
    final player = isYellow ? yellow : red;
    for (int row = rows - 1; row >= 0; row--) {
      if (field[row][col] == empty) {
        field[row][col] = player;
        _winner = _checkWinner(row, col);
        if (_winner != empty) {
          isGameOver = true;
        }
        _takeTurn(isYellow);
        return true;
      }
    }
    return false;
  }

  bool _isTurn(bool isYellow) => isYellow
      ? _lastTurn == red || _lastTurn == empty
      : _lastTurn == yellow || _lastTurn == empty;

  void _takeTurn(bool isYellow) {
    isYellow ? _lastTurn = yellow : _lastTurn = red;
  }

  int _checkWinner(int row, int col) {
    int currPlayer = field[row][col];
    int rowCount = 0, colCount = 0, diagCount1 = 0, diagCount2 = 0;

    // Check for horizontal win
    for (int i = max(col - 3, 0);
        i <= min(col + 3, field[0].length - 1);
        i++) {
      if (field[row][i] == currPlayer) {
        colCount++;
      } else {
        colCount = 0;
      }

      if (colCount >= 4) {
        return currPlayer;
      }
    }

    // Check for vertical win
    for (int i = max(row - 3, 0); i <= min(row + 3, field.length - 1); i++) {
      if (field[i][col] == currPlayer) {
        rowCount++;
      } else {
        rowCount = 0;
      }

      if (rowCount >= 4) {
        return currPlayer;
      }
    }

    // Check for diagonal win (top left to bottom right)
    for (int i = -3; i <= 3; i++) {
      int currRow = row + i;
      int currCol = col + i;

      if (currRow >= 0 &&
          currRow < field.length &&
          currCol >= 0 &&
          currCol < field[0].length) {
        if (field[currRow][currCol] == currPlayer) {
          diagCount1++;
        } else {
          diagCount1 = 0;
        }

        if (diagCount1 >= 4) {
          return currPlayer;
        }
      }
    }

    // Check for diagonal win (top right to bottom left)
    for (int i = -3; i <= 3; i++) {
      int currRow = row - i;
      int currCol = col + i;

      if (currRow >= 0 &&
          currRow < field.length &&
          currCol >= 0 &&
          currCol < field[0].length) {
        if (field[currRow][currCol] == currPlayer) {
          diagCount2++;
        } else {
          diagCount2 = 0;
        }

        if (diagCount2 >= 4) {
          return currPlayer;
        }
      }
    }

    // Check for draw
    for (int i = 0; i < field.length; i++) {
      for (int j = 0; j < field[i].length; j++) {
        if (field[i][j] == empty) {
          // If any empty cell is found, game is not over yet
          return empty;
        }
      }
    }

    // No winner and no empty cells, game is a draw
    return _draw;
  }

  @override
  Map<String, dynamic> toMap() {
    final List<List<int?>> boardAsList =
    field.map((row) => row.toList()).toList();
    return {
      ...super.toMap(),
      'rows': rows,
      'lastTurn': _lastTurn,
      'winner': _winner,
      'cols': cols,
      'board': boardAsList,
    };
  }

  factory ConnectFourGameField.fromMap(Map<String, dynamic> map) {
    final int rows = map['rows'];
    final int cols = map['cols'];
    final List<List<int>> board = (map['board'] as List)
        .map((row) => (row as List).map((val) => val as int).toList())
        .toList();
    final ConnectFourGameField field =
    ConnectFourGameField(rows: rows, cols: cols);
    field.field.clear();
    field.field.addAll(board);
    field._winner = map['winner'];
    field._lastTurn = map['lastTurn'];
    field.isGameOver = map['isGameOver'];
    return field;
  }
}
