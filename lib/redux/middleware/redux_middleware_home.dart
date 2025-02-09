/*
 *
 *  *
 *  * Created on 17 1 2023
 *
 */

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:the_deck/di/db/entity/game_log_entity.dart';
import 'package:thedeck_common/the_deck_common.dart';

import '../../di/app_dependency.dart';
import '../../dto/reconnect_to_game.dart';
import '../actions/reduxt_action_home_screen.dart';
import '../app_state.dart';

ThunkActionWithExtraArgument<AppState, AppDependency>
    middlewareUpdateLeaderboardWithParticipants(List<GameParticipant> p) {
  return (store, dependency) async {
    final List<GameParticipant> participants = List.from(p);
    final currentUser = store.state.userState.userId;
    if (currentUser != null) {
      participants.removeWhere((e) => e.userId == currentUser);
    }
    dependency.dao.userProfileDao.saveGameParticipants(participants);
    final data = dependency.dao.userProfileDao.getLeaderboard();
    store.dispatch(LoadedLeaderboardAction(data));
  };
}

ThunkActionWithExtraArgument<AppState, AppDependency>
    middlewareRegisterConnectivityListener() {
  return (store, dependency) async {
    dependency.connectivity.checkConnectivity().then((state) =>
        store.dispatch(ChangeNetworkStateAction(_hasInternet(state))));
    dependency.connectivity.onConnectivityChanged.listen((event) {
      final hasInternet = _hasInternet(event);
      store.dispatch(ChangeNetworkStateAction(hasInternet));
    });
  };
}

ThunkActionWithExtraArgument<AppState, AppDependency>
    middlewareRegisterHotSpotConnectivityListener() {
  return (store, dependency) async {
    final log = dependency.logger;
    final connectivity = dependency.connectivity;
    connectivity.checkConnectivity().then((state) {
      log.d('Wifi state $state',
          tag: 'middlewareRegisterHotSpotConnectivityListener');
      store.dispatch(ChangeNetworkStateAction(_hasInternet(state)));
    });

    connectivity.onConnectivityChanged.listen((event) {
      final hasInternet = _hasInternet(event);
      log.d('Wifi state $event, internet: $hasInternet',
          tag: 'middlewareRegisterHotSpotConnectivityListener');
      store.dispatch(ChangeNetworkStateAction(hasInternet));
    });
  };
}

bool _hasInternet(event) {
  return event == ConnectivityResult.wifi ||
      event == ConnectivityResult.ethernet ||
      event == ConnectivityResult.vpn ||
      event == ConnectivityResult.other;
}

ThunkActionWithExtraArgument<AppState, AppDependency>
    middlewareReconnectToGameData() {
  return (store, dependency) async {
    final log = dependency.logger;
    final gameLog = dependency.dao.gameLogDao.getLastLog();
    if (gameLog != null && gameLog.getGameState() == GameLogState.started) {
      final reconnect = ReconnectToGameRoom(gameLog.gameId, gameLog.address);
      log.d('Can reconnect to ${reconnect.ip}',
          tag: 'middlewareReconnectToGameData');
      store.dispatch(ReconnectToGameRoomAction(reconnect));
    } else {
      log.d('No game to reconnect to', tag: 'middlewareReconnectToGameData');
      store.dispatch(ReconnectToGameRoomAction(null));
    }
  };
}

ThunkActionWithExtraArgument<AppState, AppDependency>
    middlewareRemoveReconnectToGame() {
  return (store, dependency) async {
    final log = dependency.logger;
    final gameLog = dependency.dao.gameLogDao.getLastLog();
    if (gameLog != null) {
      gameLog.setGameLogState(GameLogState.failed);
      dependency.dao.gameLogDao.insertOrUpdate(gameLog);
      log.d('Removed reconnect to ${gameLog.gameId}',
          tag: 'middlewareRemoveReconnectToGame');
    }
    store.dispatch(ReconnectToGameRoomAction(null));
  };
}
