/*
 *
 *  *
 *  * Created on 1 4 2023
 *
 */

mixin ApiConstantsSocket {
  static const socketMessage = 'message';
  static const fromServer = 'fromServer';
}

mixin ApiConstantsSocketPayload {
  static const path = 'path';
  static const data = 'data';
  static const messageId = 'messageId';
  static const room = 'room';
  static const board = 'board';
  static const field = 'field';
  static const winner = 'winner';
  static const gameOver = 'gameOver';
  static const participants = 'participants';
  static const observers = 'observers';
  static const join = 'join';
  static const move = 'move';
  static const subscribe = 'subscribe';
  static const clientDisconnected = 'disconnect';
  static const roomClosed = 'roomClosed';
  static const socketId = 'socketId';
  static const onDisconnect = 'onDisconnect';
  static const isReady = 'isReady';
  static const reconnect = 'reconnect';
}

mixin ApiConstantsSocketPath {
  static move(gameId) => '/$gameId/${ApiConstantsSocketPayload.move}';

  static field(gameId) => '/$gameId/${ApiConstantsSocketPayload.field}';

  static gameOver(gameId) => '/$gameId/${ApiConstantsSocketPayload.gameOver}';

  static room(gameId) => '/$gameId/${ApiConstantsSocketPayload.room}';

  static participants(gameId) =>
      '/$gameId/${ApiConstantsSocketPayload.participants}';

  static observers(gameId) => '/$gameId/${ApiConstantsSocketPayload.observers}';

  static isReady(roomId) => '/$roomId/${ApiConstantsSocketPayload.isReady}';

  static subscribe(gameId) => '/$gameId/${ApiConstantsSocketPayload.subscribe}';

  static join(gameId) => '/$gameId/${ApiConstantsSocketPayload.join}';

  static clientDisconnected(gameId) =>
      '/$gameId/${ApiConstantsSocketPayload.clientDisconnected}';

  static onDisconnect() => '/${ApiConstantsSocketPayload.onDisconnect}';

  static roomClosed(roomId) =>
      '/$roomId/${ApiConstantsSocketPayload.roomClosed}';

  static roomReconnect(roomId) =>
      '/$roomId/${ApiConstantsSocketPayload.reconnect}';
}
