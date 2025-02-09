/*
 *
 *  *
 *  * Created on 21 5 2023
 *
 */

import 'dart:convert';

import 'package:the_deck/di/db/entity/key_value_entity.dart';

enum KeyValueKeys {
  iOSShowAllowLocalNetworkPermission,
}

class SingleKeyValue<T> {
  final String key;
  final T value;

  SingleKeyValue(this.key, this.value);

  KeyValueEntity toEntity() {
    return KeyValueEntity.fromValue(key, json.encode(value));
  }

  static SingleKeyValue<T> fromEntity<T>(KeyValueEntity entity) {
    return SingleKeyValue<T>(entity.key, jsonDecode(entity.value) as T);
  }
}
