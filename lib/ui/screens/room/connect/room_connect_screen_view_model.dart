/*
 *
 *  *
 *  * Created on 17 1 2023
 *
 */

import 'dart:convert';

import 'package:redux/redux.dart';
import 'package:thedeck_common/the_deck_common.dart';

import '../../../../dto/generic_error_dto.dart';
import '../../../../redux/app_state.dart';
import '../../../../redux/middleware/redux_middleware_room_connect.dart';
import '../../../../redux/middleware/redux_middleware_routing.dart';

class RoomConnectScreenViewModel {
  final RoomCreateDetails? details;
  final GenericError error;
  final bool Function(RoomCreateDetails details) connect;
  final RoomCreateDetails? Function(String?) roomDetails;
  final void Function() disconnectFromRoom;
  final void Function() popScreen;
  final void Function() updateWifiInfo;
  final void Function() requestCameraPermission;
  final String? wifiName;
  final List<GameParticipant>? participants;

  RoomConnectScreenViewModel({
    required this.details,
    required this.connect,
    required this.roomDetails,
    required this.disconnectFromRoom,
    required this.popScreen,
    required this.participants,
    required this.error,
    required this.updateWifiInfo,
    required this.wifiName,
    required this.requestCameraPermission,
  });

  factory RoomConnectScreenViewModel.create(Store<AppState> store) {
    bool connect(RoomCreateDetails details) {
      if (GamesListExtension.existsByDetails(details.details)) {
        store.dispatch(middlewareRoomConnect(details));
        return true;
      }
      return false;
    }

    RoomCreateDetails? roomDetails(String? rawJson) {
      if (rawJson != null) {
        var raw = json.decode(rawJson);
        final details = RoomCreateDetails.fromJson(raw);
        if (GamesListExtension.existsByDetails(details.details)) {
          return details;
        }
      }
      return null;
    }

    popScreen() {
      store.dispatch(middlewareRouterPop());
    }

    updateWifiInfo() {
      store.dispatch(middlewareRoomConnectWifiInfoConnection());
    }

    requestCameraPermission() {
      store.dispatch(middlewareRoomConnectCameraPermission());
    }

    disconnect() {
      store.dispatch(middlewareDisposeRoomConnection());
    }

    return RoomConnectScreenViewModel(
      details: store.state.roomConnect.details,
      connect: connect,
      roomDetails: roomDetails,
      disconnectFromRoom: disconnect,
      popScreen: popScreen,
      error: GenericError.none,
      participants: store.state.roomConnect.participants,
      updateWifiInfo: updateWifiInfo,
      wifiName: store.state.roomConnect.wifiName,
      requestCameraPermission: requestCameraPermission,
    );
  }
}
