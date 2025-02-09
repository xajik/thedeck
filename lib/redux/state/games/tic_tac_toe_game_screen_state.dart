/*
 *
 *  *
 *  * Created on 19 3 2023
 *
 */

import 'package:thedeck_common/the_deck_common.dart';

import 'base_game_screen_state.dart';

class TicTacToeGameScreenState extends BaseGameScreenState<TicTacToeGameBoard> {
  TicTacToeGameBoard get board => room.board;

  TicTacToeGameScreenState(String? userId, GameRoom<TicTacToeGameBoard> room)
      : super(userId, room);

  TicTacToeGameScreenState copyWith({TicTacToeGameBoard? board}) {
    return TicTacToeGameScreenState(
      userId,
      room.copyWith(board: board),
    );
  }
}
