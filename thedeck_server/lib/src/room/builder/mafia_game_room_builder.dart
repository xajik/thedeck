/*
 *
 *  *
 *  * Created on 28 7 2023
 *  
 */

import 'package:thedeck_common/the_deck_common.dart';

import 'game_room_builder.dart';

class MafiaGameRoomBuilder extends GameRoomBuilder<GameRoom<MafiaGameBoard>> {
  MafiaGameRoomBuilder(bool hostIsTheDeck)
      : super(GamesList.mafia.details, hostIsTheDeck);

  @override
  bool isReady([List<GameParticipant>? newParticipants]) {
    final length =
        newParticipants != null ? newParticipants.length : participants.length;
    return length >= MafiaConst.minParticipants &&
        length <= MafiaConst.maxParticipants;
  }

  @override
  GameRoom<MafiaGameBoard>? start() {
    final List<GameParticipant> newParticipants = List.from(participants);
    if (!isReady(newParticipants)) {
      return null;
    }
    newParticipants.shuffle();
    final roles = _roles(newParticipants.length)..shuffle();
    final players =
        List<MafiaGamePlayer>.generate(newParticipants.length, (index) {
      final role = roles.isEmpty ? MafiaPlayerRole.citizen : roles.removeLast();
      return MafiaGamePlayer.fromParticipant(newParticipants[index], role);
    });
    final field = MafiaGameField.newField(players);
    final bord = MafiaGameBoard(field, players);
    final room = GameRoom<MafiaGameBoard>.start(
      roomId: roomId,
      details: gameDetails,
      board: bord,
    );
    for (final participant in newParticipants) {
      if (!room.join(participant)) {
        return null;
      }
    }
    return room;
  }

  List<MafiaPlayerRole> _roles(int playersCount) {
    if (playersCount <= MafiaConst.minParticipants) {
      return [MafiaPlayerRole.mafia, MafiaPlayerRole.detective];
    }
    if (playersCount >= MafiaConst.minParticipantsWithDoctor &&
        playersCount < MafiaConst.minParticipantsAllPlayers) {
      return [
        MafiaPlayerRole.mafia,
        MafiaPlayerRole.detective,
        MafiaPlayerRole.doctor
      ];
    }
    final nightRoles = MafiaPlayerRole.values
        .where((element) => element != MafiaPlayerRole.citizen);
    final roles = List<MafiaPlayerRole>.from(nightRoles);
    //Mafia is always 30% of the players
    final mafiaCount = (playersCount * MafiaConst.mafiaProportion).round();
    roles.addAll(
      List.generate(
        mafiaCount - 1,
        (index) => MafiaPlayerRole.mafia,
      ),
    );
    return roles;
  }
}

mixin MafiaConst {
  static const int minParticipants = 4;
  static const int minParticipantsWithDoctor = 5;
  static const int minParticipantsAllPlayers = 7;
  static const int maxParticipants = 15;
  static const double mafiaProportion = 0.3;
}
