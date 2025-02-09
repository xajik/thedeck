/*
 *
 *  *
 *  * Created on 23 3 2023
 *
 */

import 'package:redux_thunk/redux_thunk.dart';
import 'package:the_deck/redux/middleware/redux_middleware_routing.dart';
import 'package:thedeck_common/the_deck_common.dart';

import '../../../../di/app_dependency.dart';
import '../../../../di/db/entity/game_log_entity.dart';
import '../../../actions/game/redux_actions_connect_four_game.dart';
import '../../../app_state.dart';
import '../reduxt_middleware_game.dart';

ThunkActionWithExtraArgument<AppState, AppDependency>
    middlewareConnectFourNewRoom(GameRoom<ConnectFourGameBoard> room) {
  return (store, dependency) async {
    var userKey = store.state.userState.user!.getKey();
    final isPlayer =
        room.participants.any((element) => element.userId == userKey);

    store.dispatch(
      ConnectFourGameReplaceRoomAction(isPlayer ? userKey : null, room),
    );
    store.dispatch(middlewareRouteConnectFourGame());
    store.dispatch(middlewareWriteGameLog(room, null, GameLogState.started));
  };
}

ThunkActionWithExtraArgument<AppState, AppDependency>
    middlewareConnectFourClientMove(ConnectFourGameMove move) {
  return (store, dependency) async {
    final gameId = store.state.connectFourGameScreenState?.room.details.gameId;
    final api = dependency.gameSocketClient.clientApi;
    api.gameMove(gameId, move);
  };
}

ThunkActionWithExtraArgument<AppState, AppDependency>
    middlewareConnectFourGameOver(
  ConnectFourGameBoard board,
  ConnectFourGamePlayer? winner,
) {
  return (store, dependency) async {
    final field = board.gameField;
    store.dispatch(ConnectFourGameReplaceFieldAction(field));
    final room = store.state.connectFourGameScreenState?.room;
    store.dispatch(middlewareWriteGameLog(
      room?.copyWith(board: board),
      winner,
      GameLogState.over,
    ));
  };
}
