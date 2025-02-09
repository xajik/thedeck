/*
 *
 *  *
 *  * Created on 27 5 2023
 *
 */

import 'package:thedeck_client/the_deck_client.dart';
import 'package:thedeck_common/the_deck_common.dart';

import '../../redux/actions/game/redux_actions_dixit_game.dart';
import '../../redux/middleware/games/dixit/redux_middleware_dixit_game_client.dart';

class DixitHandler extends DixitClientHandler {
  final Function _dispatcher;

  DixitHandler(this._dispatcher);

  @override
  void gameOver(DixitGameBoard board, DixitGamePlayer? winner) {
    _dispatcher(middlewareDixitGameOver(board, winner));
  }

  @override
  void updateField(DixitGameField field) {
    _dispatcher(DixitGameReplaceFieldAction(field));
  }

  @override
  void newRoom(GameRoom<DixitGameBoard> room) {
    _dispatcher(middlewareDixitNewRoom(room));
  }

  @override
  void updateRoom(GameRoom<DixitGameBoard> room) {
    _dispatcher(DixitNewRoomAction(null, room));
  }
}
