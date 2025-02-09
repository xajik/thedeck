/*
 *
 *  *
 *  * Created on 1 4 2023
 *
 */

import 'dto/socket_message.dart';

abstract class SocketServerMessageEmitter {
  bool emitMessage(AppSocketMessage message, [String? socketId]);
}

abstract class SocketClientMessageEmitter {
  bool emitMessage(AppSocketMessage message,
      {Function(dynamic)? ack, bool addToQueue = true});
}
