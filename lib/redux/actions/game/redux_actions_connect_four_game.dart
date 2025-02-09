/*
 *
 *  *
 *  * Created on 19 3 2023
 *
 */

import 'package:thedeck_common/the_deck_common.dart';

class ConnectFourGameRoomAction {
  final String? userId;
  final GameRoom<ConnectFourGameBoard> room;

  ConnectFourGameRoomAction(this.userId, this.room);
}

class ConnectFourGameReplaceFieldAction {
  final ConnectFourGameField field;

  ConnectFourGameReplaceFieldAction(this.field);
}

class ConnectFourGameReplaceRoomAction {
  final String? userId;
  final GameRoom<ConnectFourGameBoard> room;

  ConnectFourGameReplaceRoomAction(this.userId, this.room);
}
