/*
 *
 *  *
 *  * Created on 31 1 2023
 *
 */

import '../../utils/pair_utils.dart';
import '../game_board.dart';

class TicTacToeGameField extends GameField {
  static const int empty = 0;
  static const int cross = 1;
  static const int zero = 2;
  static const int _draw = 3;

  final field = List.generate(
      3, (i) => List.generate(3, (i) => empty, growable: false),
      growable: false);
  var _lastTurn = empty;
  var _winner = empty;

  get winner => _winner;

  get winnerIsCross => _winner == cross;

  get isDraw => _winner == _draw;

  get lastTurn => _lastTurn;

  TicTacToeGameField();

  bool _isTurn(bool isCross) => isCross
      ? _lastTurn == zero || _lastTurn == empty
      : _lastTurn == cross || _lastTurn == empty;

  bool makeMove(Pair<int, int> move, bool isCross) {
    if (isGameOver) {
      return false;
    }
    if (_isTurn(isCross)) {
      if (field[move.first][move.second] != empty) {
        return false;
      }
      field[move.first][move.second] = isCross ? cross : zero;
      _winner = _verifyGameOver();
      if (_winner != empty) {
        isGameOver = true;
      }
      _takeTurn(isCross);
      return true;
    }
    return false;
  }

  void _takeTurn(bool isCross) {
    isCross ? _lastTurn = cross : _lastTurn = zero;
  }

  int _verifyGameOver() {
    // Check rows
    for (var i = 0; i < 3; i++) {
      if (field[i][0] != empty &&
          field[i][0] == field[i][1] &&
          field[i][1] == field[i][2]) {
        return field[i][0];
      }
    }

    // Check columns
    for (var i = 0; i < 3; i++) {
      if (field[0][i] != empty &&
          field[0][i] == field[1][i] &&
          field[1][i] == field[2][i]) {
        return field[0][i];
      }
    }

    // Check diagonals
    if (field[0][0] != empty &&
        field[0][0] == field[1][1] &&
        field[1][1] == field[2][2]) {
      return field[0][0];
    }
    if (field[0][2] != empty &&
        field[0][2] == field[1][1] &&
        field[1][1] == field[2][0]) {
      return field[0][2];
    }

    // Check for draw
    if (field.every((row) => row.every((cell) => cell != empty))) {
      return _draw;
    }

    // Game is still ongoing
    return empty;
  }

  factory TicTacToeGameField.fromMap(Map<String, dynamic> map) {
    var game = TicTacToeGameField()
      .._lastTurn = map['lastTurn']
      .._winner = map['winner'];
    game.isGameOver = map['isGameOver'];
    final newField = map['field'];
    for (var i = 0; i < game.field.length; i++) {
      game.field[i] = [...newField[i]];
    }
    return game;
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'field': field,
      'lastTurn': _lastTurn,
      'winner': _winner,
    };
  }
}
