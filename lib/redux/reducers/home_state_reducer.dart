/*
 *
 *  *
 *  * Created on 17 1 2023
 *
 */

part of 'app_reducer.dart';

Reducer<HomeScreenState> _homeStateReducer = combineReducers<HomeScreenState>([
  TypedReducer<HomeScreenState, LoadedAchievementAction>(
      _homeLoadedUserAchievementsReducer),
  TypedReducer<HomeScreenState, LoadedLeaderboardAction>(
      _homeLoadedUserLeaderboardReducer),
  TypedReducer<HomeScreenState, LoadedLiveGamesAction>(
      _homeLoadedLiveGamesReducer),
  TypedReducer<HomeScreenState, LoadedReplayGamesAction>(
      _homeLoadedReplayGamesReducer),
  TypedReducer<HomeScreenState, LoadedRecentGamesAction>(
      _homeLoadedRecentGamesReducer),
  TypedReducer<HomeScreenState, ChangeFocusGameIndexAction>(
      _homeChangeFocusGameIndexReducer),
  TypedReducer<HomeScreenState, ChangeNetworkStateAction>(
      _homeChangeWifiReducer),
  TypedReducer<HomeScreenState, ReconnectToGameRoomAction>(
      _homeReconnectToGameRoomReducer),
]);

HomeScreenState _homeLoadedUserAchievementsReducer(
    HomeScreenState state, LoadedAchievementAction action) {
  return state.copyWith(achievements: action.data);
}

HomeScreenState _homeLoadedUserLeaderboardReducer(
    HomeScreenState state, LoadedLeaderboardAction action) {
  return state.copyWith(leaderboard: action.data);
}

HomeScreenState _homeLoadedLiveGamesReducer(
    HomeScreenState state, LoadedLiveGamesAction action) {
  return state.copyWith(liveGames: action.data);
}

HomeScreenState _homeLoadedReplayGamesReducer(
    HomeScreenState state, LoadedReplayGamesAction action) {
  return state.copyWith(replayGames: action.data);
}

HomeScreenState _homeLoadedRecentGamesReducer(
    HomeScreenState state, LoadedRecentGamesAction action) {
  return state.copyWith(recentGames: action.data);
}

HomeScreenState _homeChangeFocusGameIndexReducer(
    HomeScreenState state, ChangeFocusGameIndexAction action) {
  return state.copyWith(focusedGamedIndex: action.index);
}

HomeScreenState _homeChangeWifiReducer(
    HomeScreenState state, ChangeNetworkStateAction action) {
  return state.copyWith(hasInternetConnection: action.hasInternet);
}

HomeScreenState _homeReconnectToGameRoomReducer(
    HomeScreenState state, ReconnectToGameRoomAction action) {
  return state.copyReplace(reconnectToGameRoom: action.data);
}
