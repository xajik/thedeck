/*
 *
 *  *
 *  * Created on 11 5 2023
 *
 */

import '../../encodable/encodable_json.dart';

class SocketDisconnectedSocketMessage extends JsonEncodeable {
  final String socketId;

  SocketDisconnectedSocketMessage(this.socketId);

  @override
  Map<String, dynamic> toMap() {
    return {
      'socketId': socketId,
    };
  }

  factory SocketDisconnectedSocketMessage.fromMap(Map<String, dynamic> map) {
    return SocketDisconnectedSocketMessage(
      map['socketId'],
    );
  }
}
