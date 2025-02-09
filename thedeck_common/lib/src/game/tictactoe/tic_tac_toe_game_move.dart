/*
 *
 *  *
 *  * Created on 31 1 2023
 *
 */

import '../../utils/pair_utils.dart';
import '../game_board.dart';

class TicTacToeGameMove extends GameMove {
  final Pair<int, int> move;

  TicTacToeGameMove(String userId, this.move) : super(userId);

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'move': move.toMap(),
    };
  }

  factory TicTacToeGameMove.fromMap(Map<String, dynamic> json) {
    return TicTacToeGameMove(
      json["userId"],
      Pair.fromMap(json["move"]),
    );
  }
}
