/*
 *
 *  *
 *  * Created on 1 4 2023
 *
 */

import 'dart:async';

import 'package:thedeck_common/the_deck_common.dart';

import '../room/builder/game_room_builder.dart';
import '../room/provider/game_room_builder_provider.dart';
import '../room/provider/game_room_provider.dart';
import '../usecase/game_move_use_case.dart';
import 'api/server_error.dart';
import 'api/server_socket_api.dart';
import 'handlers/game/socket_message_game_handlers.dart';
import 'handlers/socket_message_server_handlers.dart';
import 'socket_server_use_case.dart';

class GameSocketServer {
  final SocketServerUseCase _socketServerUseCase;
  final SocketMessageStream _socketMessageStream;
  final ServerSocketApi _serverApi;
  final List<StreamSubscription> _subscriptions = List.empty(growable: true);
  final GameRoomBuilderProvider _gameRoomBuilderProvider;
  final GameRoomProvider _gameRoomProvider;
  final GameMoveUseCase _gameMoveUseCase;
  final CommonLogger _log;

  GameSocketServer(
    this._socketMessageStream,
    this._socketServerUseCase,
    this._serverApi,
    this._gameRoomBuilderProvider,
    this._gameRoomProvider,
    this._log,
  ) : _gameMoveUseCase = GameMoveUseCase(_gameRoomProvider, _serverApi, _log);

  Future<void> reset() async {
    _log.d("Resetting socket server", tag: _Constants.tag);
    final subscriptions = List.from(_subscriptions);
    _subscriptions.clear();
    for (var element in subscriptions) {
      await element.cancel();
    }
    _gameRoomProvider.clear();
    _gameRoomBuilderProvider.clear();
    await _socketServerUseCase.dispose();
  }

  Future<Pair<RoomCreateDetails?, ServerRoomError?>> newRoomBuilder(
    String ip,
    GameDetails details,
    bool hostIsTheDeck,
  ) async {
    var port = -1;
    var attempts = 0;
    while (port <= 0 && attempts < 5) {
      _log.d("Create room, attempt ${attempts + 1}",
          tag: "Middleware CreateRoom");
      port = await _socketServerUseCase.create(attempts);
      attempts++;
    }
    if (port <= 0) {

      return Pair.of(null, ServerRoomError(ServerErrorCode.port_taken_error));
    }
    final builder = GameRoomBuilder.fromDetails(details, hostIsTheDeck);
    final address = "$ip:$port";
    var roomDetails = RoomCreateDetails(address, builder.roomId, details);
    _log.e("Room details: ${roomDetails.toJson()}",
        tag: "Middleware CreateRoom");
    _subscriptions.addAll(
      roomServerMessageHandlers(
        _socketMessageStream,
        roomDetails.roomId,
        _gameRoomBuilderProvider,
        _serverApi,
          _gameRoomProvider,
      ),
    );
    _gameRoomBuilderProvider.save(builder);
    return Pair.of(roomDetails, null);
  }

  bool isReady(String roomId) {
    final builder = _gameRoomBuilderProvider.get(roomId);
    if (builder == null) {
      return false;
    }
    if (builder.isReady()) {
      return true;
    }
    return false;
  }

  bool startRoom(String roomId) {
    final builder = _gameRoomBuilderProvider.get(roomId);
    if (builder == null) {
      return false;
    }
    if (!builder.isReady()) {
      return false;
    }
    final room = builder.start();
    if (room == null) {
      return false;
    }

    final details = builder.gameDetails;

    _subscribeHandlers(details, builder);

    _gameRoomProvider.save(room);
    _gameRoomBuilderProvider.remove(roomId);

    final data = GameRoomSocketMessage(room.details.gameId, room);
    _serverApi.gameRoom(room.details.gameId, data);
    return true;
  }

  void _subscribeHandlers(
    GameDetails details,
    GameRoomBuilder<GameRoom<GameBoard<GameField, GameMove, GamePlayer>>>
        builder,
  ) {
    _subscriptions.addAll(
      gameServerMessageHandlers(
        _socketMessageStream,
        details.gameId,
        _gameRoomProvider,
        _serverApi,
      ),
    );

    _subscriptions.addAll(
      gameSpecificMessageHandlers(
        details.gameId,
        _socketMessageStream,
        _gameMoveUseCase,
        builder.roomId,
      ),
    );
  }

  bool closeRoom(String roomId) {
    final data = RoomClosedSocketMessage(roomId);
    if (!_gameRoomProvider.contains(roomId) &&
        !_gameRoomBuilderProvider.contains(roomId)) {
      return false;
    }
    _serverApi.roomClosed(roomId, data);
    _gameRoomProvider.remove(roomId);
    _gameRoomBuilderProvider.remove(roomId);
    return true;
  }

  factory GameSocketServer.create(CommonLogger logger) {
    final socketMessageStream =
        SocketMessageStream(logger, "SocketMessageStream-Server");
    final socketServerUseCase =
        SocketServerUseCase(socketMessageStream, logger);
    final serverApi = ServerSocketApi(socketServerUseCase);
    final builderProvider = InMemoryGameRoomBuilderProvider();
    final roomProvider = InMemoryServerGameRoomProvider();
    return GameSocketServer(
      socketMessageStream,
      socketServerUseCase,
      serverApi,
      builderProvider,
      roomProvider,
      logger,
    );
  }
}

mixin _Constants {
  static const tag = "GameSocketServer";
}
