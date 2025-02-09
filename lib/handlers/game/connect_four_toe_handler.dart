/*
 *
 *  *
 *  * Created on 27 5 2023
 *
 */

import 'package:thedeck_client/the_deck_client.dart';
import 'package:thedeck_common/the_deck_common.dart';

import '../../redux/actions/game/redux_actions_connect_four_game.dart';
import '../../redux/middleware/games/connect_four/redux_middleware_connect_four_game_client.dart';

class ConnectFourHandler extends ConnectFourClientHandler {
  final Function _dispatcher;

  ConnectFourHandler(this._dispatcher);

  @override
  void gameOver(ConnectFourGameBoard board, ConnectFourGamePlayer? winner) {
    _dispatcher(middlewareConnectFourGameOver(board, winner));
  }

  @override
  void updateField(ConnectFourGameField field) {
    _dispatcher(ConnectFourGameReplaceFieldAction(field));
  }

  @override
  void newRoom(GameRoom<ConnectFourGameBoard> room) {
    _dispatcher(middlewareConnectFourNewRoom(room));
  }

  @override
  void updateRoom(GameRoom<ConnectFourGameBoard> room) {
    _dispatcher(ConnectFourGameReplaceRoomAction(null, room));
  }
}
