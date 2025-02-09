/*
 *
 *  *
 *  * Created on 5 6 2023
 *
 */

import 'package:alfred/alfred.dart';
import 'package:thedeck_server_app/dependency.dart';
import 'package:thedeck_server_app/handlers.dart';

void main() async {
  final app = Alfred();
  final deps = AppDependency.create();

  app.all('/ping', (req, res) => {'result': 'pong'});

  app.get('/room/new/:gameId:int', (req, res) async {
    final gameId = req.params['gameId'];
    if (gameId == null || gameId is int == false) {
      throw AlfredException(500, {"message": "invalid parameter $gameId"});
    }
    final result = await createRoom(deps, gameId);
    return {
      'room': result.first?.toJson(),
      'error': result.second?.toJson(),
    };
  });

  app.get('/room/ready/:roomId', (req, res) async {
    final roomId = req.params['roomId'];
    if (roomId == null || roomId is String == false) {
      throw AlfredException(500, {"message": "invalid parameter $roomId"});
    }
    final result = await isReady(deps, roomId);
    return {
      'isReady': result,
    };
  });

  app.get('/room/start/:roomId', (req, res) async {
    final roomId = req.params['roomId'];
    if (roomId == null || roomId is String == false) {
      throw AlfredException(500, {"message": "invalid parameter $roomId"});
    }
    final result = await startRoom(deps, roomId);
    return {
      'started': result,
    };
  });

  app.get('/room/close/:roomId', (req, res) async {
    final roomId = req.params['roomId'];
    if (roomId == null || roomId is String == false) {
      throw AlfredException(500, {"message": "invalid parameter $roomId"});
    }
    final result = await closeRoom(deps, roomId);
    return {
      'closed': result,
    };
  });

  app.printRoutes();

  await app.listen(4040);
}
