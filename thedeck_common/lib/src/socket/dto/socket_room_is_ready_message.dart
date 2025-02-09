/*
 *
 *  *
 *  * Created on 25 3 2023
 *
 */

import '../../encodable/encodable_json.dart';
import '../../game/game_participant.dart';

class SocketRoomIsReadyMessage extends JsonEncodeable {
  final String roomId;
  final bool isReady;

  SocketRoomIsReadyMessage(this.roomId, this.isReady);

  @override
  Map<String, dynamic> toMap() {
    return {
      'roomId': roomId,
      'isReady': isReady,
    };
  }

  factory SocketRoomIsReadyMessage.fromMap(Map<String, dynamic> map) {
    return SocketRoomIsReadyMessage(
      map['roomId'],
      map['isReady'],
    );
  }
}
