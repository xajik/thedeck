/*
 *
 *  *
 *  * Created on 19 3 2023
 *
 */

import 'package:thedeck_common/the_deck_common.dart';

class DixitGameReplaceFieldAction {
  final DixitGameField field;

  DixitGameReplaceFieldAction(this.field);
}

class DixitGameChangeCardIndexAction {
  final int index;

  DixitGameChangeCardIndexAction(this.index);
}

class DixitNewRoomAction {
  final String? userId;
  final GameRoom<DixitGameBoard> room;

  DixitNewRoomAction(this.userId, this.room);
}
