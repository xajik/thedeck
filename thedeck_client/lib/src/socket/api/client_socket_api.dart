/*
 *
 *  *
 *  * Created on 1 4 2023
 *
 */

import 'package:thedeck_common/the_deck_common.dart';

class ClientSocketApi {
  final SocketClientMessageEmitter _emitter;

  ClientSocketApi(this._emitter);

  bool joinRoom(dynamic roomId, GameParticipant participant) {
    final message =
        AppSocketMessage.send(participant, "/$roomId/${_Constants.join}");
    return _emitter.emitMessage(message);
  }

  bool reconnectRoom(
      dynamic roomId, ParticipantReconnectSocketMessage participant) {
    final message =
        AppSocketMessage.send(participant, "/$roomId/${_Constants.reconnect}");
    return _emitter.emitMessage(message);
  }

  bool subscribeRoom(dynamic roomId, GameParticipant participant) {
    final message =
        AppSocketMessage.send(participant, "/$roomId/${_Constants.subscribe}");
    return _emitter.emitMessage(message);
  }

  bool gameMove(dynamic gameId, GameMove move) {
    final message = AppSocketMessage.send(move, "/$gameId/${_Constants.move}");
    return _emitter.emitMessage(message);
  }

  bool disconnect(dynamic roomId, ClientDisconnectSocketMessage data) {
    final message =
        AppSocketMessage.send(data, "/$roomId/${_Constants.disconnect}");
    return _emitter.emitMessage(message, addToQueue: false);
  }

  bool requestUpdateField(
      dynamic roomId, RequestFieldUpdateSocketMessage data) {
    final message = AppSocketMessage.send(data, "/$roomId/${_Constants.field}");
    return _emitter.emitMessage(message);
  }
}

mixin _Constants {
  static const String join = ApiConstantsSocketPayload.join;
  static const String reconnect = ApiConstantsSocketPayload.reconnect;
  static const String move = ApiConstantsSocketPayload.move;
  static const String disconnect = ApiConstantsSocketPayload.clientDisconnected;
  static const String subscribe = ApiConstantsSocketPayload.subscribe;
  static const String field = ApiConstantsSocketPayload.field;
}
