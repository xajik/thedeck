/*
 *
 *  *
 *  * Created on 12 3 2023
 *
 */

import '../encodable/encodable_json.dart';
import 'game_participant.dart';

class GameObserver extends JsonEncodeable {
  final String userId;
  final String sessionId;
  final ParticipantProfile profile;

  GameObserver({
    required this.userId,
    required this.sessionId,
    required this.profile,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'sessionId': sessionId,
      'profile': profile.toMap(),
    };
  }

  factory GameObserver.fromJson(Map<String, dynamic> json) {
    return GameObserver(
      userId: json['userId'],
      sessionId: json['sessionId'],
      profile: ParticipantProfile.fromJson(json['profile']),
    );
  }
}
