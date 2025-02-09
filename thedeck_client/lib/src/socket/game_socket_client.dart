/*
 *
 *  *
 *  * Created on 1 4 2023
 *
 */

import 'dart:async';

import 'package:thedeck_common/the_deck_common.dart';
import '../../the_deck_client.dart';
import '../game/handlers/socket_message_client_handler_connect_four.dart';
import '../game/handlers/socket_message_client_handler_dixit.dart';
import '../game/handlers/socket_message_client_handler_tic_tac_toe.dart';
import 'api/client_socket_api.dart';
import 'handlers/socket_message_client_handlers.dart';
import 'socket_client_use_case.dart';

class GameSocketClient {
  final SocketMessageStream socketMessageStream;
  final SocketClientUseCase socketClientUseCase;
  final ClientSocketApi clientApi;
  final List<StreamSubscription> _subscriptions = [];
  final CommonLogger logger;

  GameSocketClient(
    this.socketMessageStream,
    this.socketClientUseCase,
    this.clientApi,
    this.logger,
  );

  Future<void> reset() async {
    logger.d("Resetting socket client", tag: _Constants.tag);
    final subscriptions = List.from(_subscriptions);
    _subscriptions.clear();
    for (var element in subscriptions) {
      await element.cancel();
    }
    socketClientUseCase.dispose();
  }

  void joinRoom(dynamic roomId, GameParticipant participant) {
    clientApi.joinRoom(roomId, participant);
  }

  void reconnectToRoom(
      dynamic roomId, ParticipantReconnectSocketMessage participant) {
    clientApi.reconnectRoom(roomId, participant);
  }

  void subscribeToRoomUpdate(dynamic roomId, GameParticipant participant) {
    clientApi.subscribeRoom(roomId, participant);
  }

  void roomListener(RoomClientHandler handler, String roomId) {
    _subscriptions.addAll(roomClientMessageHandlers(
      socketMessageStream,
      roomId,
      handler,
    ));
  }

  void gameListener(
    int gameId,
    GameClientHandler handler,
  ) {
    _subscriptions.addAll(
      gameClientMessageListener(gameId, handler, socketMessageStream),
    );
  }

  factory GameSocketClient.create(CommonLogger logger) {
    final socketMessageStream =
        SocketMessageStream(logger, "SocketMessageStream-Server");
    final socketClientUseCase =
        SocketClientUseCase(socketMessageStream, log: logger);
    final clientApi = ClientSocketApi(socketClientUseCase);
    return GameSocketClient(
      socketMessageStream,
      socketClientUseCase,
      clientApi,
      logger,
    );
  }
}

mixin _Constants {
  static const tag = "GameSocketClient";
}
