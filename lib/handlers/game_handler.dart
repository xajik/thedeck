/*
 *
 *  *
 *  * Created on 27 5 2023
 *
 */

import 'package:thedeck_client/the_deck_client.dart';
import 'package:thedeck_common/the_deck_common.dart';

import 'game/connect_four_toe_handler.dart';
import 'game/dixit_handlers.dart';
import 'game/tic_tac_toe_handler.dart';
import 'game/mafia_handler.dart';

GameClientHandler? gameHandlerFactory(int gameId, Function dispatcher) {
  if (GamesList.ticTacToe.id == gameId) {
    return TicTacToeHandler(dispatcher);
  }
  if (GamesList.connectFour.id == gameId) {
    return ConnectFourHandler(dispatcher);
  }
  if (GamesList.dixit.id == gameId) {
    return DixitHandler(dispatcher);
  }
  if (GamesList.mafia.id == gameId) {
    return MafiaHandler(dispatcher);
  }
  return null;
}
