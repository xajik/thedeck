/*
 *
 *  *
 *  * Created on 25 3 2023
 *
 */

import '../../encodable/encodable_json.dart';

class SocketConnectedAckMessage extends JsonEncodeable {
  final dynamic socketId;

  SocketConnectedAckMessage(this.socketId);

  @override
  Map<String, dynamic> toMap() {
    return {
      'socketId': socketId,
    };
  }
}
