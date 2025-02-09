/*
 *
 *  *
 *  * Created on 1 4 2023
 *
 */

import 'package:redux_thunk/redux_thunk.dart';
import 'package:thedeck_common/the_deck_common.dart';
import '../../../../di/app_dependency.dart';
import '../../../../di/db/entity/game_log_entity.dart';
import '../../../actions/game/redux_actions_tic_tac_toe_game.dart';
import '../../../app_state.dart';
import '../../redux_middleware_routing.dart';
import '../reduxt_middleware_game.dart';

ThunkActionWithExtraArgument<AppState, AppDependency>
    middlewareTicTacToeNewRoom(GameRoom<TicTacToeGameBoard> room) {
  return (store, dependency) async {
    final key = store.state.userState.user!.getKey();
    final isPlayer = room.participants.any((element) => element.userId == key);
    store.dispatch(TicTacToeUpdateRoomAction(isPlayer ? key : null, room));
    store.dispatch(middlewareRouteTicTacToeGame());
    store.dispatch(middlewareWriteGameLog(room, null, GameLogState.started));
  };
}

ThunkActionWithExtraArgument<AppState, AppDependency>
    middlewareTicTacToeClientMove(TicTacToeGameMove move) {
  return (store, dependency) async {
    final gameId = store.state.ticTacToeGameScreenState?.room.details.gameId;
    final api = dependency.gameSocketClient.clientApi;
    api.gameMove(gameId, move);
  };
}

ThunkActionWithExtraArgument<AppState, AppDependency>
    middlewareTicTacToeGameOver(
  TicTacToeGameBoard board,
  TicTacToeGamePlayer? winner,
) {
  return (store, dependency) async {
    final field = board.gameField;
    store.dispatch(TicTacToeGameReplaceFieldAction(field));
    final room = store.state.ticTacToeGameScreenState?.room;
    store.dispatch(middlewareWriteGameLog(
      room?.copyWith(board: board),
      winner,
      GameLogState.over,
    ));
  };
}
