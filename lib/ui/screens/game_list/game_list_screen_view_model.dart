/*
 * Copyright (c) 2023 TheDeck.com - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 *
 * Created on Tue Jan 10 2023
 */

import 'package:redux/redux.dart';
import 'package:the_deck/redux/middleware/redux_middleware_routing.dart';
import 'package:thedeck_common/the_deck_common.dart';

import '../../../dto/game_dto.dart';
import '../../../redux/app_state.dart';
import '../no_network_room/no_network_room_dialog_widget_widget.dart';
import '../room/create/room_create_screen_widet.dart';
import '../start_game_confirmation/start_game_confirmation_dialog_widet.dart';

class GameListScreenViewModel {
  final Function([Map<String, dynamic> args]) webGameScreen;
  final Function([Map<String, dynamic> args]) roomConnect;
  final Function(GameDetails details) showStartGameConfirmationDialog;
  final Function(GameDetails details) createRoom;
  final Function(NoNetworkRoomDialogState state, [GameDetails? details])
      showNoWifiCreateRoomDialog;
  final bool hasInternet;
  final List<Game> games;
  final Function([Map<String, dynamic> args]) showGenericErrorDialog;

  GameListScreenViewModel(
    this.webGameScreen,
    this.roomConnect,
    this.showStartGameConfirmationDialog,
    this.createRoom,
    this.games,
    this.showNoWifiCreateRoomDialog,
    this.hasInternet,
    this.showGenericErrorDialog,
  );

  factory GameListScreenViewModel.create(Store<AppState> store) {
    webGameScreen([Map<String, dynamic> args = const {}]) {
      store.dispatch(middlewareRouteWebView(args));
    }

    showGenericErrorDialog([Map<String, dynamic> args = const {}]) {
      store.dispatch(middlewareRouteErrorDialog(args));
    }

    roomConnect([Map<String, dynamic> args = const {}]) {
      store.dispatch(middlewareRouteConnectRoom(args: args));
    }

    showStartGameConfirmationDialog(GameDetails details) {
      final args = {
        StartGameConfirmationDialogWidget.gameDetailsKey: details,
      };
      store.dispatch(middlewareShowStartGameConfirmationDialog(args: args));
    }

    final games = store.state.homeScreenState.recentGames;

    final hasInternet = store.state.homeScreenState.hasInternetConnection;

    showNoWifiCreateRoomDialog(NoNetworkRoomDialogState state,
        [GameDetails? details]) {
      final args = {
        NoNetworkRoomDialogScreenWidget.stateKey: state,
        NoNetworkRoomDialogScreenWidget.gameDetailsKey: details,
      };
      store.dispatch(middlewareShowNoNetworkRoomDialog(args));
    }

    createRoom(GameDetails details) {
      final args = {
        ...details.toMap(),
        ...{RoomCreateScreenWidget.hostIsTheDeckKey: true}
      };
      store.dispatch(middlewareRouteCreateRoom(args: args));
    }

    return GameListScreenViewModel(
      webGameScreen,
      roomConnect,
      showStartGameConfirmationDialog,
      createRoom,
      games,
      showNoWifiCreateRoomDialog,
      hasInternet,
      showGenericErrorDialog,
    );
  }
}
