/*
 *
 *  *
 *  * Created on 11 3 2023
 *
 */

import 'package:flutter/material.dart';
import 'package:the_deck/di/logger.dart';
import 'package:the_deck/ui/screens/games/dixit/dixit_map_screen_widget.dart';
import 'package:the_deck/ui/screens/user_permission/user_permission_dialog_widget_widget.dart';

import '../screens/achievements/achievements_screen_widget.dart';
import '../screens/error/error_dialog_widget.dart';
import '../screens/game_list/game_list_screen_widget.dart';
import '../screens/games/connect_four/connect_foud_screen_widget.dart';
import '../screens/games/dixit/dixit_leaderboard_screen_widget.dart';
import '../screens/games/dixit/dixit_screen_widget.dart';
import '../screens/games/mafia/mafia_screen_widget.dart';
import '../screens/games/tictactoe/tic_tac_toe_screen_widget.dart';
import '../screens/help_connect/help_connect_widget.dart';
import '../screens/home/interactive_home_screen_widget.dart';
import '../screens/leaderbpard/leaderboard_screen_widget.dart';
import '../screens/leave_game_confirmation/leave_game_confirmation_dialog_widet.dart';
import '../screens/no_network_room/no_network_room_dialog_widget_widget.dart';
import '../screens/profile/user_profile_screen_widget.dart';
import '../screens/replay/replay_game/replay_game_screen_widget.dart';
import '../screens/replay/replay_list/replay_list_screen_widget.dart';
import '../screens/room/connect/room_connect_screen_widget.dart';
import '../screens/room/create/room_create_screen_widet.dart';
import '../screens/start_game_confirmation/start_game_confirmation_dialog_widet.dart';
import '../screens/web_game/web_game_screen_widget.dart';
import '../widgets/full_screen_image.dart';
import 'routes_factory.dart';

class ScreenRouter {
  final _root = InteractiveHomeScreen.route;

  final Logger logger;

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  ScreenRouter(this.logger);

  get key => _navigatorKey;

  _push(String path, [args]) {
    logger.d('push: $path', tag: _Constant.tag);
    _navigatorKey.currentState?.pushNamed(path, arguments: args);
  }

  _pushReplacement(String path, [args]) {
    logger.d('_pushReplacement: $path', tag: _Constant.tag);
    final currentPath = _getCurrentRouteName();
    if (currentPath == _root) {
      logger.d('_pushReplacement already at root, _push() instead: $path',
          tag: _Constant.tag);
      _push(path, args);
      return;
    }

    _navigatorKey.currentState?.pushReplacementNamed(path, arguments: args);
  }

  _pushDialog(String path, [Map<String, dynamic>? args]) {
    logger.d('_pushDialog: $path', tag: _Constant.tag);
    args = _setDialogRouter(args);
    _navigatorKey.currentState?.pushNamed(path, arguments: args);
  }

  _popUntil(List<String> routes) {
    var state = _navigatorKey.currentState;
    return state?.popUntil((route) {
      var name = route.settings.name;
      return routes.contains(name) || name == _root;
    });
  }

//region Games screens
  ticTacToeGame([Map<String, dynamic>? args]) {
    return _pushReplacement(
      TicTacToeScreenWidget.route,
      args,
    );
  }

  dixitGame([Map<String, dynamic>? args]) {
    return _pushReplacement(
      DixitScreenWidget.route,
      args,
    );
  }

  connectFourGame(Map<String, dynamic> args) {
    return _pushReplacement(
      ConnectFourScreenWidget.route,
      args,
    );
  }

  mafiaGame(Map<String, dynamic> args) {
    return _pushReplacement(
      MafiaScreenWidget.route,
      args,
    );
  }

//endregion

  dixitGameLeaderboard([Map<String, dynamic>? args]) {
    return _pushDialog(
      DixitLeaderboardDialogWidget.route,
      args,
    );
  }

