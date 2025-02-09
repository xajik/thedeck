/*
 *
 *  *
 *  * Created on 24 6 2023
 *
 */

import 'package:the_deck/di/db/entity/game_log_entity.dart';

class ReplayGameState {
  final GameLogEntity? gameLogEntity;
  final int totalMoves;
  final int movesLeft;

  ReplayGameState(this.gameLogEntity, this.totalMoves, this.movesLeft);

  ReplayGameState.empty()
      : gameLogEntity = null,
        totalMoves = 0,
        movesLeft = 0;

  ReplayGameState copyWith({
    GameLogEntity? gameLogEntity,
    int? totalMoves,
    int? movesLeft,
  }) {
    return ReplayGameState(
      gameLogEntity ?? this.gameLogEntity,
      totalMoves ?? this.totalMoves,
      movesLeft ?? this.movesLeft,
    );
  }
}
