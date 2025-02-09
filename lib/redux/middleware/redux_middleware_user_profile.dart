/*
 *
 *  *
 *  * Created on 17 1 2023
 *
 */

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:the_deck/dto/achievement_dto.dart';
import 'package:the_deck/dto/game_statistics.dart';
import 'package:the_deck/redux/actions/reduxt_action_home_screen.dart';
import 'package:thedeck_common/the_deck_common.dart';
import 'package:ulid/ulid.dart';

import '../../di/app_dependency.dart';
import '../../di/db/entity/user_entity.dart';
import '../../di/db/entity/user_profile_entity.dart';
import '../../dto/game_dto.dart';
import '../../utils/string_utils.dart';
import '../actions/redux_action_user_state.dart';
import '../actions/reduxt_action_user_profile.dart';
import '../app_state.dart';

ThunkActionWithExtraArgument<AppState, AppDependency>
    middlewareLoadAppForUser() {
  return (store, dependency) async {
    final user = _getCurrentUserEntity(store, dependency);
    store.dispatch(StoreUserAction(user));

    dependency.analytics.setUserLocalKey(user.getKey());

    final games = GamesList.values
        .map((e) => Game.fromGamesList(e))
        .toList()
        .reversed
        .toList();
    store.dispatch(LoadedRecentGamesAction(games));

    final replayGames = dependency.dao.gameLogDao.getReplayGames();
    store.dispatch(LoadedReplayGamesAction(replayGames));

    if (kDebugMode) {
      // _mockLeaderboardAndAchievements(dependency, store);
      _logDeviceDetails(dependency);
    }

    _loadLeaderboard(dependency, store);
    _loadAchievements(dependency, store, user.getKey());
  };
}

ThunkActionWithExtraArgument<AppState, AppDependency>
    middlewareNotificationsPermission() {
  return (store, dependency) async {
    //TODO not used
    // dependency.pushNotificationHandler.requestPermission();
  };
}

void _logDeviceDetails(AppDependency dependency) {
  final log = dependency.logger;
  log.d(dependency.buildInfo.toJson(), tag: 'Build Info');
  log.d(dependency.deviceInfo.toJson(), tag: 'Device Info');
}

ThunkActionWithExtraArgument<AppState, AppDependency>
    middlewareLoadLeaderboard() {
  return (store, dependency) async {
    _loadLeaderboard(dependency, store);
  };
}

void _loadLeaderboard(AppDependency dependency, Store<AppState> store) {
  final leaderboard = dependency.dao.userProfileDao.getLeaderboard();
  store.dispatch(LoadedLeaderboardAction(leaderboard));
}

ThunkActionWithExtraArgument<AppState, AppDependency>
    middlewareLoadAchievements() {
  return (store, dependency) async {
    final user = _getCurrentUserEntity(store, dependency);
    _loadAchievements(dependency, store, user.getKey());
  };
}

void _loadAchievements(
  AppDependency dependency,
  Store<AppState> store,
  String userId,
) {
  final games = dependency.dao.gameLogDao.getGames(userId);
  final wins = dependency.dao.gameLogDao.getWins(userId);
  final statistics = GameStatistics(games, wins);
  final List<AchievementBadge> achievements = [];

  for (final e in Achievement.values) {
    if (e.achieved(statistics)) {
      final badge = AchievementBadge.fromAchievement(e);
      achievements.add(badge);
    }
  }
  store.dispatch(LoadedAchievementAction(achievements));
}

void _mockLeaderboardAndAchievements(
    AppDependency dependency, Store<AppState> store) {
  final leaderboard = dependency.dao.userProfileDao.getLeaderboard();
  for (int i = 0; i < 5; i++) {
    leaderboard.add(UserProfileEntity(
      userId: Ulid().toUuid(),
      nickName: getRandomString(10),
      score: Random().nextInt(10000),
    ));
  }
  store.dispatch(LoadedLeaderboardAction(leaderboard));

  final List<AchievementBadge> achievements = [];
  achievements.addAll(Achievement.values
      .map((e) => AchievementBadge.fromAchievement(e))
      .toList());
  store.dispatch(LoadedAchievementAction(achievements));
}

ThunkActionWithExtraArgument<AppState, AppDependency>
    middlewareLoadCurrentUser() {
  return (store, dependency) async {
    final user = _getCurrentUserEntity(store, dependency);
    store.dispatch(StoreUserAction(user));
  };
}

ThunkActionWithExtraArgument<AppState, AppDependency> middlewareLoadUserProfile(
    String userId) {
  return (store, dependency) async {
    final currentUser = _getCurrentUserEntity(store, dependency);
    if (userId == currentUser.getKey()) {
      final profile = UserProfileEntity.fromUserEntity(currentUser);
      store.dispatch(LoadedUserProfile(profile));
    } else {
      final profile = dependency.dao.userProfileDao.getUser(userId);
      if (profile != null) {
        store.dispatch(LoadedUserProfile(profile));
      }
    }
  };
}

ThunkActionWithExtraArgument<AppState, AppDependency>
    middlewareUpdateUserProfile(
  String userId, {
  String? name,
  String? surname,
  String? nickName,
  String? email,
  String? image,
}) {
  return (store, dependency) async {
    final currentUser = _getCurrentUserEntity(store, dependency);
    if (userId == currentUser.getKey()) {
      currentUser.name = name ?? currentUser.name;
      currentUser.surname = surname ?? currentUser.surname;
      currentUser.nickName = nickName ?? currentUser.nickName;
      currentUser.email = email ?? currentUser.email;
      currentUser.image = image ?? currentUser.image;

      dependency.dao.userDao.saveUser(currentUser);

      final profile = UserProfileEntity.fromUserEntity(currentUser);
      store.dispatch(LoadedUserProfile(profile));
      return;
    } else {}
  };
}

UserEntity _getCurrentUserEntity(
  Store<AppState> store,
  AppDependency dependency,
) {
  var user = store.state.userState.user;
  if (user == null) {
    user = dependency.dao.userDao.getUser();
    if (user == null) {
      final ulid = Ulid().toUuid();
      user = UserEntity()
        ..userLocalKey = ulid
        ..nickName = getRandomString(10);
      dependency.dao.userDao.saveUser(user);
      dependency.api.userApi
          .newUser(user.userLocalKey, user.nickName)
          .then((value) {
        //TODO load user from api
      });
    }
    user = dependency.dao.userDao.getUser();
    dependency.logger.d('User Profile Loaded ${user?.getKey() ?? "Unknown"}');
  }
  return user!;
}

ThunkActionWithExtraArgument<AppState, AppDependency> middlewareUpdateNickname(
    String userId, String nickname) {
  return (store, dependency) async {
    final currentUser = _getCurrentUserEntity(store, dependency);
    if (userId == currentUser.getKey()) {
      currentUser.nickName = nickname;
      dependency.dao.userDao.saveUser(currentUser);
      final profile = UserProfileEntity.fromUserEntity(currentUser);
      store.dispatch(LoadedUserProfile(profile));
    }
  };
}

ThunkActionWithExtraArgument<AppState, AppDependency> middlewareAddScore(
    int score) {
  return (store, dependency) async {
    final currentUser = _getCurrentUserEntity(store, dependency);
    currentUser.score += score;
    dependency.dao.userDao.saveUser(currentUser);
    final profile = UserProfileEntity.fromUserEntity(currentUser);
    store.dispatch(LoadedUserProfile(profile));
  };
}
