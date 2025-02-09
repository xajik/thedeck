/*
 * Copyright (c) 2023 TheDeck.com - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 *
 * Created on Tue Jan 31 2023
 */


import '../encodable/encodable_json.dart';
import 'game_details.dart';
import 'game_participant.dart';
import 'game_board.dart';

class GameRoom<T extends GameBoard> extends JsonEncodeable {
  final int roomVersion;
  final String roomId;
  final List<GameParticipant> participants;
  final GameDetails details;
  final T board;

  GameRoom({
    required this.roomVersion,
    required this.roomId,
    required this.participants,
    required this.details,
    required this.board,
  });

  GameRoom.start({
    required this.roomId,
    required this.details,
    required this.board,
  })  : roomVersion = 0,
        participants = List.empty(growable: true);

  GameRoom<T> copyWith({
    List<GameParticipant>? participants,
    T? board,
  }) {
    return GameRoom<T>(
      roomVersion: roomVersion + 1,
      roomId: roomId,
      participants: participants ?? this.participants,
      details: details,
      board: board ?? this.board,
    );
  }

  factory GameRoom.fromMap(Map<String, dynamic> map, T board) {
    Iterable<dynamic> i = map['participants'];
    List<GameParticipant> participants =
        i.map((e) => GameParticipant.fromJson(e)).toList();
    return GameRoom(
      roomVersion: map['roomVersion'],
      roomId: map['roomId'],
      participants: participants,
      details: GameDetails.fromJson(map['details']),
      board: board,
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'roomVersion': roomVersion,
      'roomId': roomId,
      'participants': participants.map((p) => p.toMap()).toList(),
      'details': details.toMap(),
      'board': board.toMap(),
    };
  }

  bool join(GameParticipant participant) {
    if (participants.any((element) => element.userId == participant.userId)) {
      return false;
    }
    participants.add(participant);
    return true;
  }
}
