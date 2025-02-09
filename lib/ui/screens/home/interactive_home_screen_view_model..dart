/*
 *
 *  *
 *  * Created on 21 4 2023
 *
 */

import 'package:redux/redux.dart';
import 'package:the_deck/di/db/entity/game_log_entity.dart';
import 'package:thedeck_common/the_deck_common.dart';

import '../../../di/db/entity/user_entity.dart';
import '../../../di/db/entity/user_profile_entity.dart';
import '../../../dto/achievement_dto.dart';
import '../../../dto/game_dto.dart';
import '../../../dto/reconnect_to_game.dart';
import '../../../redux/actions/reduxt_action_home_screen.dart';
import '../../../redux/app_state.dart';
import '../../../redux/middleware/redux_middleware_home.dart';
import '../../../redux/middleware/redux_middleware_room_connect.dart';
import '../../../redux/middleware/redux_middleware_routing.dart';
import '../../../redux/middleware/redux_middleware_user_permission.dart';
import '../../../redux/middleware/redux_middleware_user_profile.dart';
import '../../../redux/middleware/reduxt_middleware_lifecycle.dart';
import '../error/error_dialog_widget.dart';
import '../no_network_room/no_network_room_dialog_widget_widget.dart';
import '../profile/user_profile_screen_widget.dart';
import '../room/create/room_create_screen_widet.dart';
import '../start_game_confirmation/start_game_confirmation_dialog_widet.dart';

class InteractiveHomeScreenViewModel {
  final UserEntity? user;
  final Function(Function) appStart;
  final Function onResume;
  final Function() showUserProfile;
  final Function() showHelpConnect;
  final Function([Map<String, dynamic> args]) roomConnect;
  final Function([Map<String, dynamic> args]) gameListScreen;
  final Function([Map<String, dynamic> args]) replayListScreen;
  final Function([Map<String, dynamic> args]) replayGameScreen;
  final Function(GameDetails details) createDeckRoom;
  final Function([Map<String, dynamic> args]) showLeaderboard;
  final Function([Map<String, dynamic> args]) showAchievements;
  final Function(GameDetails details) showStartGameConfirmationDialog;
  final List<AchievementBadge> achievements;
  final List<UserProfileEntity> leaderboard;
  final List<Game> recentGames;
  final List<GameLogEntity> replayListGames;
  final List<Game> liveGames;
  final int focusedGamedIndex;
  final Function(int) focusGamedIndex;
  final Function() registerConnectivityListener;
  final bool hasInternet;
  final Function() showNoWifiErrorDialog;
  final Function(NoNetworkRoomDialogState state, [GameDetails? details])
      showNoWifiCreateRoomDialog;
  final ReconnectToGameRoom? roomReconnectInfo;
  final Function() reconnectToGameRoom;
  final Function() removeReconnectRoom;

  InteractiveHomeScreenViewModel({
    required this.user,
    required this.appStart,
    required this.onResume,
    required this.showUserProfile,
    required this.showHelpConnect,
    required this.roomConnect,
    required this.gameListScreen,
    required this.replayListScreen,
    required this.replayGameScreen,
    required this.achievements,
    required this.leaderboard,
    required this.recentGames,
    required this.replayListGames,
    required this.liveGames,
    required this.createDeckRoom,
    required this.showStartGameConfirmationDialog,
    required this.showLeaderboard,
    required this.showAchievements,
    required this.focusedGamedIndex,
    required this.focusGamedIndex,
    required this.hasInternet,
    required this.registerConnectivityListener,
    required this.showNoWifiErrorDialog,
    required this.roomReconnectInfo,
    required this.reconnectToGameRoom,
    required this.removeReconnectRoom,
    required this.showNoWifiCreateRoomDialog,
  });

