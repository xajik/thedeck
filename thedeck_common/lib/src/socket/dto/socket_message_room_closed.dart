/*
 *
 *  *
 *  * Created on 25 3 2023
 *
 */

import '../../encodable/encodable_json.dart';

class RoomClosedSocketMessage extends JsonEncodeable {
  final String? roomId;

  RoomClosedSocketMessage(this.roomId);

  @override
  Map<String, dynamic> toMap() {
    return {
      'roomId': roomId,
    };
  }

  factory RoomClosedSocketMessage.fromMap(Map<String, dynamic> map) {
    return RoomClosedSocketMessage(
      map['roomId'],
    );
  }
}
