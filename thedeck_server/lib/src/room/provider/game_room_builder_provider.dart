/*
 *
 *  *
 *  * Created on 20 5 2023
 *
 */

import '../builder/game_room_builder.dart';

abstract class GameRoomBuilderProvider {
  GameRoomBuilder? get(String roomId);

  bool save(GameRoomBuilder gameRoom);

  bool remove(String roomId);

  bool contains(String roomId);

  clear();

  GameRoomBuilderProvider();
}

class InMemoryGameRoomBuilderProvider extends GameRoomBuilderProvider {
  static final _cache = <String, GameRoomBuilder>{};

  @override
  GameRoomBuilder? get(String roomId) {
    return _cache[roomId];
  }

  @override
  bool remove(String roomId) {
    return _cache.remove(roomId) != null;
  }

  @override
  bool save(GameRoomBuilder gameRoom) {
    final exists = _cache[gameRoom.roomId] != null;
    _cache[gameRoom.roomId] = gameRoom;
    return exists;
  }

  @override
  clear() {
    _cache.clear();
  }

  @override
  bool contains(String roomId) => _cache.containsKey(roomId);
}
