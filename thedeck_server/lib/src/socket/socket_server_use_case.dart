/*
 *
 *  *
 *  * Created on 1 4 2023
 *
 */

import 'dart:convert';
import 'dart:io';

import 'package:socket_io/socket_io.dart';
import 'package:thedeck_common/the_deck_common.dart';

class SocketServerUseCase extends SocketServerMessageEmitter {
  final CommonLogger _log;
  Server? _io;
  final SocketMessageStream _socketMessageStream;

  get socketMessageStream {
    return _socketMessageStream;
  }

  final Map<String, Socket> _clientSockets = {};

  SocketServerUseCase(this._socketMessageStream, this._log);

  Future<int> create([int portOffset = 0]) async {
    _log.d('Create Server', tag: _Constants.tag);
    dispose();
    final io = Server();
    io.path(_Constants.socketPath);
    _defaultNamespace(io);
    final port = _Constants.port + portOffset;
    try {
      await io.listen(port);
    } on SocketException catch (e) {
      _log.e("Failed to listen on port $port: $e");
      return -1;
    }
    _io = io;
    return port;
  }

  void _defaultNamespace(Server io) {
    io.on(_Constants.connection, (client) {
      final socket = client as Socket;
      _log.d('Connection default namespace: ${socket.id}', tag: _Constants.tag);
      _clientSockets[socket.id] = socket;

      socket.on(_Constants.socketMessage, (data) {
        _log.d('${_Constants.socketMessage}: $data', tag: _Constants.tag);
        if (data is List) {
          final message = _consumeMessage(data.first, socket.id);
          data.last(
              "Received ${message?[_Constants.messageId] ?? _Constants.messageId}");
        } else {
          _consumeMessage(data, socket.id);
        }
      });

      socket.on(_Constants.disconnect, (data) {
        _log.d('Disconnect on server ${socket.id} with ${data} ',
            tag: _Constants.tag);
        _clientSockets.remove(socket.id);
        final payload = SocketDisconnectedSocketMessage(socket.id);
        final message = AppSocketMessage.send(
            payload, "/${ApiConstantsSocketPayload.onDisconnect}");
        _consumeMessage(message.toJson(), socket.id);
      });
    });
  }

  Map<String, dynamic>? _consumeMessage(String data, String? socketId) {
    try {
      final json = jsonDecode(data);
      json[_Constants.socketId] = socketId; //Use to link userID and socketID
      _socketMessageStream.add(json);
      return json;
    } catch (e) {
      _log.e('Failed to parse message. Data: $data; Error: $e',
          tag: _Constants.tag);
    }
    return null;
  }

  @override
  bool emitMessage(AppSocketMessage message, [String? socketId]) {
    if (_io == null || _io?.sockets == null) {
      return false;
    }

    if (socketId != null) {
      final socket = _io?.sockets.connected[socketId];
      if (socket != null) {
        socket.emit(_Constants.fromServer, message.toJson());
        return true;
      } else {
        _log.e('Failed to send message to $socketId', tag: _Constants.tag);
      }
      return false;
    }

    _io?.emit(_Constants.fromServer, message.toJson());
    return true;
  }

  Future<void> dispose() async {
    _log.d('Dispose Server', tag: _Constants.tag);
    _clientSockets.clear();
    try {
      await _io?.close();
    } catch (e) {
      _log.e('Failed to close socket server: $e', tag: _Constants.tag);
    }
    _io = null;
  }
}

mixin _Constants {
  static const socketPath = '/thedeck';
  static const connection = 'connection';
  static const tag = 'Socket Server';
  static const socketMessage = ApiConstantsSocket.socketMessage;
  static const fromServer = ApiConstantsSocket.fromServer;
  static const disconnect = 'disconnect';
  static const socketId = ApiConstantsSocketPayload.socketId;
  static const messageId = ApiConstantsSocketPayload.messageId;
  static const port = 3000;
}
