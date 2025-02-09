/*
 *
 *  *
 *  * Created on 25 3 2023
 *
 */

import '../../encodable/encodable_json.dart';
import '../../game/game_board.dart';

class StartGameSocketMessage extends JsonEncodeable {
  final dynamic gameId;
  final GameBoard board;

  StartGameSocketMessage(this.gameId, this.board);

  @override
  Map<String, dynamic> toMap() {
    return {
      'gameId': gameId,
      'board': board.toMap(),
    };
  }
}
