/*
 *
 *  *
 *  * Created on 17 1 2023
 *
 */

import 'package:the_deck/di/db/entity/game_log_entity.dart';

import '../../di/db/entity/user_profile_entity.dart';
import '../../dto/achievement_dto.dart';
import '../../dto/game_dto.dart';
import '../../dto/reconnect_to_game.dart';

class HomeScreenState {
  final List<Game> recentGames;
  final List<GameLogEntity> replayGames;
  final List<Game> liveGames;
  final List<AchievementBadge> achievements;
  final List<UserProfileEntity> leaderboard;
  final int focusedGamedIndex;
  final bool hasInternetConnection;
  final ReconnectToGameRoom? reconnectToGameRoom;

  HomeScreenState({
    required this.recentGames,
    required this.replayGames,
    required this.liveGames,
    required this.achievements,
    required this.leaderboard,
    this.focusedGamedIndex = -1,
    this.hasInternetConnection = false,
    this.reconnectToGameRoom,
  });

  HomeScreenState copyWith({
    List<Game>? recentGames,
    List<GameLogEntity>? replayGames,
    List<Game>? liveGames,
    List<AchievementBadge>? achievements,
    List<UserProfileEntity>? leaderboard,
    int? focusedGamedIndex,
    bool? hasInternetConnection,
    ReconnectToGameRoom? reconnectToGameRoom,
  }) {
    return HomeScreenState(
      recentGames: recentGames ?? this.recentGames,
      replayGames: replayGames ?? this.replayGames,
      liveGames: liveGames ?? this.liveGames,
      achievements: achievements ?? this.achievements,
      leaderboard: leaderboard ?? this.leaderboard,
      focusedGamedIndex: focusedGamedIndex ?? this.focusedGamedIndex,
      hasInternetConnection:
          hasInternetConnection ?? this.hasInternetConnection,
      reconnectToGameRoom: reconnectToGameRoom ?? this.reconnectToGameRoom,
    );
  }

  HomeScreenState.empty()
      : recentGames = [],
        replayGames = [],
        leaderboard = [],
        achievements = [],
        liveGames = [],
        hasInternetConnection = false,
        focusedGamedIndex = -1,
        reconnectToGameRoom = null;

  HomeScreenState copyReplace({
    ReconnectToGameRoom? reconnectToGameRoom,
  }) {
    return HomeScreenState(
      recentGames: recentGames,
      replayGames: replayGames,
      liveGames: liveGames,
      achievements: achievements,
      leaderboard: leaderboard,
      focusedGamedIndex: focusedGamedIndex,
      hasInternetConnection: hasInternetConnection,
      reconnectToGameRoom: reconnectToGameRoom,
    );
  }
}
