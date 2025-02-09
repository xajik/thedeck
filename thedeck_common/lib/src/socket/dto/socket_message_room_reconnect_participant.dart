/*
 *
 *  *
 *  * Created on 21 6 2023
 *
 */

import 'package:thedeck_common/src/encodable/encodable_json.dart';

class ParticipantReconnectSocketMessage extends JsonEncodeable {
  String userId;

  ParticipantReconnectSocketMessage(this.userId);

  @override
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
    };
  }

  factory ParticipantReconnectSocketMessage.fromMap(Map<String, dynamic> map) {
    return ParticipantReconnectSocketMessage(
      map['userId'],
    );
  }
}
