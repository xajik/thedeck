/*
 *
 *  *
 *  * Created on 1 4 2023
 *
 */

import 'package:thedeck_common/the_deck_common.dart';

class ServerSocketApi {
  final SocketServerMessageEmitter _emitter;

  ServerSocketApi(this._emitter);

  bool listParticipant(
    dynamic roomId,
    SocketListParticipantsMessage participant,
    bool addToQueue,
  ) {
    final message = AppSocketMessage.send(
        participant, "/$roomId/${_Constants.participants}");
    return _emitter.emitMessage(message);
  }

  bool listObservers(
    dynamic roomId,
    SocketNewObserverMessage observer,
  ) {
    final message =
        AppSocketMessage.send(observer, "/$roomId/${_Constants.observers}");
    return _emitter.emitMessage(message);
  }

  bool isRoomReady(
    dynamic roomId,
    SocketRoomIsReadyMessage data,
  ) {
    final message =
        AppSocketMessage.send(data, "/$roomId/${_Constants.isReady}");
    return _emitter.emitMessage(message);
  }

  bool gameField(dynamic gameId, GameField field, [recipient]) {
    final message =
        AppSocketMessage.send(field, "/$gameId/${_Constants.field}");
    return _emitter.emitMessage(message, recipient);
  }

  bool gameRoom(dynamic gameId, GameRoomSocketMessage data,
      [String? socketId]) {
    final message = AppSocketMessage.send(data, "/$gameId/${_Constants.room}");
    return _emitter.emitMessage(message, socketId);
  }

  bool gameOver(dynamic gameId, GameOverMessage data) {
    final message =
        AppSocketMessage.send(data, "/$gameId/${_Constants.gameOver}");
    return _emitter.emitMessage(message);
  }

  bool roomClosed(dynamic roomID, RoomClosedSocketMessage data) {
    final message =
        AppSocketMessage.send(data, "/$roomID/${_Constants.roomClosed}");
    return _emitter.emitMessage(message);
  }
}

mixin _Constants {
  static const String participants = ApiConstantsSocketPayload.participants;
  static const String isReady = ApiConstantsSocketPayload.isReady;
  static const String observers = ApiConstantsSocketPayload.observers;
  static const String field = ApiConstantsSocketPayload.field;
  static const String room = ApiConstantsSocketPayload.room;
  static const String gameOver = ApiConstantsSocketPayload.gameOver;
  static const String roomClosed = ApiConstantsSocketPayload.roomClosed;
}
