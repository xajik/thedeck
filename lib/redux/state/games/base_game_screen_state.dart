/*
 *
 *  *
 *  * Created on 27 7 2023
 *
 */

import 'package:thedeck_common/the_deck_common.dart';

abstract class BaseGameScreenState<T extends GameBoard> {
  //User ID is null if it is a Deck only
  final String? userId;
  final GameRoom<T> room;

  BaseGameScreenState(this.userId, this.room);
}
