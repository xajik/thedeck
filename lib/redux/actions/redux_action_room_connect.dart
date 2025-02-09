/*
 *
 *  *
 *  * Created on 17 1 2023
 *
 */

import 'package:thedeck_common/the_deck_common.dart';

class RoomDataFailedAction {
  RoomDataFailedAction();
}

class RoomDisposeSocketServerAction {
  RoomDisposeSocketServerAction();
}

class RoomCreatedAction {
  final RoomCreateDetails roomCreateDetails;
  final String? wifiName;

  RoomCreatedAction(
    this.roomCreateDetails,
    this.wifiName,
  );
}

class RoomReadyRoomAction {
  final bool isReady;

  RoomReadyRoomAction(this.isReady);
}
