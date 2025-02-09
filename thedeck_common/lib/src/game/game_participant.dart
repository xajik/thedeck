/*
 *
 *  *
 *  * Created on 12 3 2023
 *
 */

import '../encodable/encodable_json.dart';

class GameParticipant extends JsonEncodeable {
  final String userId;
  final String sessionId;
  final bool isHost;
  final ParticipantProfile profile;
  final String? socketId;

  GameParticipant({
    required this.userId,
    required this.sessionId,
    required this.isHost,
    required this.profile,
    this.socketId,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'sessionId': sessionId,
      'isHost': isHost,
      'profile': profile.toMap(),
    };
  }

  factory GameParticipant.fromJson(Map<String, dynamic> json,
      [String? socketId]) {
    return GameParticipant(
      userId: json['userId'],
      sessionId: json['sessionId'],
      isHost: json['isHost'],
      profile: ParticipantProfile.fromJson(json['profile']),
      socketId: socketId,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameParticipant &&
          runtimeType == other.runtimeType &&
          userId == other.userId &&
          sessionId == other.sessionId &&
          isHost == other.isHost &&
          profile == other.profile &&
          socketId == other.socketId;

  @override
  int get hashCode =>
      userId.hashCode ^
      sessionId.hashCode ^
      isHost.hashCode ^
      profile.hashCode ^
      socketId.hashCode;
}

class ParticipantProfile extends JsonEncodeable {
  final String nickname;
  final String? image;
  final int score;

  ParticipantProfile({
    required this.nickname,
    required this.image,
    required this.score,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'nickname': nickname,
      'image': image,
      'score': score,
    };
  }

  factory ParticipantProfile.fromJson(Map<String, dynamic> json) {
    return ParticipantProfile(
      nickname: json['nickname'],
      image: json['image'],
      score: json['score'],
    );
  }
}
