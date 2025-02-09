/*
 *
 *  *
 *  * Created on 21 5 2023
 *
 */

import 'package:the_deck/di/db/entity/key_value_entity.dart';

import '../../../objectbox.g.dart';
import '../database.dart';

class KeyValueEntityDao {
  final Database _database;

  late final _box = _database.box<KeyValueEntity>();

  KeyValueEntityDao(this._database);

  int save(KeyValueEntity entity) {
    return _box.put(entity);
  }

  KeyValueEntity? getEntity(String key) {
    final query = _box.query(KeyValueEntity_.key.equals(key)).build();
    return query.findUnique();
  }

  String? getValue(String key) {
    final query = _box.query(KeyValueEntity_.key.equals(key)).build();
    final result = query.findUnique();
    return result?.value;
  }

  int? remove(String key) {
    final query = _box.query(KeyValueEntity_.key.equals(key)).build();
    return query.remove();
  }
}
