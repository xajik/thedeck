/*
 *
 *  *
 *  * Created on 20 5 2023
 *
 */

import 'dart:async';

import 'package:thedeck_common/the_deck_common.dart';
import 'package:thedeck_server/src/usecase/game_move_use_case.dart';

List<StreamSubscription> connectFourServerMessageHandlers(
    SocketMessageStream stream,
    gameId,
    GameMoveUseCase gameMoveUseCase,
    String roomId) {
  final subs = <StreamSubscription>[];
  subs.add(
    stream.subscribeWhere(ApiConstantsSocketPath.move(gameId),
        ((Map<String, dynamic> map) {
      final socketId = map[ApiConstantsSocketPayload.socketId];
      final move =
          ConnectFourGameMove.fromMap(map[ApiConstantsSocketPayload.data]);
      gameMoveUseCase.move(roomId, move, socketId);
    })),
  );
  return subs;
}
