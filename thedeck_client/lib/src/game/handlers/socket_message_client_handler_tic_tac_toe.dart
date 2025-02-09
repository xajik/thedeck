/*
 *
 *  *
 *  * Created on 1 4 2023
 *
 */

import 'dart:async';

import 'package:thedeck_common/the_deck_common.dart';

import '../../../the_deck_client.dart';

List<StreamSubscription> ticTacToeClientMessageHandlers(
  SocketMessageStream stream,
  gameId,
  GameClientHandler dispatcher,
) {
  final subs = <StreamSubscription>[];

  subs.add(
    stream.subscribeWhere(ApiConstantsSocketPath.room(gameId),
        ((Map<String, dynamic> map) {
      var data =
          map[ApiConstantsSocketPayload.data][ApiConstantsSocketPayload.room];
      final board =
          TicTacToeGameBoard.fromMap(data[ApiConstantsSocketPayload.board]);
      final room = GameRoom<TicTacToeGameBoard>.fromMap(data, board);
      dispatcher.newRoom(room);
    })),
  );

  subs.add(
    stream.subscribeWhere(ApiConstantsSocketPath.field(gameId),
        ((Map<String, dynamic> map) {
      final field =
          TicTacToeGameField.fromMap(map[ApiConstantsSocketPayload.data]);
      dispatcher.updateField(field);
    })),
  );

  subs.add(
    stream.subscribeWhere(ApiConstantsSocketPath.gameOver(gameId),
        ((Map<String, dynamic> map) {
      var data = map[ApiConstantsSocketPayload.data];
      final board =
          TicTacToeGameBoard.fromMap(data[ApiConstantsSocketPayload.board]);
      final winnerData = data[ApiConstantsSocketPayload.winner];
      TicTacToeGamePlayer? winner;
      if (winnerData != null) {
        winner = TicTacToeGamePlayer.fromMap(winnerData);
      }
      dispatcher.gameOver(board, winner);
    })),
  );
  return subs;
}
