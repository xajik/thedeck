/*
 *
 *  *
 *  * Created on 21 5 2023
 *
 */

import 'package:thedeck_common/the_deck_common.dart';

class ServerRoomError extends JsonEncodeable {
  final int code;
  final String? message;
  final Exception? exception;

  ServerRoomError(this.code, [this.message, this.exception]);

  @override
  Map<String, dynamic> toMap() {
    return {
      'code': code,
      'message': message,
      'exception': exception,
    };
  }

  factory ServerRoomError.fromMap(Map<String, dynamic> json) {
    return ServerRoomError(
      json["code"],
      json["message"],
      json["exception"],
    );
  }
}

mixin ServerErrorCode {
  static const int port_taken_error = 1025;
  static const int unknown_game_id = 1026;
  static const int failed_to_create_room = 1027;
  static const int room_not_found = 1027;
}