  factory InteractiveHomeScreenViewModel.create(Store<AppState> store) {
    final userEntity = store.state.userState.user;

    appStart(lifecycleListener) {
      store.dispatch(middlewareLoadAppForUser());
      store.dispatch(middlewareRegisterLifecycleListener(lifecycleListener));
      store.dispatch(middlewareVerifyUserPermissionLocalNetwork());
      store.dispatch(middlewareReconnectToGameData());
    }

    onResume() {
      store.dispatch(middlewareRoomOnResume());
    }

    showUserProfile() {
      final userId = userEntity?.getKey();
      if (userId != null) {
        final Map<String, dynamic> args = {
          UserProfileScreenWidget.userIdKey: userId
        };
        store.dispatch(middlewareRouteUserProfile(args));
      }
    }

    showHelpConnect() {
      store.dispatch(middlewareRouteHelpConnect());
    }

    roomConnect([Map<String, dynamic> args = const {}]) {
      store.dispatch(middlewareRouteConnectRoom(args: args));
    }

    gameListScreen([Map<String, dynamic> args = const {}]) {
      store.dispatch(middlewareRouteGamesList(args));
    }

    replayListScreen([Map<String, dynamic> args = const {}]) {
      store.dispatch(middlewareRouteReplayGamesList(args));
    }

    replayGameScreen([Map<String, dynamic> args = const {}]) {
      store.dispatch(middlewareRouteReplayGame(args));
    }

    createDeckRoom(GameDetails details) {
      final args = {
        ...details.toMap(),
        ...{RoomCreateScreenWidget.hostIsTheDeckKey: true}
      };
      store.dispatch(middlewareRouteCreateRoom(args: args));
    }

    showStartGameConfirmationDialog(GameDetails details) {
      final args = {
        StartGameConfirmationDialogWidget.gameDetailsKey: details,
      };
      store.dispatch(middlewareShowStartGameConfirmationDialog(args: args));
    }

    showLeaderboard([Map<String, dynamic> args = const {}]) {
      store.dispatch(middlewareShowLeaderboard(args));
    }

    showAchievements([Map<String, dynamic> args = const {}]) {
      store.dispatch(middlewareShowAchievements(args));
    }

    final homeScreenState = store.state.homeScreenState;

    final leaderboard = homeScreenState.leaderboard;
    final games = homeScreenState.recentGames;
    final achievements = homeScreenState.achievements;

    final replay = homeScreenState.replayGames;

    //TODO: now are empty
    final live = homeScreenState.liveGames;

    //Support TV
    final focusedGamedIndex = homeScreenState.focusedGamedIndex;
    focusGamedIndex(int index) {
      store.dispatch(ChangeFocusGameIndexAction(index));
    }

    final hasInternet = homeScreenState.hasInternetConnection;
    registerConnectivityListener() {
      store.dispatch(middlewareRegisterConnectivityListener());
    }

    showNoWifiErrorDialog() {
      final args = {
        ErrorDialogWidget.typeKey: ErrorDialogType.noInternet,
      };
      store.dispatch(middlewareRouteErrorDialog(args));
    }

    final roomReconnectInfo = homeScreenState.reconnectToGameRoom;
    reconnectToGameRoom() {
      store.dispatch(middlewareRoomReconnect());
    }

    removeReconnectRoom() {
      store.dispatch(middlewareRemoveReconnectToGame());
    }

    showNoWifiCreateRoomDialog(NoNetworkRoomDialogState state,
        [GameDetails? details]) {
      final args = {
        NoNetworkRoomDialogScreenWidget.stateKey: state,
        NoNetworkRoomDialogScreenWidget.gameDetailsKey: details,
      };
      store.dispatch(middlewareShowNoNetworkRoomDialog(args));
    }

    return InteractiveHomeScreenViewModel(
      user: userEntity,
      appStart: appStart,
      onResume: onResume,
      showUserProfile: showUserProfile,
      showHelpConnect: showHelpConnect,
      roomConnect: roomConnect,
      gameListScreen: gameListScreen,
      replayListScreen: replayListScreen,
      replayGameScreen: replayGameScreen,
      achievements: achievements,
      leaderboard: leaderboard,
      recentGames: games,
      replayListGames: replay,
      liveGames: live,
      createDeckRoom: createDeckRoom,
      showStartGameConfirmationDialog: showStartGameConfirmationDialog,
      showLeaderboard: showLeaderboard,
      showAchievements: showAchievements,
      focusedGamedIndex: focusedGamedIndex,
      focusGamedIndex: focusGamedIndex,
      hasInternet: hasInternet,
      registerConnectivityListener: registerConnectivityListener,
      showNoWifiErrorDialog: showNoWifiErrorDialog,
      roomReconnectInfo: roomReconnectInfo,
      reconnectToGameRoom: reconnectToGameRoom,
      removeReconnectRoom: removeReconnectRoom,
      showNoWifiCreateRoomDialog: showNoWifiCreateRoomDialog,
    );
  }
}
