/*
 *
 *  *
 *  * Created on 22 5 2023
 *
 */

import 'package:thedeck_common/the_deck_common.dart';
import 'package:thedeck_server/src/room/provider/game_room_provider.dart';
import 'package:thedeck_server/src/socket/api/server_socket_api.dart';

class GameMoveUseCase {
  final GameRoomProvider _gameRoomProvider;
  final ServerSocketApi _serverApi;
  final CommonLogger _log;

  GameMoveUseCase(
    this._gameRoomProvider,
    this._serverApi,
    this._log,
  );

  bool move(String roomId, GameMove move, String clientSocketId) {
    final room = _gameRoomProvider.get(roomId);
    final board = room?.board;
    if (board != null) {
      if (board.makeMove(move)) {
        if (board.gameField.isGameOver) {
          final gameOver = GameOverMessage(
            room?.details.gameId,
            board,
            board.winner,
          );
          _serverApi.gameOver(room?.details.gameId, gameOver);
        } else {
          _serverApi.gameField(room?.details.gameId, board.gameField);
        }
      } else {
        _log.d("Move Failed for $clientSocketId", tag: "middlewareServerMove");
        _serverApi.gameField(
            room?.details.gameId, board.gameField, clientSocketId);
      }
    } else {
      _log.d("Move Failed, board $roomId is missing ",
          tag: "middlewareServerMove");
      final data = RoomClosedSocketMessage(roomId);
      _serverApi.roomClosed(room?.roomId, data);
    }
    return false;
  }
}
