/*
 *
 *  *
 *  * Created on 21 4 2023
 *
 */

import 'package:thedeck_common/the_deck_common.dart';

import '../../../objectbox.g.dart';
import '../database.dart';
import '../entity/user_profile_entity.dart';

class UserProfileEntityDao {
  final Database _database;

  late final _box = _database.box<UserProfileEntity>();

  UserProfileEntityDao(this._database);

  UserProfileEntity? getUser(String userId) {
    final query = _box.query(UserProfileEntity_.userId.equals(userId)).build();
    final result = query.findFirst();
    return result;
  }

  int saveProfile(UserProfileEntity user) {
    return _box.put(user);
  }

  List<UserProfileEntity> getLeaderboard() {
    return (_box.query()
          ..order(UserProfileEntity_.score, flags: Order.descending))
        .build()
        .find();
  }

  void saveGameParticipants(List<GameParticipant> participants) {
    for (var e in participants) {
      final id = _box
          .query(UserProfileEntity_.userId.equals(e.userId))
          .build()
          .findFirst()
          ?.id;
      final profile = UserProfileEntity.fromGameParticipant(e, id: id);
      _box.put(profile);
    }
  }
}
