/*
 *
 *  *
 *  * Created on 25 3 2023
 *
 */

import '../../encodable/encodable_json.dart';
import '../../game/game_participant.dart';

class SocketListParticipantsMessage extends JsonEncodeable {
  final List<GameParticipant> participants;

  SocketListParticipantsMessage(this.participants);

  @override
  Map<String, dynamic> toMap() {
    return {
      'participants': participants.map((e) => e.toMap()).toList(),
    };
  }
}
