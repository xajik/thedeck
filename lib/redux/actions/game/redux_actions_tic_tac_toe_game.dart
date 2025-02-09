/*
 *
 *  *
 *  * Created on 19 3 2023
 *
 */

import 'package:thedeck_common/the_deck_common.dart';

class TicTacToeGameReplaceFieldAction {
  final TicTacToeGameField field;

  TicTacToeGameReplaceFieldAction(this.field);
}

class TicTacToeUpdateRoomAction {
  final String? userId;
  final GameRoom<TicTacToeGameBoard> room;

  TicTacToeUpdateRoomAction(this.userId, this.room);
}
