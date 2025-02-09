/*
 *
 *  *
 *  * Created on 7 5 2023
 *
 */

import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:the_deck/redux/middleware/redux_middleware_game_replay.dart';
import 'package:thedeck_common/the_deck_common.dart';

import '../../../di/app_dependency.dart';
import '../../../di/db/entity/game_log_entity.dart';
import '../../app_state.dart';
import '../redux_middleware_home.dart';
import '../redux_middleware_room_connect.dart';
import '../redux_middleware_room_create.dart';
import '../redux_middleware_user_profile.dart';

ThunkActionWithExtraArgument<AppState, AppDependency> middlewareLeaveGame() {
  return (store, dependency) async {
    _disposeServerAndClient(store);
    dependency.router.popFromAnyGame();
    store.dispatch(middlewareRemoveReconnectToGame());
  };
}

ThunkActionWithExtraArgument<AppState, AppDependency>
    middlewareShowLeaveGameDialog() {
  return (store, dependency) async {
    dependency.router.leaveGameDialog({});
  };
}

ThunkActionWithExtraArgument<AppState, AppDependency>
    middlewareDisposeServerAndClient() {
  return (store, dependency) async {
    _disposeServerAndClient(store);
  };
}

void _disposeServerAndClient(Store<AppState> store) {
  store.dispatch(middlewareDisposeRoomConnection());
  final isServer = store.state.roomCreate.gameRoom != null;
  if (isServer) {
    store.dispatch(middlewareDisposeRoomServer());
  }
}

ThunkActionWithExtraArgument<AppState, AppDependency> middlewareWriteGameLog(
  GameRoom? room,
  GamePlayer? winner,
  GameLogState state,
) {
  return (store, dependency) async {
    final log = dependency.logger;
    if (room != null) {
      log.d("Create log for: ${room.roomId}, game over: ${state.name}",
          tag: "middlewareWriteGameLog");
      final gameLog = dependency.dao.gameLogDao.getLog(room.roomId);
      if (gameLog == null) {
        log.e("Room: $room log doesn't exist", tag: "middlewareWriteGameLog");
      } else {
        final logPath = await dependency.gameLogFileManager.saveLog(
          room.roomId,
          room,
        );
        gameLog.logPath = logPath;
        gameLog.setGameLogState(state);
        gameLog.updated = DateTime.now();
        dependency.dao.gameLogDao.insertOrUpdate(gameLog);

        store.dispatch(middlewareReconnectToGameData());
      }

      final userId = store.state.userState.user?.getKey();
      final winnerUserId = winner?.userId;
      if (userId != null && winnerUserId != null) {
        var score = 10;
        if (userId == winnerUserId) {
          final gameId = room.details.gameId;
          final game = GamesListExtension.getById(gameId);
          score *= game?.complexity ?? 1;
        }
        store.dispatch(middlewareAddScore(score));
      }

      store.dispatch(middlewareLoadAchievements());

      store.dispatch(middlewareLoadLeaderboard());

      store.dispatch(middlewareLoadGameReplayList());
    } else {
      log.e("Room is null", tag: "middlewareWriteGameLog");
    }
  };
}
