/*
 *
 *  *
 *  * Created on 20 5 2023
 *
 */

import 'package:thedeck_common/the_deck_common.dart';
import 'package:ulid/ulid.dart';

import 'connect_four_game_room_builder.dart';
import 'dixit_game_board_builder.dart';
import 'mafia_game_room_builder.dart';
import 'tic_tac_toe_game_room_builder.dart';

abstract class GameRoomBuilder<T extends GameRoom> {
  final String roomId = Ulid().toUuid();
  final GameDetails gameDetails;
  final bool hostIsTheDeck;

  final List<GameParticipant> _participants = List.empty(growable: true);

  List<GameParticipant> get participants {
    return _participants;
  }

  GameRoomBuilder(this.gameDetails, this.hostIsTheDeck);

  bool isParticipant(GameParticipant participant) {
    return _participants.any((e) => e.userId == participant.userId);
  }

  bool addParticipant(GameParticipant participant) {
    if (isParticipant(participant)) {
      return false;
    }
    _participants.add(participant);
    return true;
  }

  removeParticipant(String userId) {
    _participants.removeWhere((e) => e.userId == userId);
  }

  bool isReady();

  T? start();

  static GameRoomBuilder fromDetails(GameDetails details, bool hostIsTheDeck) {
    if (GamesList.ticTacToe.id == details.gameId) {
      return TicTacToeGameRoomBuilder(details, hostIsTheDeck);
    }
    if (GamesList.connectFour.id == details.gameId) {
      return ConnectFourGameRoomBuilder(details, hostIsTheDeck);
    }

    if (GamesList.dixit.id == details.gameId) {
      return DixitGameRoomBuilder(details, hostIsTheDeck);
    }

    if (GamesList.mafia.id == details.gameId) {
      return MafiaGameRoomBuilder(hostIsTheDeck);
    }

    throw Exception('Unknown game id: ${details.gameId}');
  }
}
