/*
 *
 *  *
 *  * Created on 17 1 2023
 *
 */

import 'dart:async';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:thedeck_common/the_deck_common.dart';

import '../../di/app_dependency.dart';
import '../../ui/screens/error/error_dialog_widget.dart';
import '../actions/redux_action_room_connect.dart';
import '../app_state.dart';
import 'redux_middleware_room_connect.dart';
import 'redux_middleware_routing.dart';

ThunkActionWithExtraArgument<AppState, AppDependency> middlewareCreateRoom(
    GameDetails details, bool hostIsTheDeck) {
  return (store, dependency) async {
    final log = dependency.logger;
    final analytics = dependency.analytics;

    await _resetRoomServer(store, dependency);

    final networkInfo = dependency.networkInfo;
    final ip = await networkInfo.getWifiIP();
    if (ip == null) {
      store.dispatch(RoomDataFailedAction());
      _failedToCreateRoomWifiDialog(store);
      log.e("Missing WIFI connection", tag: "Middleware CreateRoom");
      return;
    }
    final gameSocketServer = dependency.gameSocketServer;
    final roomBuilder =
        await gameSocketServer.newRoomBuilder(ip, details, hostIsTheDeck);

    final roomDetails = roomBuilder.first;
    final error = roomBuilder.second;
    if (roomDetails == null || error != null) {
      analytics.reportFailedCreateRoom(error?.code);
      store.dispatch(RoomDataFailedAction());
      _failedToCreateRoomDialog(store);
      log.e("Failed to create room ${error.toString()}",
          tag: "Middleware CreateRoom");
      return;
    }
    log.e("Room details: ${roomDetails.toJson()}",
        tag: "Middleware CreateRoom");

    //TODO: requires Location permission
    final wifiName = await networkInfo.getWifiName();

    store.dispatch(RoomCreatedAction(
      roomDetails,
      wifiName,
    ));
    store.dispatch(middlewareRoomConnect(roomDetails, true, hostIsTheDeck));
  };
}

void _failedToCreateRoomWifiDialog(Store<AppState> store) {
  final args = {
    ErrorDialogWidget.typeKey: ErrorDialogType.noInternet,
  };
  store.dispatch(middlewareRouteErrorDialog(args));
}

void _failedToCreateRoomDialog(Store<AppState> store) {
  final args = {
    ErrorDialogWidget.typeKey: ErrorDialogType.failedToCreateRoom,
  };
  store.dispatch(middlewareRouteErrorDialog(args));
}

ThunkActionWithExtraArgument<AppState, AppDependency>
    middlewareDisposeRoomServer() {
  return (store, dependency) async {
    _resetRoomServer(store, dependency);
    store.dispatch(RoomDisposeSocketServerAction());
  };
}

Future<void> _resetRoomServer(
  Store<AppState> store,
  AppDependency dependency,
) async {
  final roomId = store.state.roomCreate.roomCreateDetails?.roomId;
  if (roomId != null) {
    dependency.gameSocketServer.closeRoom(roomId);
  }
  await dependency.gameSocketServer.reset();
}

ThunkActionWithExtraArgument<AppState, AppDependency> middlewareSendRoom() {
  return (store, dependency) async {
    final analytics = dependency.analytics;
    final roomId = store.state.roomCreate.roomCreateDetails?.roomId;
    if (roomId == null) {
      store.dispatch(RoomDataFailedAction());
      return;
    }
    final started = dependency.gameSocketServer.startRoom(roomId);
    analytics.reportServerStartGame(started);

    if (!started) {
      store.dispatch(RoomDataFailedAction());
      return;
    }
  };
}