  dixitGameMap([Map<String, dynamic>? args]) {
    return _pushDialog(
      DixitMapDialogWidget.route,
      args,
    );
  }

  gameListScreen([Map<String, dynamic>? args]) {
    return _push(
      GameListScreenWidget.route,
      args,
    );
  }

  replayListScreen([Map<String, dynamic>? args]) {
    return _push(
      ReplayListScreenWidget.route,
      args,
    );
  }

  replayGameScreen([Map<String, dynamic>? args]) {
    return _push(
      ReplyGameScreeScreenWidget.route,
      args,
    );
  }

  webGameScreen([Map<String, dynamic>? args]) {
    return _push(
      WebGameScreenWidget.route,
      args,
    );
  }

  roomCreate({Map<String, dynamic>? args, bool replace = false}) {
    if (replace) {
      return _pushReplacement(
        RoomCreateScreenWidget.route,
        args,
      );
    }
    return _push(
      RoomCreateScreenWidget.route,
      args,
    );
  }

  roomConnect({
    Map<String, dynamic> args = const {},
    bool replace = false,
  }) {
    if (replace) {
      return _pushReplacement(
        RoomConnectScreenWidget.route,
        args,
      );
    }
    return _push(
      RoomConnectScreenWidget.route,
      args,
    );
  }

  userProfileSettings(Map<String, dynamic> args) {
    return _push(
      UserProfileScreenWidget.route,
      args,
    );
  }

  achievements(Map<String, dynamic>? args) {
    return _push(
      AchievementsScreenWidget.route,
      args,
    );
  }

  leaderboard(Map<String, dynamic>? args) {
    return _push(
      LeaderboardScreenWidget.route,
      args,
    );
  }

  fullScreenImage(Map<String, dynamic>? args) {
    return _pushDialog(
      FullScreenImageWidget.route,
      args,
    );
  }

  startGameConfirmationDialog(
      {Map<String, dynamic>? args, bool replace = false}) {
    if (replace) {
      args = _setDialogRouter(args);
      return _pushReplacement(
        StartGameConfirmationDialogWidget.route,
        args,
      );
    }
    return _pushDialog(
      StartGameConfirmationDialogWidget.route,
      args,
    );
  }

  Map<String, dynamic> _setDialogRouter(Map<String, dynamic>? args) {
    final ars = {
      ...args ?? {},
    };
    ars[ApplicationRoutes.isDialogKey] = true;
    return ars;
  }

  noNetworkRoomDialog(Map<String, dynamic>? args) {
    return _pushDialog(
      NoNetworkRoomDialogScreenWidget.route,
      args,
    );
  }

  errorDialogWidget(Map<String, dynamic>? args) {
    return _pushDialog(
      ErrorDialogWidget.route,
      args,
    );
  }

  leaveGameDialog(Map<String, dynamic>? args) {
    return _pushDialog(
      LeaveGameConfirmationDialogWidget.route,
      args,
    );
  }

  helpConnect(Map<String, dynamic>? args) {
    return _push(
      HelpConnectScreenWidget.route,
      args,
    );
  }

  allowLocalNetworkPermission(Map<String, dynamic>? args) {
    return _pushDialog(
      UserPermissionDialogScreenWidget.route,
      args,
    );
  }

  popUntilHome() {
    return _navigatorKey.currentState?.popUntil((route) {
      return route.settings.name == _root;
    });
  }

  popFromAnyGame() {
    _popUntil([
      GameListScreenWidget.route,
    ]);
  }

  pop() {
    logger.d('pop ', tag: _Constant.tag);
    _navigatorKey.currentState?.maybePop();
  }

  String? _getCurrentRouteName() {
    String? currentPath;
    _navigatorKey.currentState?.popUntil((route) {
      currentPath = route.settings.name;
      return true;
    });
    return currentPath;
  }
}

mixin _Constant {
  static const String tag = 'ScreenRouter';
}
