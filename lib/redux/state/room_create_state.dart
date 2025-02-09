/*
 *
 *  *
 *  * Created on 17 1 2023
 *
 */

import 'package:thedeck_common/the_deck_common.dart';

class RoomCreateState {
  final RoomCreateDetails? roomCreateDetails;
  final GameRoom? gameRoom;
  final String? wifiName;
  final List<GameParticipant> participants;
  final bool isReady;

  RoomCreateState({
    required this.roomCreateDetails,
    required this.gameRoom,
    required this.wifiName,
    required this.participants,
    required this.isReady,
  });

  RoomCreateState.empty()
      : roomCreateDetails = null,
        gameRoom = null,
        participants = List.empty(),
        isReady = false,
        wifiName = null;

  RoomCreateState copyWith({
    RoomCreateDetails? roomCreateDetails,
    GameRoom? gameRoom,
    String? wifiName,
    List<GameParticipant>? participants,
    bool? isReady,
  }) {
    return RoomCreateState(
      roomCreateDetails: roomCreateDetails ?? this.roomCreateDetails,
      gameRoom: gameRoom ?? this.gameRoom,
      participants: participants ?? this.participants,
      wifiName: wifiName ?? this.wifiName,
      isReady: isReady ?? this.isReady,
    );
  }
}
