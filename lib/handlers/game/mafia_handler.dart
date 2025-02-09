/*
 *
 *  *
 *  * Created on 28 7 2023
 *  
 */

import 'package:thedeck_client/the_deck_client.dart';
import 'package:thedeck_common/the_deck_common.dart';
import '../../redux/actions/game/redux_actions_mafia_game.dart';
import '../../redux/middleware/games/mafia/redux_middleware_mafia_game_client.dart';

class MafiaHandler extends MafiaClientHandler {
  final Function _dispatcher;

  MafiaHandler(this._dispatcher);

  @override
  void gameOver(MafiaGameBoard board, MafiaGamePlayer? winner) {
    _dispatcher(middlewareMafiaGameOver(board, winner));
  }

  @override
  void updateField(MafiaGameField field) {
    _dispatcher(MafiaGameReplaceFieldAction(field));
  }

  @override
  void newRoom(GameRoom<MafiaGameBoard> room) {
    _dispatcher(middlewareMafiaNewRoom(room));
  }

  @override
  void updateRoom(GameRoom<MafiaGameBoard> room) {
    _dispatcher(MafiaGameReplaceRoomAction(null, room));
  }
}
