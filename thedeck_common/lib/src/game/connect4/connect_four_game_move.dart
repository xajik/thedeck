/*
 *
 *  *
 *  * Created on 1 4 2023
 *
 */

import '../game_board.dart';

class ConnectFourGameMove extends GameMove {
  final int col;

  ConnectFourGameMove(String userId, this.col) : super(userId);

  @override
  Map<String, dynamic> toMap() {
    return {
      ...super.toMap(),
      'col': col,
    };
  }

  factory ConnectFourGameMove.fromMap(Map<String, dynamic> map) {
    return ConnectFourGameMove(map['userId'], map['col']);
  }
}
