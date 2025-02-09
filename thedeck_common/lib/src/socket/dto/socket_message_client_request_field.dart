/*
 *
 *  *
 *  * Created on 25 3 2023
 *
 */

import '../../encodable/encodable_json.dart';

class RequestFieldUpdateSocketMessage extends JsonEncodeable {
  final String? userId;
  final String? roomId;
  final String? socketId;

  RequestFieldUpdateSocketMessage(
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

  factory RequestFieldUpdateSocketMessage.fromMap(
    Map<String, dynamic> map,
    String? socketId,
  ) {
    return RequestFieldUpdateSocketMessage(
      map['userId'],
      map['roomId'],
      socketId,
    );
  }
}
