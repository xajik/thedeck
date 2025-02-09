/*
 *
 *  *
 *  * Created on 25 3 2023
 *
 */

import '../../encodable/encodable_json.dart';
import '../../game/game_room.dart';

class GameRoomSocketMessage extends JsonEncodeable {
  final dynamic gameId;
  final GameRoom room;

  GameRoomSocketMessage(this.gameId, this.room);

  @override
  Map<String, dynamic> toMap() {
    return {
      'gameId': gameId,
      'room': room.toMap(),
    };
  }
}
