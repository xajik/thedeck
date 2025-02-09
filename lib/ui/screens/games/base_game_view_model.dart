/*
 *
 *  *
 *  * Created on 9 5 2023
 *
 */

import 'package:redux/redux.dart';

import '../../../redux/app_state.dart';
import '../../../redux/middleware/games/reduxt_middleware_game.dart';

abstract class BaseGameViewModel {
  final Function() disposeGame;
  final Function() showLeaveGameDialog;

  bool get isGameOver;

  BaseGameViewModel(Store<AppState> store)
      : disposeGame =
            (() => store.dispatch(middlewareDisposeServerAndClient())),
        showLeaveGameDialog =
            (() => store.dispatch(middlewareShowLeaveGameDialog()));
}
