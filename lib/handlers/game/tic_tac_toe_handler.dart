/*
 *
 *  *
 *  * Created on 27 5 2023
 *
 */

import 'package:thedeck_client/the_deck_client.dart';
import 'package:thedeck_common/the_deck_common.dart';

import '../../redux/actions/game/redux_actions_tic_tac_toe_game.dart';
import '../../redux/middleware/games/tic_tac_toe/redux_middleware_tic_tac_toe_game_client.dart';

class TicTacToeHandler extends TicTacToeClientHandler {
  final Function _dispatcher;

  TicTacToeHandler(this._dispatcher);

  @override
  void gameOver(TicTacToeGameBoard board, TicTacToeGamePlayer? winner) {
    _dispatcher(middlewareTicTacToeGameOver(board, winner));
  }

  @override
  void updateField(TicTacToeGameField field) {
    _dispatcher(TicTacToeGameReplaceFieldAction(field));
  }

  @override
  void newRoom(GameRoom<TicTacToeGameBoard> room) {
    _dispatcher(middlewareTicTacToeNewRoom(room));
  }

  @override
  void updateRoom(GameRoom<TicTacToeGameBoard> room) {
    _dispatcher(TicTacToeUpdateRoomAction(null, room));
  }
}
