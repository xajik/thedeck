/*
 *
 *  *
 *  * Created on 1 4 2023
 *
 */

import '../game_board.dart';
import '../game_participant.dart';

class ConnectFourGamePlayer extends GamePlayer {
  final bool isYellow;

  ConnectFourGamePlayer(String userId, this.isYellow) : super(userId);

  ConnectFourGamePlayer.fromParticipant(
      GameParticipant participant, this.isYellow)
      : super(participant.userId);

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'isYellow': isYellow,
    };
  }

  factory ConnectFourGamePlayer.fromMap(Map<String, dynamic> map) {
    return ConnectFourGamePlayer(
      map['userId'],
      map['isYellow'],
    );
  }
}
