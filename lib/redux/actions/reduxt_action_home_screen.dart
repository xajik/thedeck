/*
 *
 *  *
 *  * Created on 21 4 2023
 *
 */

import 'package:the_deck/di/db/entity/game_log_entity.dart';

import '../../di/db/entity/user_profile_entity.dart';
import '../../dto/achievement_dto.dart';
import '../../dto/game_dto.dart';
import '../../dto/reconnect_to_game.dart';

class LoadedRecentGamesAction {
  final List<Game> data;

  LoadedRecentGamesAction(this.data);
}

class LoadedReplayGamesAction {
  final List<GameLogEntity> data;

  LoadedReplayGamesAction(this.data);
}

class LoadedLiveGamesAction {
  final List<Game> data;

  LoadedLiveGamesAction(this.data);
}

class LoadedAchievementAction {
  final List<AchievementBadge> data;

  LoadedAchievementAction(this.data);
}

class LoadedLeaderboardAction {
  final List<UserProfileEntity> data;

  LoadedLeaderboardAction(this.data);
}

class ChangeFocusGameIndexAction {
  final int index;

  ChangeFocusGameIndexAction(this.index);
}

class ChangeNetworkStateAction {
  final bool hasInternet;

  ChangeNetworkStateAction(this.hasInternet);
}

class ReconnectToGameRoomAction {
  final ReconnectToGameRoom? data;

  ReconnectToGameRoomAction(this.data);
}
