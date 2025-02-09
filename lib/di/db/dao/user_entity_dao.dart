/*
 *
 *  *
 *  * Created on 11 3 2023
 *
 */

import '../database.dart';
import '../entity/user_entity.dart';

class UserEntityDao {
  final Database _database;

  late final _box = _database.box<UserEntity>();

  UserEntityDao(this._database);

  UserEntity? getUser() {
    var all = _box.getAll();
    if (all.isEmpty) {
      return null;
    }
    final user = all.first;
    return user;
  }

  void saveUser(UserEntity user) async {
    _box.put(user);
  }

  String? userKey() {
    final user = getUser();
    if (user == null) {
      return "";
    }
    return user.getKey();
  }
}
