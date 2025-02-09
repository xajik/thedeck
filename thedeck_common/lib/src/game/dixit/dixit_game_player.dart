/*
 *
 *  *
 *  * Created on 3 4 2023
 *
 */

import '../game_board.dart';

class DixitGamePlayer extends GamePlayer {
  DixitGamePlayer(String userId) : super(userId);

  factory DixitGamePlayer.fromMap(Map<String, dynamic> map) {
    return DixitGamePlayer(
      map['userId'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
    };
  }
}
