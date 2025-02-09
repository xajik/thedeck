/*
 *
 *  *
 *  * Created on 23 3 2023
 *
 */

import 'package:redux_thunk/redux_thunk.dart';
import 'package:the_deck/redux/middleware/redux_middleware_routing.dart';
import 'package:the_deck/ui/screens/games/dixit/dixit_map_screen_widget.dart';
import 'package:the_deck/ui/screens/games/dixit/dixit_screen_view_model.dart';
import 'package:the_deck/ui/widgets/full_screen_image.dart';
import 'package:thedeck_common/the_deck_common.dart';

import '../../../../di/app_dependency.dart';
import '../../../../di/db/entity/game_log_entity.dart';
import '../../../../ui/screens/games/dixit/dixit_leaderboard_screen_widget.dart';
import '../../../actions/game/redux_actions_dixit_game.dart';
import '../../../app_state.dart';
import '../reduxt_middleware_game.dart';

ThunkActionWithExtraArgument<AppState, AppDependency> middlewareDixitNewRoom(
    GameRoom<DixitGameBoard> room) {
  return (store, dependency) async {
    final localKey = store.state.userState.user!.getKey();
    final isPlayer =
        room.participants.any((element) => element.userId == localKey);
    store.dispatch(DixitNewRoomAction(isPlayer ? localKey : null, room));
    store.dispatch(middlewareRouteDixitGame());
    store.dispatch(middlewareWriteGameLog(room, null, GameLogState.started));
  };
}

ThunkActionWithExtraArgument<AppState, AppDependency> middlewareDixitClientMove(
    DixitGameMove move) {
  return (store, dependency) async {
    final gameId = store.state.dixitGameScreenState?.room.details.gameId;
    final api = dependency.gameSocketClient.clientApi;
    api.gameMove(gameId, move);
  };
}

ThunkActionWithExtraArgument<AppState, AppDependency>
    middlewareDixitLeaderboard(DixitScreenViewModel vm) {
  return (store, dependency) async {
    final args = {
      DixitLeaderboardDialogWidget.vmKey: vm,
    };
    dependency.router.dixitGameLeaderboard(args);
  };
}

ThunkActionWithExtraArgument<AppState, AppDependency>
    middlewareDixitCardPreview(
  String imageUrl,
  String fallbackAsset,
) {
  return (store, dependency) async {
    final args = {
      FullScreenImageWidget.imageUrlKey: imageUrl,
      FullScreenImageWidget.fallbackAssetKey: fallbackAsset,
    };
    dependency.router.fullScreenImage(args);
  };
}

ThunkActionWithExtraArgument<AppState, AppDependency> middlewareDixitMap(
    DixitScreenViewModel vm) {
  return (store, dependency) async {
    final args = {
      DixitMapDialogWidget.vmKey: vm,
    };
    dependency.router.dixitGameMap(args);
  };
}

ThunkActionWithExtraArgument<AppState, AppDependency> middlewareDixitGameOver(
  DixitGameBoard board,
  DixitGamePlayer? winner,
) {
  return (store, dependency) async {
    final field = board.gameField;
    store.dispatch(DixitGameReplaceFieldAction(field));
    final room = store.state.dixitGameScreenState?.room;
    store.dispatch(middlewareWriteGameLog(
      room?.copyWith(board: board),
      winner,
      GameLogState.over,
    ));
  };
}
