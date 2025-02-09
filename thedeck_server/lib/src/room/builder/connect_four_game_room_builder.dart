/*
 *
 *  *
 *  * Created on 20 5 2023
 *  
 */

import 'dart:math';

import 'package:thedeck_common/the_deck_common.dart';

import 'game_room_builder.dart';

class ConnectFourGameRoomBuilder
    extends GameRoomBuilder<GameRoom<ConnectFourGameBoard>> {
  ConnectFourGameRoomBuilder(GameDetails gameDetails, bool hostIsTheDeck)
      : super(gameDetails, hostIsTheDeck);

  @override
  bool isReady([List<GameParticipant>? newParticipants]) {
    if (newParticipants != null) {
      return newParticipants.length == 2;
    }
    return participants.length == 2;
  }

  @override
  GameRoom<ConnectFourGameBoard>? start() {
    final List<GameParticipant> newParticipants = List.from(participants);
    if (!isReady(newParticipants)) {
      return null;
    }
    final field = ConnectFourGameField();
    final random = Random();
    final isYellow = random.nextBool();
    final players = [
      ConnectFourGamePlayer.fromParticipant(newParticipants[0], isYellow),
      ConnectFourGamePlayer.fromParticipant(newParticipants[1], !isYellow)
    ];
    final bord = ConnectFourGameBoard(gameField: field, players: players);
    final room = GameRoom<ConnectFourGameBoard>.start(
        roomId: roomId, details: gameDetails, board: bord);
    for (final participant in newParticipants) {
      if (!room.join(participant)) {
        return null;
      }
    }
    return room;
  }
}
