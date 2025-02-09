/*
 *
 *  *
 *  * Created on 23 4 2023
 *
 */

import 'package:redux/redux.dart';

import '../../../redux/app_state.dart';
import '../../../redux/middleware/games/reduxt_middleware_game.dart';

class LeaveGameConfirmationViewModel {
  final Function() leaveGame;

  LeaveGameConfirmationViewModel._(this.leaveGame);

  factory LeaveGameConfirmationViewModel.fromStore(Store<AppState> store) {
    leaveGame() {
      store.dispatch(middlewareLeaveGame());
    }

    return LeaveGameConfirmationViewModel._(
      leaveGame,
    );
  }
}
