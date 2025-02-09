/*
 *
 *  *
 *  * Created on 1 4 2023
 *
 */

import '../game_board.dart';
import 'connect_four_game_field.dart';
import 'connect_four_game_move.dart';
import 'connect_four_game_player.dart';

class ConnectFourGameBoard extends GameBoard<ConnectFourGameField,
    ConnectFourGameMove, ConnectFourGamePlayer> {
  ConnectFourGameBoard(
      {required ConnectFourGameField gameField,
      required List<ConnectFourGamePlayer> players})
      : super(gameField: gameField, players: players);

  @override
  bool makeMove(ConnectFourGameMove move) {
    final isYellow =
        players.where((e) => e.userId == move.userId).first.isYellow;
    var moved = gameField.makeMove(move.col, isYellow);
    if (moved) {
      moves.add(move);
    }
    if (gameField.isGameOver && !gameField.isDraw) {
      winner = players.firstWhere(
        (e) => e.isYellow == gameField.winnerIsYellow,
      );
    }
    return moved;
  }

  ConnectFourGameBoard copyWith({ConnectFourGameField? gameField}) {
    return ConnectFourGameBoard(
      gameField: gameField ?? this.gameField,
      players: players,
    );
  }

  static ConnectFourGameBoard fromMap(Map<String, dynamic> map) {
    final List<ConnectFourGameMove> moves = [];
    for (final move in map['moves']) {
      moves.add(ConnectFourGameMove.fromMap(move));
    }

    final List<ConnectFourGamePlayer> players = [];
    for (final player in map['players']) {
      players.add(ConnectFourGamePlayer.fromMap(player));
    }

    final ConnectFourGameField gameField =
        ConnectFourGameField.fromMap(map['gameField']);

    final ConnectFourGameBoard gameBoard =
        ConnectFourGameBoard(gameField: gameField, players: players);

    gameBoard.moves.addAll(moves);

    if (map['winner'] != null) {
      gameBoard.winner = ConnectFourGamePlayer.fromMap(map['winner']);
    }

    return gameBoard;
  }

}
