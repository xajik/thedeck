/*
 *
 *  *
 *  * Created on 27 5 2023
 *
 */

import 'dart:async';

import 'package:thedeck_common/the_deck_common.dart';

import '../game_handler_interface.dart';

List<StreamSubscription> connectFourClientMessageHandlers(
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
          ConnectFourGameBoard.fromMap(data[ApiConstantsSocketPayload.board]);
      final room = GameRoom<ConnectFourGameBoard>.fromMap(data, board);
      dispatcher.newRoom(room);
    })),
  );

  subs.add(
    stream.subscribeWhere(ApiConstantsSocketPath.field(gameId),
        ((Map<String, dynamic> map) {
      final field =
          ConnectFourGameField.fromMap(map[ApiConstantsSocketPayload.data]);
      dispatcher.updateField(field);
    })),
  );

  subs.add(
    stream.subscribeWhere(ApiConstantsSocketPath.gameOver(gameId),
        ((Map<String, dynamic> map) {
      var data = map[ApiConstantsSocketPayload.data];
      final board =
          ConnectFourGameBoard.fromMap(data[ApiConstantsSocketPayload.board]);
      final winnerData = data[ApiConstantsSocketPayload.winner];
      ConnectFourGamePlayer? winner;
      if (winnerData != null) {
        winner = ConnectFourGamePlayer.fromMap(winnerData);
      }
      dispatcher.gameOver(board, winner);
    })),
  );
  return subs;
}
