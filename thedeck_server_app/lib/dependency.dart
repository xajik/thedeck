/*
 *
 *  *
 *  * Created on 5 6 2023
 *
 */

import 'package:thedeck_server/server_logger.dart';
import 'package:thedeck_server/the_deck_server.dart';

class AppDependency {
  final ServerLogger log;
  late final GameSocketServer socketServer;

  AppDependency._(
    this.log,
    this.socketServer,
  );

  factory AppDependency.create() {
    final log = ServerLogger();
    final server = GameSocketServer.create(log);
    return AppDependency._(
      log,
      server,
    );
  }
}
