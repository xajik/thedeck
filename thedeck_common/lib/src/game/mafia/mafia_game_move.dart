/*
 *
 *  *
 *  * Created on 28 7 2023
 *
 */

import '../../../the_deck_common.dart';
import 'mafia_game_roles.dart';

class MafiaGameMove extends GameMove {
  final String targetUserId;
  final MafiaPlayerAbility? ability;

  MafiaGameMove(String userId, this.targetUserId, this.ability) : super(userId);

  MafiaGameMove.any(String userId)
      : this.targetUserId = userId,
        this.ability = null,
        super(userId);

  MafiaGameMove.vote(String userId, this.targetUserId)
      : this.ability = null,
        super(userId);

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'targetUserId': targetUserId,
      'ability': ability?.name,
    };
  }

  factory MafiaGameMove.fromMap(Map<String, dynamic> json) {
    return MafiaGameMove(
      json['userId'],
      json['targetUserId'],
      MafiaPlayerAbility.fromName(json['ability']),
    );
  }
}
