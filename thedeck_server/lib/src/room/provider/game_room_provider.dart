/*
 *
 *  *
 *  * Created on 20 5 2023
 *
 */

import 'package:thedeck_common/the_deck_common.dart';

abstract class GameRoomProvider {
  GameRoom? get(String roomId);

  bool save(GameRoom gameRoom);

  bool remove(String roomId);

  bool contains(String roomId);

  clear();

  GameRoomProvider();
}

class InMemoryServerGameRoomProvider extends GameRoomProvider {
  static final _cache = <String, GameRoom>{};

  @override
  GameRoom? get(String roomId) {
    return _cache[roomId];
  }

  @override
  bool remove(String roomId) {
    return _cache.remove(roomId) != null;
  }

  @override
  bool save(GameRoom gameRoom) {
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
