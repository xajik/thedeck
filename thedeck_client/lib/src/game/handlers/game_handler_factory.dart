/*
 *
 *  *
 *  * Created on 25 6 2023
 *
 */

import 'dart:async';

import 'package:thedeck_common/the_deck_common.dart';

import '../../../the_deck_client.dart';
import 'socket_message_client_handler_connect_four.dart';
import 'socket_message_client_handler_dixit.dart';
import 'socket_message_client_handler_mafia.dart';
import 'socket_message_client_handler_tic_tac_toe.dart';

List<StreamSubscription> gameClientMessageListener(
  int gameId,
  GameClientHandler handler,
  SocketMessageStream socketMessageStream,
) {
  if (GamesList.ticTacToe.id == gameId) {
    return ticTacToeClientMessageHandlers(
      socketMessageStream,
      gameId,
      handler,
    );
  }

  if (GamesList.connectFour.id == gameId) {
    return connectFourClientMessageHandlers(
      socketMessageStream,
      gameId,
      handler,
    );
  }

  if (GamesList.dixit.id == gameId) {
    return dixitClientMessageHandlers(
      socketMessageStream,
      gameId,
      handler,
    );
  }

  if (GamesList.mafia.id == gameId) {
    return mafiaClientMessageHandlers(
      socketMessageStream,
      gameId,
      handler,
    );
  }

  return [];
}
