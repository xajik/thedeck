/*
 *
 *  *
 *  * Created on 3 4 2023
 *
 */

import '../game_board.dart';
import 'dixit_game_move.dart';
import 'dixit_game_field.dart';
import 'dixit_game_player.dart';

class DixitGameBoard
    extends GameBoard<DixitGameField, DixitGameMove, DixitGamePlayer> {
  DixitGameBoard(
      {required DixitGameField gameField,
      required List<DixitGamePlayer> players})
      : super(gameField: gameField, players: players);

  @override
  bool makeMove(move) {
    final moved = gameField.move(move);
    if (moved) {
      moves.add(move);
    }
    if (gameField.isGameOver) {
      final winnerUserId = gameField.winner;
      final winnerProfile = players.firstWhere((e) => e.userId == winnerUserId);
      winner = winnerProfile;
    }
    return moved;
  }

  DixitGameBoard copyWith(
      {DixitGameField? gameField, List<DixitGamePlayer>? players}) {
    return DixitGameBoard(
      gameField: gameField ?? this.gameField,
      players: players ?? this.players,
    );
  }

  factory DixitGameBoard.fromMap(Map<String, dynamic> map) {
    final board = DixitGameBoard(
      gameField: DixitGameField.fromMap(map['gameField']),
      players: List<DixitGamePlayer>.from(
        map['players'].map((x) => DixitGamePlayer.fromMap(x)),
      ),
    );

    final List<DixitGameMove> moves = [];
    for (final move in map['moves']) {
      moves.add(DixitGameMove.fromMap(move));
    }

    board.moves.addAll(moves);

    if (map['winner'] != null) {
      board.winner = DixitGamePlayer.fromMap(map['winner']);
    }

    return board;
  }
}
