/*
 *
 *  *
 *  * Created on 20 5 2023
 *
 */

import 'dart:io';

import 'package:thedeck_common/the_deck_common.dart';

import 'server_logger.dart';
import 'src/socket/game_socket_server.dart';

void main() async {
  final log = ServerLogger();
  final server = GameSocketServer.create(log);
  final ip = await getIPAddress();

  final newRoom =
      await server.newRoomBuilder(ip, GamesList.ticTacToe.details, true);
  if (newRoom.second != null) {
    log.e("Failed to create newRoom: ${newRoom.second!.code}");
  } else {
    final room = newRoom.first;
  }
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
