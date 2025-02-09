/*
 *
 * Copyright (c) 2023 TheDeck.com - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited 
 * Proprietary and confidential 
 *
 * Created on 2023-06-23 
 */

import 'package:redux/redux.dart';
import 'package:the_deck/di/db/entity/game_log_entity.dart';

import '../../../../redux/actions/replay_game_actions.dart';
import '../../../../redux/app_state.dart';
import '../../../../redux/middleware/redux_middleware_game_replay.dart';

class ReplyGameScreeViewModel {
  final GameLogEntity? gameLogEntity;
  final Function(int) loadGameLog;
  final Function() stopReplay;
  final Function() onWillPop;
  final int totalMoves;
  final int progress;

  ReplyGameScreeViewModel(
    this.loadGameLog,
    this.gameLogEntity,
    this.stopReplay,
    this.onWillPop,
    this.totalMoves,
    this.progress,
  );

  factory ReplyGameScreeViewModel.create(Store<AppState> store) {
    final gameLogEntity = store.state.replayGameState.gameLogEntity;

    loadGameLog(int gameId) {
      store.dispatch(middlewareLoadGameReplay(gameId));
    }

    onWillPop() {
      store.dispatch(ReplayGameClearAction());
    }

    stopReplay() {
      store.dispatch(middlewareStopReplay());
    }

    final totalMoves = store.state.replayGameState.totalMoves;
    final progress = totalMoves - store.state.replayGameState.movesLeft;

    return ReplyGameScreeViewModel(
      loadGameLog,
      gameLogEntity,
      stopReplay,
      onWillPop,
      totalMoves,
      progress,
    );
  }
}
