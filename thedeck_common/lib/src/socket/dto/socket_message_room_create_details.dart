/*
 *
 *  *
 *  * Created on 20 5 2023
 *
 */

import '../../encodable/encodable_json.dart';
import '../../game/game_details.dart';

class RoomCreateDetails extends JsonEncodeable {
  final String ip;
  final String roomId;
  final GameDetails details;

  RoomCreateDetails(this.ip, this.roomId, this.details);

  @override
  Map<String, dynamic> toMap() {
    return {
      "ip": ip,
      "roomId": roomId,
      "details": details.toMap(),
    };
  }

  factory RoomCreateDetails.fromJson(Map<String, dynamic> map) {
    return RoomCreateDetails(
      map["ip"],
      map["roomId"],
      GameDetails.fromJson(map["details"]),
    );
  }
}
