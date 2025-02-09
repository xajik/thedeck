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

import '../../../../redux/app_state.dart';
import '../../../../redux/middleware/redux_middleware_game_replay.dart';
import '../../../../redux/middleware/redux_middleware_routing.dart';

class ReplayListViewModel {
  final Function loadReplayList;
  final List<GameLogEntity> replayList;
  final Function([Map<String, dynamic> args]) replayGameScreen;

  ReplayListViewModel(
    this.replayList,
    this.loadReplayList,
    this.replayGameScreen,
  );

  factory ReplayListViewModel.create(Store<AppState> store) {
    final reply = store.state.homeScreenState.replayGames;
    loadReplayList() {
      store.dispatch(middlewareLoadGameReplayList());
    }

    replayGameScreen([Map<String, dynamic> args = const {}]) {
      store.dispatch(middlewareRouteReplayGame(args));
    }

    return ReplayListViewModel(
      reply,
      loadReplayList,
      replayGameScreen,
    );
  }
}
