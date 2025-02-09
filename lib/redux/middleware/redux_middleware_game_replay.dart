/*
 *
 *  *
 *  * Created on 24 6 2023
 *
 */

import 'package:redux_thunk/redux_thunk.dart';
import 'package:the_deck/redux/middleware/redux_middleware_routing.dart';

import '../../di/app_dependency.dart';
import '../actions/reduxt_action_home_screen.dart';
import '../actions/replay_game_actions.dart';
import '../app_state.dart';

ThunkActionWithExtraArgument<AppState, AppDependency>
    middlewareLoadGameReplayList() {
  return (store, dependency) async {
    final replayGames = dependency.dao.gameLogDao.getReplayGames();
    store.dispatch(LoadedReplayGamesAction(replayGames));
  };
}

ThunkActionWithExtraArgument<AppState, AppDependency> middlewareLoadGameReplay(
    int gameLogId) {
  return (store, dependency) async {
    final log = dependency.logger;
    final replayGames = dependency.dao.gameLogDao.getLogById(gameLogId);
    log.d('Loading replay id for $gameLogId found ${replayGames?.roomId}',
        tag: 'middlewareLoadGameReplay');
    if (replayGames != null) {
      store.dispatch(ReplayGameLoadAction(replayGames));
      dispatcher(action) => store.dispatch(action);
      dependency.replayGameUsecase.replay(replayGames, dispatcher);
    } else {
      store.dispatch(middlewareRouteErrorDialog());
    }
  };
}

ThunkActionWithExtraArgument<AppState, AppDependency> middlewareStopReplay() {
  return (store, dependency) async {
    dependency.replayGameUsecase.stop();
  };
}
