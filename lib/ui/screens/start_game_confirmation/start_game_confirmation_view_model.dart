/*
 *
 *  *
 *  * Created on 23 4 2023
 *
 */

import 'package:redux/redux.dart';
import 'package:thedeck_common/the_deck_common.dart';

import '../../../redux/app_state.dart';
import '../../../redux/middleware/redux_middleware_routing.dart';
import '../room/create/room_create_screen_widet.dart';

class StartGameConfirmationViewModel {
  final Function(GameDetails, bool) createRoom;

  StartGameConfirmationViewModel._(this.createRoom);

  factory StartGameConfirmationViewModel.fromStore(Store<AppState> store) {
    createRoom(GameDetails gameDetails, bool hostIsTheDeck) {
      final args = {
        ...gameDetails.toMap(),
        ...{RoomCreateScreenWidget.hostIsTheDeckKey: hostIsTheDeck}
      };
      store.dispatch(middlewareRouteCreateRoom(args: args));
    }

    return StartGameConfirmationViewModel._(
      createRoom,
    );
  }
}
