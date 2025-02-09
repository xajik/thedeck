/*
 *
 *  *
 *  * Created on 17 1 2023
 *
 */

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:the_deck/di/analytics.dart';
import 'package:the_deck/di/logger.dart';
import 'package:thedeck_client/the_deck_client.dart';
import 'package:thedeck_common/the_deck_common.dart';
import 'package:ulid/ulid.dart';

import '../../di/app_dependency.dart';
import '../../di/db/dao/game_log_dao.dart';
import '../../di/db/entity/game_log_entity.dart';
import '../../handlers/game_handler.dart';
import '../../handlers/room_handler.dart';
import '../../ui/screens/error/error_dialog_widget.dart';
import '../../utils/string_utils.dart';
import '../actions/game/redux_action_games.dart';
import '../actions/redux_action_room_connect.dart';
import '../actions/redux_action_room_create.dart';
import '../actions/reduxt_action_home_screen.dart';
import '../app_state.dart';
import 'redux_middleware_home.dart';
import 'redux_middleware_routing.dart';

ThunkActionWithExtraArgument<AppState, AppDependency> middlewareRoomConnect(
    RoomCreateDetails details,
    [bool isHost = false,
    bool isTheDeck = false]) {
  return (store, dependency) async {
    final log = dependency.logger;
    final analytics = dependency.analytics;
    final ip = await dependency.networkInfo.getWifiIP();
    log.d('Client IP: $ip', tag: 'RoomConnectMiddleware');
    log.d('RoomCreateDetails: ${details.toJson()}',
        tag: 'RoomConnectMiddleware');
    if (ip != null) {
      store.dispatch(RoomSocketClientUpdateDetailsAction(details));

      final roomId = details.roomId;
      final gameId = details.details.gameId;
      final address = details.ip;
      dispatcher(action) => store.dispatch(action);

      final socketClient = dependency.gameSocketClient;

      _registerHandlers(dispatcher, socketClient, roomId, gameId);

      final connected =
          await _connectToSocket(socketClient, address, log, analytics);

      if (!connected) {
        failedToConnect(analytics, log, socketClient, store);
        return;
      }

      final userEntity = store.state.userState.user;
      final participant = GameParticipant(
        userId: userEntity?.getKey() ?? getRandomString(10),
        sessionId: Ulid().toUuid(),
        isHost: isHost,
        profile: ParticipantProfile(
          nickname: userEntity?.nickName ?? getRandomString(10),
          image: null, //todo add icon support
          score: userEntity?.score ?? 0,
        ),
      );

      if (isTheDeck) {
        socketClient.subscribeToRoomUpdate(roomId, participant);
      } else {
        socketClient.joinRoom(roomId, participant);
        _createGameRoomLog(details, dependency.dao.gameLogDao);
        store.dispatch(middlewareReconnectToGameData());
      }

      analytics.reportConnectedToGame(gameId);

      if (kDebugMode) {
        // _addRandomParticipant(details.roomId, api, 4);
      }
    } else {
      store.dispatch(RoomSocketClientFailedAction());
      final args = {
        ErrorDialogWidget.typeKey: ErrorDialogType.noInternet,
      };
      store.dispatch(middlewareRouteErrorDialog(args));
    }
  };
}

void failedToConnect(Analytics analytics, Logger log,
    GameSocketClient socketClient, Store<AppState> store) {
  analytics.reportTimeoutToConnect();
  log.d('Failed to connect to the room', tag: 'RoomConnectMiddleware');
  socketClient.reset();
  store.dispatch(RoomSocketClientFailedAction());
  final args = {
    ErrorDialogWidget.typeKey: ErrorDialogType.failedToConnectToRoom,
  };
  store.dispatch(middlewareRouteErrorDialog(args));
}

Future<bool> _connectToSocket(
  GameSocketClient socketClient,
  String address,
  Logger log,
  Analytics analytics,
) async {
  var connected = false;
  try {
    final clientUseCase = socketClient.socketClientUseCase;
    connected = await clientUseCase.connect(address);
  } catch (e) {
    log.e('Error connecting to server: $e', tag: 'RoomConnectMiddleware');
    analytics.reportCrashOnConnect();
  }
  return connected;
}

void _registerHandlers(
  Function(dynamic action) dispatcher,
  GameSocketClient socketClient,
  String roomId,
  int gameId,
) {
  final roomHandler = RoomHandler(dispatcher);
  socketClient.roomListener(roomHandler, roomId);

  final gameHandler = gameHandlerFactory(gameId, dispatcher);
  if (gameHandler != null) {
    socketClient.gameListener(gameId, gameHandler);
  }
}

void _addRandomParticipant(String roomId, GameSocketClient api, int count) {
  for (int i = 0; i < count; i++) {
    final participant = GameParticipant(
      userId: getRandomString(10),
      sessionId: Ulid().toUuid(),
      isHost: false,
      profile: ParticipantProfile(
        nickname: getRandomString(10),
        image: null, //todo add icon support
        score: 0, //todo add score support
      ),
    );
    api.joinRoom(roomId, participant);
  }
}

