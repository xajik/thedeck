/*
 *
 *  *
 *  * Created on 1 4 2023
 *
 */
import 'package:redux/redux.dart';
import 'package:the_deck/redux/middleware/games/connect_four/redux_middleware_connect_four_game_client.dart';
import 'package:the_deck/ui/screens/games/base_game_view_model.dart';
import 'package:thedeck_common/the_deck_common.dart';

import '../../../../redux/app_state.dart';

class ConnectFourViewModel extends BaseGameViewModel {
  final ConnectFourGameField? gameField;
  final String? userId;
  final Function(int) makeTurn;

  @override
  get isGameOver => gameField?.isGameOver ?? false;

  ConnectFourViewModel(
    this.gameField,
    this.userId,
    this.makeTurn,
    Store<AppState> store,
  ) : super(store);

  factory ConnectFourViewModel.create(Store<AppState> store) {
    final screenState = store.state.connectFourGameScreenState;
    final state = screenState?.board.gameField;
    final userId = screenState?.userId;
    makeTurn(int i) {
      if (userId != null) {
        final move = ConnectFourGameMove(userId, i);
        store.dispatch(middlewareConnectFourClientMove(move));
      }
    }

    return ConnectFourViewModel(
      state,
      userId,
      makeTurn,
      store,
    );
  }
}
