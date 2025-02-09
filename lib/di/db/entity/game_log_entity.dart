/*
 *
 *  *
 *  * Created on 4 5 2023
 *
 */

import 'package:objectbox/objectbox.dart';

@Entity()
class GameLogEntity {
  @Id()
  int id = 0;
  @Unique()
  String roomId;
  int gameId;
  String address;
  String gameState;
  String? winnerUserId;
  String? logPath;
  @Property(type: PropertyType.date)
  DateTime updated;

  GameLogEntity({
    required this.roomId,
    required this.gameId,
    required this.address,
    required this.gameState,
    required this.winnerUserId,
    this.logPath,
    required this.updated,
  });

  factory GameLogEntity.create({
    required String roomId,
    required int gameId,
    required String address,
    GameLogState gameState = GameLogState.created,
    String? winnerUserId,
    String? logPath,
  }) {
    return GameLogEntity(
      roomId: roomId,
      gameId: gameId,
      address: address,
      gameState: gameState.name,
      winnerUserId: winnerUserId,
      logPath: logPath,
      updated: DateTime.now(),
    );
  }

  GameLogState getGameState() {
    return GameLogState.values.firstWhere(
      (element) => element.name == gameState,
      orElse: () => GameLogState.over,
    );
  }

  setGameLogState(GameLogState state) {
    gameState = state.name;
  }

  bool isGameOver() {
    return getGameState() == GameLogState.over;
  }
}

enum GameLogState {
  created,
  started,
  over,
  failed,
}
