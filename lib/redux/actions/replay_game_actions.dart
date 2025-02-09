/*
 *
 *  *
 *  * Created on 24 6 2023
 *
 */

import 'package:the_deck/di/db/entity/game_log_entity.dart';

class ReplayGameLoadAction {
  final GameLogEntity gameLogEntity;

  ReplayGameLoadAction(this.gameLogEntity);
}

class ReplayProgressUpdateAction {
  final int totalMoves;
  final int movesLeft;

  ReplayProgressUpdateAction(this.totalMoves, this.movesLeft);
}

class ReplayGameClearAction {
  ReplayGameClearAction();
}
