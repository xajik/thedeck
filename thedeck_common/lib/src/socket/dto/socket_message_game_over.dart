/*
 *
 *  *
 *  * Created on 25 3 2023
 *
 */


import '../../encodable/encodable_json.dart';
import '../../game/game_board.dart';

class GameOverMessage extends JsonEncodeable {
  final dynamic gameId;
  final GameBoard board;
  final GamePlayer? winner;

  GameOverMessage(this.gameId, this.board, this.winner);

  @override
  Map<String, dynamic> toMap() {
    return {
      'gameId': gameId,
      'board': board.toMap(),
      'winner': winner?.toMap(),
    };
  }
}
