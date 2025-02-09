/*
 *
 *  *
 *  * Created on 31 1 2023
 *
 */

import 'package:ulid/ulid.dart';

import '../../encodable/encodable_json.dart';

class AppSocketMessage extends JsonEncodeable {
  final String messageId;
  final String path;
  final DateTime createAt;

  JsonEncodeable data;

  AppSocketMessage.send(this.data, [this.path = "/"])
      : messageId = Ulid().toUuid(),
        createAt = DateTime.now();

  AppSocketMessage._receive(this.data, this.createAt, this.messageId, this.path);

  @override
  Map<String, dynamic> toMap() {
    return {
      'messageId': messageId,
      'createAt': createAt.toIso8601String(),
      'path': path,
      'data': data.toMap(),
    };
  }

  factory AppSocketMessage.fromJson(Map<String, dynamic> json) {
    return AppSocketMessage._receive(
      json["messageId"],
      json["createAt"],
      json["path"],
      json["data"],
    );
  }
}

class AppSocketAckMessage extends JsonEncodeable{
  final String messageId;
  final String ackMessageId;
  final DateTime createAt;

  AppSocketAckMessage.send(this.ackMessageId)
      : messageId = Ulid().toUuid(),
        createAt = DateTime.now();

  AppSocketAckMessage.receive(this.messageId, this.ackMessageId, this.createAt);

  @override
  Map<String, dynamic> toMap() {
    return {
      'ackMessageId': ackMessageId,
      'messageId': ackMessageId,
      'createAt': createAt.toIso8601String(),
    };
  }

  factory AppSocketAckMessage.fromJson(Map<String, dynamic> json) {
    return AppSocketAckMessage.receive(
      json["messageId"],
      json["ackMessageId"],
      json["createAt"],
    );
  }
}
