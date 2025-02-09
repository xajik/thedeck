/*
 *
 *  *
 *  * Created on 20 5 2023
 *
 */

import 'dart:async';

import 'package:thedeck_common/the_deck_common.dart';
import 'package:thedeck_server/src/room/provider/game_room_provider.dart';
import 'package:thedeck_server/src/socket/api/server_socket_api.dart';

import '../../../usecase/game_move_use_case.dart';
import 'socket_message_server_handler_connect_four.dart';
import 'socket_message_server_handler_dixit.dart';
import 'socket_message_server_handler_mafia.dart';
import 'socket_message_server_handler_tic_tac_toe.dart';

List<StreamSubscription> gameServerMessageHandlers(
  SocketMessageStream stream,
  gameId,
  GameRoomProvider gameRoomProvider,
  ServerSocketApi serverApi,
) {
  final subs = <StreamSubscription>[];
  subs.add(
    stream.subscribeWhere(ApiConstantsSocketPath.field(gameId),
        ((Map<String, dynamic> map) {
      final socketId = map[ApiConstantsSocketPayload.socketId];
      final request = RequestFieldUpdateSocketMessage.fromMap(
        map[ApiConstantsSocketPayload.data],
        socketId,
      );
      final roomId = request.roomId;
      if (roomId != null) {
        final gameRoom = gameRoomProvider.get(roomId);
        if (gameRoom != null) {
          serverApi.gameField(
            gameRoom.details.gameId,
            gameRoom.board.gameField,
            socketId,
          );
        }
      }
    })),
  );

  return subs;
}

List<StreamSubscription> gameSpecificMessageHandlers(
    final gameId,
    SocketMessageStream socketMessageStream,
    GameMoveUseCase gameMoveUseCase,
    String roomId,
    ) {
  if (GamesList.ticTacToe.id == gameId) {
    return ticTacToeServerMessageHandlers(
      socketMessageStream,
      gameId,
      gameMoveUseCase,
      roomId,
    );
  }
  if (GamesList.connectFour.id == gameId) {
    return connectFourServerMessageHandlers(
      socketMessageStream,
      gameId,
      gameMoveUseCase,
      roomId,
    );
  }
  if (GamesList.dixit.id == gameId) {
    return dixitServerMessageHandlers(
      socketMessageStream,
      gameId,
      gameMoveUseCase,
      roomId,
    );
  }
  if (GamesList.mafia.id == gameId) {
    return mafiaServerMessageHandlers(
      socketMessageStream,
      gameId,
      gameMoveUseCase,
      roomId,
    );
  }
  return [];
}
