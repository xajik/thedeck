/*
 *
 *  *
 *  * Created on 19 3 2023
 *
 */

import 'package:thedeck_common/the_deck_common.dart';

import 'base_game_screen_state.dart';

class ConnectFourGameScreenState
    extends BaseGameScreenState<ConnectFourGameBoard> {
  ConnectFourGameBoard get board => room.board;

  ConnectFourGameScreenState(
      String? userId, GameRoom<ConnectFourGameBoard> room)
      : super(userId, room);

  ConnectFourGameScreenState copyWith({GameRoom<ConnectFourGameBoard>? room}) {
    return ConnectFourGameScreenState(
      userId,
      room ?? this.room,
    );
  }
}
