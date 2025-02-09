/*
 *
 *  *
 *  * Created on 28 7 2023
 *  
 */

import 'package:thedeck_common/the_deck_common.dart';

class MafiaGameRoomAction {
  final String? userId;
  final GameRoom<MafiaGameBoard> room;

  MafiaGameRoomAction(this.userId, this.room);
}

class MafiaGameReplaceFieldAction {
  final MafiaGameField field;

  MafiaGameReplaceFieldAction(this.field);
}

class MafiaGameReplaceRoomAction {
  final String? userId;
  final GameRoom<MafiaGameBoard> room;

  MafiaGameReplaceRoomAction(this.userId, this.room);
}

class MafiaGameToggleShowRoleAction {
  final bool isVisible;

  MafiaGameToggleShowRoleAction(this.isVisible);
}

class MafiaGameSelectedPlayerAction {
  final int? index;

  MafiaGameSelectedPlayerAction(this.index);
}
