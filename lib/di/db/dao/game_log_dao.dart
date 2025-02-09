/*
 *
 *  *
 *  * Created on 4 5 2023
 *
 */

import 'package:the_deck/di/db/entity/assets_entity.dart';

import '../../../objectbox.g.dart';
import 'package:objectbox/objectbox.dart';
import '../database.dart';
import '../entity/game_log_entity.dart';

class GameLogDao {
  final Database _database;

  late final _box = _database.box<GameLogEntity>();

  GameLogDao(this._database);

  GameLogEntity? getLog(String roomId) {
    final log =
        _box.query(GameLogEntity_.roomId.equals(roomId)).build().findUnique();
    return log;
  }

  GameLogEntity? getLogById(int gameLogId) {
    final log =
        _box.query(GameLogEntity_.id.equals(gameLogId)).build().findUnique();
    return log;
  }

  GameLogEntity? getLastLog() {
    final log = _box
        .query()
        .order(GameLogEntity_.updated, flags: Order.descending)
        .build()
        .findFirst();
    return log;
  }

  void insertOrUpdate(GameLogEntity gameLog) {
    _box.put(gameLog);
  }

  List<GameLogEntity> getAll() {
    return _box.query().build().find();
  }

  Map<int, int> getWins(String userId) {
    final result =
        _box.query(GameLogEntity_.winnerUserId.equals(userId)).build().find();
    final Map<int, int> gameWins = {};
    for (final e in result) {
      gameWins[e.gameId] = (gameWins[e.gameId] ?? 0) + 1;
    }
    return gameWins;
  }

  Map<int, int> getGames(String userId) {
    final result = _box.query().build().find();
    final Map<int, int> gameWins = {};
    for (final e in result) {
      gameWins[e.gameId] = (gameWins[e.gameId] ?? 0) + 1;
    }
    return gameWins;
  }

  List<GameLogEntity> getReplayGames() {
    final log = _box
        .query(GameLogEntity_.logPath
            .notNull()
            .and(GameLogEntity_.gameState.equals(GameLogState.over.name)))
        .order(GameLogEntity_.updated, flags: Order.descending)
        .build()
        .find();
    return log;
  }
}
