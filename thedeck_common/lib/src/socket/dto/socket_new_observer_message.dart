/*
 *
 *  *
 *  * Created on 25 3 2023
 *
 */

import '../../encodable/encodable_json.dart';
import '../../game/game_participant.dart';

class SocketNewObserverMessage extends JsonEncodeable {
  final GameParticipant observer;

  SocketNewObserverMessage(this.observer);

  @override
  Map<String, dynamic> toMap() {
    return {'observer': observer.toMap()};
  }

  factory SocketNewObserverMessage.fromJson(Map<String, dynamic> json) {
    return SocketNewObserverMessage(
      GameParticipant.fromJson(json["observer"]),
    );
  }
}
