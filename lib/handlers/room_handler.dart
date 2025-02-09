/*
 *
 *  *
 *  * Created on 27 5 2023
 *
 */

import 'package:thedeck_client/the_deck_client.dart';
import 'package:thedeck_common/the_deck_common.dart';

import '../redux/middleware/redux_middleware_home.dart';
import '../redux/middleware/redux_middleware_room_connect.dart';

class RoomHandler extends RoomClientHandler {
  final Function _dispatcher;

  RoomHandler(this._dispatcher);

  @override
  void observer(GameParticipant observer) {
    _dispatcher(middlewareUpdateLeaderboardWithParticipants([observer]));
  }

  @override
  void participants(List<GameParticipant> participants) {
    _dispatcher(middlewareNewParticipantsRoom(participants));
  }

  @override
  void roomClosed(String? roomId) {
    _dispatcher(middlewareServerClosedRoom(roomId));
  }

  @override
  void roomReady(String roomId, bool isReady) {
    _dispatcher(middlewareRoomReadyUpdate(roomId, isReady));
  }
}
