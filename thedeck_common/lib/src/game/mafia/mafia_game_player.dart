/*
 *
 *  *
 *  * Created on 28 7 2023
 *
 */

import '../../../the_deck_common.dart';
import 'mafia_game_roles.dart';

class MafiaGamePlayer extends GamePlayer {
  final MafiaPlayerRole role;

  MafiaGamePlayer(String userId, this.role) : super(userId);

  MafiaGamePlayer.fromParticipant(GameParticipant participant, this.role)
      : super(participant.userId);

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'role': role.name,
    };
  }

  factory MafiaGamePlayer.fromMap(Map<String, dynamic> map) {
    return MafiaGamePlayer(
      map['userId'],
      MafiaPlayerRole.fromName(map['role']),
    );
  }
}
