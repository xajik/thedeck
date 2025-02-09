/*
 *
 *  *
 *  * Created on 20 5 2023
 *
 */

import 'dart:math';

import 'package:thedeck_common/the_deck_common.dart';

import 'game_room_builder.dart';

class TicTacToeGameRoomBuilder
    extends GameRoomBuilder<GameRoom<TicTacToeGameBoard>> {
  TicTacToeGameRoomBuilder(GameDetails gameDetails, bool hostIsTheDeck)
      : super(gameDetails, hostIsTheDeck);

  @override
  bool isReady([List<GameParticipant>? newParticipants]) {
    if (newParticipants != null) {
      return newParticipants.length == 2;
    }
    return participants.length == 2;
  }

  @override
  GameRoom<TicTacToeGameBoard>? start() {
    final List<GameParticipant> newParticipants = List.from(participants);
    if (!isReady(newParticipants)) {
      return null;
    }
    final field = TicTacToeGameField();
    final random = Random();
    final cross = random.nextBool();
    final players = [
      TicTacToeGamePlayer.fromParticipant(newParticipants[0], cross),
      TicTacToeGamePlayer.fromParticipant(newParticipants[1], !cross)
    ];
    final bord = TicTacToeGameBoard(field, players);
    final room = GameRoom<TicTacToeGameBoard>.start(
        roomId: roomId, details: gameDetails, board: bord);
    for (final participant in newParticipants) {
      if (!room.join(participant)) {
        return null;
      }
    }
    return room;
  }
}