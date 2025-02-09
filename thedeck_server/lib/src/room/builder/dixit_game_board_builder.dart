/*
 *
 *  *
 *  * Created on 20 5 2023
 *
 */


import 'package:thedeck_common/the_deck_common.dart';

import 'game_room_builder.dart';

class DixitGameRoomBuilder extends GameRoomBuilder<GameRoom<DixitGameBoard>> {
  DixitGameRoomBuilder(GameDetails gameDetails, bool hostIsTheDeck)
      : super(gameDetails, hostIsTheDeck);

  @override
  bool isReady() {
    return participants.length >= _Constants.minPlayersCount;
  }

  @override
  GameRoom<DixitGameBoard>? start() {
    final List<GameParticipant> newParticipants = List.from(participants);
    if (!isReady()) {
      return null;
    }
    final List<DixitGamePlayer> players =
        participants.map((e) => DixitGamePlayer(e.userId)).toList();
    final field = DixitGameField.newField(players);
    final board = DixitGameBoard(gameField: field, players: players);
    final room = GameRoom<DixitGameBoard>.start(
        roomId: roomId, details: gameDetails, board: board);
    for (final participant in newParticipants) {
      if (!room.join(participant)) {
        return null;
      }
    }
    return room;
  }
}

mixin _Constants {
  static const minPlayersCount = 3;
}
