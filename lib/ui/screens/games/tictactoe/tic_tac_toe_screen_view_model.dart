/*
 *
 *  *
 *  * Created on 11 3 2023
 *
 */

import 'package:redux/redux.dart';
import 'package:thedeck_common/the_deck_common.dart';

import '../../../../redux/app_state.dart';
import '../../../../redux/middleware/games/tic_tac_toe/redux_middleware_tic_tac_toe_game_client.dart';
import '../base_game_view_model.dart';

class TicTacToeScreenViewModel extends BaseGameViewModel {
  final TicTacToeGameField? gameField;
  final String? userId;
  final Function(int, int) makeTurn;

  @override
  bool get isGameOver => gameField?.isGameOver ?? false;

  TicTacToeScreenViewModel(
    this.gameField,
    this.userId,
    this.makeTurn,
    Store<AppState> store,
  ) : super(store);

  factory TicTacToeScreenViewModel.create(Store<AppState> store) {
    var state = store.state.ticTacToeGameScreenState;
    var gameField = state?.board.gameField;
    var userId = state?.userId;
    makeTurn(int i, int j) {
      if (userId != null) {
        var move = TicTacToeGameMove(userId, Pair.of(i, j));
        store.dispatch(middlewareTicTacToeClientMove(move));
      }
    }

    return TicTacToeScreenViewModel(
      gameField,
      userId,
      makeTurn,
      store,
    );
  }
}
