/*
 *
 * Copyright (c) 2023 TheDeck.com - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited 
 * Proprietary and confidential 
 *
 * Created on 2023-06-23 
 */

import 'package:redux/redux.dart';
import 'package:thedeck_common/the_deck_common.dart';

import '../../../redux/app_state.dart';
import '../../../redux/middleware/redux_middleware_routing.dart';
import '../room/create/room_create_screen_widet.dart';
import '../start_game_confirmation/start_game_confirmation_dialog_widet.dart';

class NoNetworkRoomDialogViewModel {
  final Function([Map<String, dynamic> args]) connectToRoom;
  final Function(GameDetails details) gameConfirmationDialog;
  final Function(GameDetails details) createRoom;
  final Function() showGenericError;

  NoNetworkRoomDialogViewModel(
    this.connectToRoom,
    this.gameConfirmationDialog,
    this.createRoom,
    this.showGenericError,
  );

  factory NoNetworkRoomDialogViewModel.create(Store<AppState> store) {
    gameConfirmationDialog(GameDetails details) {
      final args = {
        StartGameConfirmationDialogWidget.gameDetailsKey: details,
      };
      store.dispatch(
        middlewareShowStartGameConfirmationDialog(args: args),
      );
    }

    createDeckRoom(GameDetails details) {
      final args = {
        ...details.toMap(),
        ...{RoomCreateScreenWidget.hostIsTheDeckKey: true}
      };
      store.dispatch(middlewareRouteCreateRoom(args: args));
    }

    connectToRoom([Map<String, dynamic> args = const {}]) {
      store.dispatch(middlewareRouteConnectRoom(args: args));
    }

    showGenericError([Map<String, dynamic> args = const {}]) {
      store.dispatch(middlewareRouteErrorDialog(args));
    }

    return NoNetworkRoomDialogViewModel(
      connectToRoom,
      gameConfirmationDialog,
      createDeckRoom,
      showGenericError,
    );
  }
}
