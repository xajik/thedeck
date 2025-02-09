/*
 *
 *  *
 *  * Created on 17 1 2023
 *
 */


import 'package:thedeck_common/the_deck_common.dart';

class RoomConnectState {
  final RoomCreateDetails? details;
  final List<GameParticipant>? participants;
  final String? wifiName;

  RoomConnectState({
    required this.details,
    required this.participants,
    required this.wifiName,
  });

  RoomConnectState.empty([this.wifiName])
      : details = null,
        participants = null;

  RoomConnectState copyWith(
      {RoomCreateDetails? details,
      List<GameParticipant>? participants,
      String? wifiName}) {
    return RoomConnectState(
      details: details ?? this.details,
      participants: participants ?? this.participants,
      wifiName: wifiName ?? this.wifiName,
    );
  }
}
