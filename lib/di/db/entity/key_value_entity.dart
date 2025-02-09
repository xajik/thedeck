/*
 *
 *  *
 *  * Created on 21 5 2023
 *
 */

import 'package:objectbox/objectbox.dart';
import 'package:thedeck_common/the_deck_common.dart';

@Entity()
class KeyValueEntity {
  @Id()
  int id = 0;
  @Unique()
  String key = "";
  String value = "";
  @Property(type: PropertyType.date)
  DateTime? updated;

  KeyValueEntity({
    required this.key,
    required this.value,
    this.updated,
  });

  factory KeyValueEntity.fromPair(Pair<String, String> pair) {
    return KeyValueEntity(
      key: pair.first,
      value: pair.second,
      updated: DateTime.now(),
    );
  }

  factory KeyValueEntity.fromValue(String key, String value) {
    return KeyValueEntity(
      key: key,
      value: value,
      updated: DateTime.now(),
    );
  }
}
