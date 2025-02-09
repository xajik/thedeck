/*
 *
 *  *
 *  * Created on 12 2 2023
 *
 */

import '../game_board.dart';
import 'tic_tac_toe_game_field.dart';
import 'tic_tac_toe_game_move.dart';
import 'tic_tac_toe_game_player.dart';

class TicTacToeGameBoard
    extends GameBoard<TicTacToeGameField, TicTacToeGameMove, TicTacToeGamePlayer> {
  TicTacToeGameBoard(TicTacToeGameField field, List<TicTacToeGamePlayer> players)
      : super(gameField: field, players: players);

  @override
  bool makeMove(TicTacToeGameMove move) {
    final isCross = players.where((e) => e.userId == move.userId).first.isCross;
    final moved = gameField.makeMove(move.move, isCross);
    if (moved) {
      moves.add(move);
    }
    if (gameField.isGameOver && !gameField.isDraw) {
      winner = players.firstWhere((e) => e.isCross == gameField.winnerIsCross);
    }
    return moved;
  }

  TicTacToeGameBoard copyWith({TicTacToeGameField? gameField}) {
    return TicTacToeGameBoard(gameField ?? this.gameField, players);
  }

  factory TicTacToeGameBoard.fromMap(Map<String, dynamic> map) {
    Iterable p = map['players'];
    final List<TicTacToeGamePlayer> players =
        p.map((e) => TicTacToeGamePlayer.fromMap(e)).toList();
    final List<TicTacToeGameMove> moves = [];
    for (final move in map['moves']) {
      moves.add(TicTacToeGameMove.fromMap(move));
    }
    var gameBoard = TicTacToeGameBoard(
      TicTacToeGameField.fromMap(map['gameField']),
      players,
    );
    gameBoard.moves.addAll(moves);

    if (map['winner'] != null) {
      gameBoard.winner = TicTacToeGamePlayer.fromMap(map['winner']);
    }
    return gameBoard;
  }
}
