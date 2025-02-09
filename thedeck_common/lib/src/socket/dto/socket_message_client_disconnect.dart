/*
 *
 *  *
 *  * Created on 25 3 2023
 *
 */

import '../../encodable/encodable_json.dart';

class ClientDisconnectSocketMessage extends JsonEncodeable {
  final String? userId;
  final String? roomId;
  final String? socketId;

  ClientDisconnectSocketMessage(
    this.userId,
    this.roomId, [
    this.socketId,
  ]);

  @override
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'roomId': roomId,
      'socketId': socketId,
    };
  }

  factory ClientDisconnectSocketMessage.fromMap(
      Map<String, dynamic> map, String? socketId) {
    return ClientDisconnectSocketMessage(
      map['userId'],
      map['roomId'],
      socketId,
    );
  }
}