_createGameRoomLog(RoomCreateDetails details, GameLogDao dao) {
  final log = dao.getLog(details.roomId) ??
      GameLogEntity.create(
        roomId: details.roomId,
        gameId: details.details.gameId,
        address: details.ip,
        gameState: GameLogState.created,
      );
  if (log.getGameState() == GameLogState.over) {
    return;
  }
  log.updated = DateTime.now();
  dao.insertOrUpdate(log);
  return log;
}

ThunkActionWithExtraArgument<AppState, AppDependency>
    middlewareDisposeRoomConnection() {
  return (store, dependency) async {
    await _disposeClientConnection(store, dependency);
  };
}

ThunkActionWithExtraArgument<AppState, AppDependency>
    middlewareServerClosedRoom(String? roomId) {
  return (store, dependency) async {
    await _disposeClientConnection(store, dependency);
    dependency.router.popFromAnyGame();
    store.dispatch(middlewareRemoveReconnectToGame());
  };
}

Future<void> _disposeClientConnection(
    Store<AppState> store, AppDependency dependency) async {
  final roomId = store.state.roomConnect.details?.roomId;
  final userId = store.state.userState.userId;
  if (roomId != null) {
    final message = ClientDisconnectSocketMessage(userId, roomId);
    dependency.gameSocketClient.clientApi.disconnect(roomId, message);
  }
  await dependency.gameSocketClient.reset();
  store.dispatch(RoomSocketClientClosedAction());
  store.dispatch(ClearAllGamesState());
}

ThunkActionWithExtraArgument<AppState, AppDependency>
    middlewareNewParticipantsRoom(List<GameParticipant> participants) {
  return (store, dependency) async {
    store.dispatch(RoomParticipantsListClientRoomAction(participants));
    store.dispatch(middlewareUpdateLeaderboardWithParticipants(participants));
  };
}

ThunkActionWithExtraArgument<AppState, AppDependency>
    middlewareRoomConnectWifiInfoConnection() {
  return (store, dependency) async {
    final name = await dependency.networkInfo.getWifiName();
    store.dispatch(RoomConnectClientWifiAction(name));
  };
}

ThunkActionWithExtraArgument<AppState, AppDependency>
    middlewareRoomConnectCameraPermission() {
  return (store, dependency) async {
    final logger = dependency.logger;
    Permission.camera.status.then((value) {
      logger.d("Camera permission check: ${value}",
          tag: "RoomConnectMiddleware");
      if (PermissionStatus.denied == value) {
        return Permission.camera.request();
      }
      return Future.value(value);
    }).then((permission) {
      logger.d("Camera permission request: $permission",
          tag: "RoomConnectMiddleware");
      if (permission != PermissionStatus.granted) {
        final args = {
          ErrorDialogWidget.typeKey: ErrorDialogType.cameraPermission,
        };
        store.dispatch(middlewareRouteErrorDialog(args));
      }
    });
  };
}

ThunkActionWithExtraArgument<AppState, AppDependency> middlewareRoomOnResume() {
  return (store, dependency) async {
    final log = dependency.logger;
    final roomDetails = store.state.roomConnect.details;
    final roomId = roomDetails?.roomId;
    final game = roomDetails?.details;
    if (roomId != null && game != null) {
      log.d('Lifecycle on Resume, request update',
          tag: 'RoomConnectMiddleware');
      final userEntity = store.state.userState.user;
      final api = dependency.gameSocketClient.clientApi;
      api.requestUpdateField(game.gameId,
          RequestFieldUpdateSocketMessage(userEntity?.getKey(), roomId));
    }
  };
}

ThunkActionWithExtraArgument<AppState, AppDependency> middlewareRoomReadyUpdate(
    String roomId, bool isReady) {
  return (store, dependency) async {
    store.dispatch(RoomReadyRoomAction(isReady));
  };
}

ThunkActionWithExtraArgument<AppState, AppDependency>
    middlewareRoomReconnect() {
  return (store, dependency) async {
    store.dispatch(ReconnectToGameRoomAction(null));

    final gameLog = dependency.dao.gameLogDao.getLastLog();
    if (gameLog != null && gameLog.getGameState() == GameLogState.started) {
      final roomId = gameLog.roomId;
      final gameId = gameLog.gameId;
      final address = gameLog.address;
      dispatcher(action) => store.dispatch(action);
      final socketClient = dependency.gameSocketClient;

      _registerHandlers(dispatcher, socketClient, roomId, gameId);

      final log = dependency.logger;
      final analytics = dependency.analytics;

      final connected =
          await _connectToSocket(socketClient, address, log, analytics);

      if (!connected) {
        store.dispatch(middlewareReconnectToGameData());
        failedToConnect(analytics, log, socketClient, store);
        return;
      }

      final game = GamesListExtension.getById(gameId)?.details;
      if (game != null) {
        final details = RoomCreateDetails(address, roomId, game);
        store.dispatch(RoomSocketClientUpdateDetailsAction(details));
      }

      final userId = store.state.userState.userId;
      final data = ParticipantReconnectSocketMessage(userId);
      socketClient.reconnectToRoom(roomId, data);

      store.dispatch(middlewareRemoveReconnectToGame());
    } else {
      store.dispatch(middlewareReconnectToGameData());
    }
  };
}
