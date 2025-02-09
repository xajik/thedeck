/*
 *
 *  *
 *  * Created on 17 1 2023
 *
 */


import 'package:thedeck_common/the_deck_common.dart';

class RoomSocketClientFailedAction {
  RoomSocketClientFailedAction();
}

class RoomSocketClientClosedAction {
  RoomSocketClientClosedAction();
}

class RoomSocketClientUpdateDetailsAction {
  final RoomCreateDetails details;

  RoomSocketClientUpdateDetailsAction(this.details);
}

class RoomSocketClientRemoveDetailsAction {
  RoomSocketClientRemoveDetailsAction();
}

class RoomParticipantsListClientRoomAction {
  final List<GameParticipant> participants;

  RoomParticipantsListClientRoomAction(this.participants);
}

class RoomConnectClientWifiAction {
  final String? wifiName;

  RoomConnectClientWifiAction(this.wifiName);
}