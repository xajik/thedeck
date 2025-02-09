/*
 *
 *  *
 *  * Created on 17 1 2023
 *
 */

import 'package:redux/redux.dart';
import 'package:thedeck_common/the_deck_common.dart';

import '../../../../redux/app_state.dart';
import '../../../../redux/middleware/redux_middleware_room_connect.dart';
import '../../../../redux/middleware/redux_middleware_room_create.dart';

class RoomCreateViewModel {
  final RoomCreateDetails? roomCreateDetails;
  final void Function(GameDetails details, bool hostIsTheDeck) createRoom;
  final void Function() disposeRoom;
  final void Function() startGame;
  final bool isReady;
  final List<String> joinedList;
  final String? wifiName;

  RoomCreateViewModel({
    required this.createRoom,
    this.roomCreateDetails,
    required this.disposeRoom,
    required this.startGame,
    required this.isReady,
    required this.joinedList,
    required this.wifiName,
  });

  factory RoomCreateViewModel.create(Store<AppState> store) {
    createRoom(GameDetails details, bool hostIsTheDeck) {
      store.dispatch(middlewareDisposeRoomConnection());
      store.dispatch(middlewareCreateRoom(details, hostIsTheDeck));
    }

    disposeRoom() {
      store.dispatch(middlewareDisposeRoomServer());
    }

    final ready = store.state.roomCreate.isReady;

    startGame() {
      if (ready) {
        store.dispatch(middlewareSendRoom());
      }
    }

    final wifiName = store.state.roomCreate.wifiName;
    final participants = store.state.roomCreate.participants
        .map((e) => e.profile.nickname)
        .toList();

    return RoomCreateViewModel(
      roomCreateDetails: store.state.roomCreate.roomCreateDetails,
      createRoom: createRoom,
      disposeRoom: disposeRoom,
      startGame: startGame,
      isReady: ready,
      wifiName: wifiName,
      joinedList: participants,
    );
  }
}
