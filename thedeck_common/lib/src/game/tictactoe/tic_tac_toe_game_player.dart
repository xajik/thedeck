/*
 *
 *  *
 *  * Created on 12 2 2023
 *
 */

import '../game_participant.dart';
import '../game_board.dart';

class TicTacToeGamePlayer extends GamePlayer {
  final bool isCross;

  TicTacToeGamePlayer(String userId, this.isCross) : super(userId);

  TicTacToeGamePlayer.fromParticipant(GameParticipant participant, this.isCross)
      : super(participant.userId);

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      ...{
        'isCross': isCross,
      }
    };
  }

  factory TicTacToeGamePlayer.fromMap(Map<String, dynamic> map) {
    return TicTacToeGamePlayer(
      map['userId'],
      map['isCross'],
    );
  }
}
