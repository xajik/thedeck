/*
 *
 *  *
 *  * Created on 28 7 2023
 *  
 */

import 'package:redux_thunk/redux_thunk.dart';
import 'package:thedeck_common/the_deck_common.dart';

import '../../../../di/app_dependency.dart';
import '../../../../di/db/entity/game_log_entity.dart';
import '../../../actions/game/redux_actions_mafia_game.dart';
import '../../../app_state.dart';
import '../../redux_middleware_routing.dart';
import '../reduxt_middleware_game.dart';

ThunkActionWithExtraArgument<AppState, AppDependency> middlewareMafiaNewRoom(
    GameRoom<MafiaGameBoard> room) {
  return (store, dependency) async {
    var userKey = store.state.userState.user!.getKey();
    final isPlayer =
        room.participants.any((element) => element.userId == userKey);

    store.dispatch(
      MafiaGameReplaceRoomAction(isPlayer ? userKey : null, room),
    );
    store.dispatch(middlewareRouteMafiaGame());
    store.dispatch(middlewareWriteGameLog(room, null, GameLogState.started));
  };
}

ThunkActionWithExtraArgument<AppState, AppDependency> middlewareMafiaClientMove(
    MafiaGameMove move) {
  return (store, dependency) async {
    final gameId = store.state.mafiaGameScreenState?.room.details.gameId;
    final api = dependency.gameSocketClient.clientApi;
    api.gameMove(gameId, move);
  };
}

ThunkActionWithExtraArgument<AppState, AppDependency> middlewareMafiaGameOver(
  MafiaGameBoard board,
  MafiaGamePlayer? winner,
) {
  return (store, dependency) async {
    final field = board.gameField;
    store.dispatch(MafiaGameReplaceFieldAction(field));
    final room = store.state.mafiaGameScreenState?.room;
    store.dispatch(middlewareWriteGameLog(
      room?.copyWith(board: board),
      winner,
      GameLogState.over,
    ));
  };
}
