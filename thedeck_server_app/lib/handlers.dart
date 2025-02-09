/*
 *
 *  *
 *  * Created on 5 6 2023
 *
 */

import 'dart:io';

import 'package:thedeck_common/the_deck_common.dart';
import 'package:thedeck_server/the_deck_server.dart';

import 'dependency.dart';

Future<Pair<RoomCreateDetails?, ServerRoomError?>> createRoom(
  AppDependency deps,
  int gameId,
) async {
  final ip = await getIPAddress();

  final details = GamesListExtension.getById(gameId)?.details;
  if (details == null) {
    return Pair.of(null, ServerRoomError(ServerErrorCode.unknown_game_id));
  }
  final newRoom = await deps.socketServer.newRoomBuilder(ip, details, true);
  return newRoom;
}

Future<bool> isReady(
  AppDependency deps,
  String roomId,
) async {
  return deps.socketServer.isReady(roomId);
}


Future<bool> startRoom(
    AppDependency deps,
    String roomId,
    ) async {
  return deps.socketServer.startRoom(roomId);
}

Future<bool> closeRoom(
    AppDependency deps,
    String roomId,
    ) async {
  return deps.socketServer.closeRoom(roomId);
}

Future<String> getIPAddress() async {
  // Retrieve the list of network interfaces
  List<NetworkInterface> interfaces = await NetworkInterface.list();
  // Iterate over the interfaces and find the one with an IPv4 address
  for (NetworkInterface interface in interfaces) {
    for (InternetAddress address in interface.addresses) {
      if (!address.isLoopback && address.type == InternetAddressType.IPv4) {
        return address.address;
      }
    }
  }
  throw Exception("Failed to get IP address");
}
