/*
 *
 *  *
 *  * Created on 1 4 2023
 *
 */

import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';
import 'package:thedeck_common/the_deck_common.dart';

class SocketClientUseCase extends SocketClientMessageEmitter {
  final CommonLogger log;
  IO.Socket? _io;
  final SocketMessageStream? _socketMessageStream;
  final _messageQueue = Queue<Pair<AppSocketMessage, Function(dynamic)?>>();

  get socketMessageStream => _socketMessageStream;

  SocketClientUseCase(this._socketMessageStream, {required this.log});

  Future<bool> connect(String address, [enableMultiples = false]) async {
    log.d('Create Client', tag: _Constants.tag);
    if (_io != null || _io?.connected == true) {
      log.d('Dispose connected client', tag: _Constants.tag);
      dispose();
    }

    final optionBuilder = OptionBuilder()
        .setTransports([_Constants.transport])
        .setPath(_Constants.socketPath)
        .enableReconnection();

    if (enableMultiples) {
      optionBuilder.enableMultiplex().enableForceNewConnection();
    }

    final options = optionBuilder.build();
    if (!address.startsWith(_Constants.httpProtocol)) {
      address = '${_Constants.httpProtocol}$address';
    }
    IO.Socket socket = IO.io(
      address,
      options,
    );

    Completer<bool> completer = Completer();
    _connectionTimer(completer);
    _setListeners(socket, completer);

    _io = socket.connect();
    return completer.future;
  }

  void _connectionTimer(Completer<bool> completer) {
    Timer(const Duration(milliseconds: _Constants.connectionTimeout), () {
      if (!completer.isCompleted) {
        log.d('Connection failed, timeout', tag: _Constants.tag);
        completer.complete(false);
      }
    });
  }

  void _setListeners(IO.Socket socket, Completer<bool> completer) {
    socket.onConnect((d) {
      log.d("On ${_Constants.connect} : ${socket.id}", tag: _Constants.tag);
      completer.complete(true);
      final data = AppSocketMessage.send(SocketConnectedAckMessage(socket.id));
      socket.emitWithAck(_Constants.socketMessage, data.toJson(), ack: (data) {
        log.d('Ack received: $data', tag: _Constants.tag);
      });
      _emptyPendingQueue();
    });

    socket.on(_Constants.socketMessage, (data) {
      log.d('${_Constants.socketMessage} : $data', tag: _Constants.tag);
      _consumeMessage(data);
    });

    socket.on(_Constants.fromServer, (data) {
      log.d('${_Constants.fromServer}: $data', tag: _Constants.tag);
      _consumeMessage(data);
    });

    socket.onDisconnect((data) {
      log.d('${_Constants.onDisconnect}: $data', tag: _Constants.tag);
    });

    socket.onError((data) {
      log.e('${_Constants.onError}: $data', tag: _Constants.tag);
    });
  }

  void _emptyPendingQueue() {
    while (_messageQueue.isNotEmpty) {
      final pair = _messageQueue.removeFirst();
      log.e('Sending message from Q: ${pair.first.messageId}',
          tag: _Constants.tag);
      emitMessage(pair.first, ack: pair.second);
    }
  }

  @override
  bool emitMessage(AppSocketMessage message,
      {Function(dynamic)? ack, bool addToQueue = true}) {
    var isConnected = _io?.connected;
    if (isConnected == null || !isConnected) {
      log.e('Socket is not connected', tag: _Constants.tag);
      if (addToQueue) {
        log.e('Added message to Q: ${message.toJson()}', tag: _Constants.tag);
        _messageQueue.add(Pair.of(message, ack));
      } else {
        log.e('Message not added to Q and lost: ${message.toJson()}',
            tag: _Constants.tag);
      }
      return false;
    }
    var json = message.toJson();
    log.d('Sending message: $json', tag: _Constants.tag);
    _io?.emitWithAck(_Constants.socketMessage, json, ack: _ack(ack, message));
    return true;
  }

  Function _ack(Function(dynamic)? ack, AppSocketMessage message) {
    return ack ??
        (data) {
          log.e('Socket message ${message.messageId} acknowledged; Data: $data',
              tag: _Constants.tag);
        };
  }

  void _consumeMessage(String data) {
    try {
      final json = jsonDecode(data);
      _socketMessageStream?.add(json);
    } catch (e) {
      log.e('Failed to parse message. Data $data; Error: $e',
          tag: _Constants.tag);
    }
  }

  dispose() {
    log.d('Dispose Client', tag: _Constants.tag);
    try {
      _io?.dispose();
    } catch (e) {
      log.e('Dispose Client Error: $e', tag: _Constants.tag);
    }
    _io = null;
  }
}

mixin _Constants {
  //TV device require significantly longer timeout
  static const connectionTimeout = 2500;
  static const socketPath = '/thedeck';
  static const connect = 'connect';
  static const onDisconnect = 'onDisconnect';
  static const onError = 'onError';
  static const transport = 'websocket';
  static const tag = 'Socket Client';
  static const httpProtocol = 'http://';
  static const socketMessage = ApiConstantsSocket.socketMessage;
  static const fromServer = ApiConstantsSocket.fromServer;
}
