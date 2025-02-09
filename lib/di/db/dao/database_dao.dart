/*
 *
 *  *
 *  * Created on 11 3 2023
 *
 */

import 'package:the_deck/di/db/dao/assets_dao.dart';
import 'package:the_deck/di/db/dao/game_log_dao.dart';
import 'package:the_deck/di/db/dao/key_value_dao.dart';

import '../database.dart';
import 'user_entity_dao.dart';
import 'user_profile_dao.dart';

class DatabaseDao {
  final UserEntityDao userDao;
  final UserProfileEntityDao userProfileDao;
  final AssetsEntityDao assetsEntityDao;
  final GameLogDao gameLogDao;
  final KeyValueEntityDao keyValueDao;

  DatabaseDao(Database database)
      : userDao = UserEntityDao(database),
        assetsEntityDao = AssetsEntityDao(database),
        gameLogDao = GameLogDao(database),
        keyValueDao = KeyValueEntityDao(database),
        userProfileDao = UserProfileEntityDao(database);
}
