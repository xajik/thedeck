/*
 *
 *  *
 *  * Created on 25 6 2023
 *
 */

import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:the_deck/di/db/entity/game_log_entity.dart';
import 'package:thedeck_client/the_deck_client.dart';
import 'package:thedeck_common/the_deck_common.dart';

import '../di/files/game_log_file_manager.dart';
import '../handlers/game_handler.dart';
import '../redux/actions/replay_game_actions.dart';

class ReplayGameUsecase {
  final CommonLogger _log;
  final GameLogFileManager _gameLogFileManager;
  final SocketMessageStream _socketMessageStream;
  Timer? _timer;

  ReplayGameUsecase(
    this._log,
    this._gameLogFileManager,
  ) : _socketMessageStream = SocketMessageStream(_log, _Constants.tag);

  Future<bool> replay(
    GameLogEntity gameLog,
    Function dispatcher,
  ) async {
    if (_timer != null) {
      stop();
    }

    _log.d('Replaying game: ${gameLog.gameId}', tag: _Constants.tag);
    if (gameLog.logPath == null) {
      _log.e('Game log path is null', tag: _Constants.tag);
      return false;
    }
    final file = await _gameLogFileManager.readLog(gameLog.roomId);
    if (file == null) {
      _log.e('Game log file is null', tag: _Constants.tag);
      return false;
    }
    final gameId = gameLog.gameId;
    final json = jsonDecode(file);

    final parseRoom = _parseRoom(gameId, json);
    final GameRoom? room = parseRoom.first;
    if (room == null) {
      return false;
    }

    final moves = Queue.from(parseRoom.second);
    room.board.moves.clear();

    final handler = gameHandlerFactory(gameId, dispatcher);
    handler?.updateRoom(room);

    if (handler == null) {
      return false;
    }
    dispatcher(ReplayProgressUpdateAction(moves.length, moves.length));
    _startBackgroundTimer(moves, room.board, handler, dispatcher);
    return true;
  }

  void _startBackgroundTimer(Queue queue, GameBoard board,
      GameClientHandler handler, Function dispatcher) {
    final totalMoves = queue.length;
    _log.d('Starting background timer: ${queue.length}', tag: _Constants.tag);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (queue.isNotEmpty) {
        final move = queue.removeFirst();
        board.makeMove(move);
        handler.updateField(board.gameField);
        _log.d('Made move, left: ${queue.length}', tag: _Constants.tag);
        dispatcher(ReplayProgressUpdateAction(totalMoves, queue.length));
      } else {
        _log.d('Replay done', tag: _Constants.tag);
        stop();
      }
    });
  }

  void stop() {
    _log.d('Stopping background timer', tag: _Constants.tag);
    _timer?.cancel();
    _timer = null;
  }

  Pair<GameRoom?, List> _parseRoom(int gameId, Map<String, dynamic> json) {
    if (gameId == GamesList.ticTacToe.id) {
      final oldBoard =
          TicTacToeGameBoard.fromMap(json[ApiConstantsSocketPayload.board]);
      final board = oldBoard.copyWith(gameField: TicTacToeGameField());
      return Pair.of(
          GameRoom<TicTacToeGameBoard>.fromMap(json, board), oldBoard.moves);
    }
    if (gameId == GamesList.connectFour.id) {
      final oldBoard =
          ConnectFourGameBoard.fromMap(json[ApiConstantsSocketPayload.board]);
      final board = oldBoard.copyWith(gameField: ConnectFourGameField());
      return Pair.of(
          GameRoom<ConnectFourGameBoard>.fromMap(json, board), oldBoard.moves);
    }
    if (gameId == GamesList.dixit.id) {
      final oldBoard =
          DixitGameBoard.fromMap(json[ApiConstantsSocketPayload.board]);
      final List<DixitGamePlayer> players =
          oldBoard.players.map((e) => DixitGamePlayer(e.userId)).toList();
      final gameField = DixitGameField.newField(
        players,
        cardDeck: oldBoard.gameField.cardDeck,
      );
      final board = oldBoard.copyWith(gameField: gameField);
      return Pair.of(
          GameRoom<DixitGameBoard>.fromMap(json, board), oldBoard.moves);
    }
    if (gameId == GamesList.mafia.id) {
      final oldBoard =
          MafiaGameBoard.fromMap(json[ApiConstantsSocketPayload.board]);
      final List<MafiaGamePlayer> players = oldBoard.players
          .map((e) => MafiaGamePlayer(e.userId, e.role))
          .toList();
      final gameField = MafiaGameField.newField(
        players,
      );
      final board = oldBoard.copyWith(gameField: gameField);
      return Pair.of(
          GameRoom<MafiaGameBoard>.fromMap(json, board), oldBoard.moves);
    }
    _log.e('Board is null', tag: _Constants.tag);
    return Pair.of(null, []);
  }
}

mixin _Constants {
  static const tag = 'ReplayGameUsecase';
}
