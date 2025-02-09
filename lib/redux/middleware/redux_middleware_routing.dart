/*
 *
 *  *
 *  * Created on 30 3 2023
 *
 */

import 'package:redux_thunk/redux_thunk.dart';
import 'package:the_deck/ui/screens/start_game_confirmation/start_game_confirmation_dialog_widet.dart';

import '../../di/app_dependency.dart';
import '../../ui/screens/achievements/achievements_screen_widget.dart';
import '../../ui/screens/error/error_dialog_widget.dart';
import '../../ui/screens/leaderbpard/leaderboard_screen_widget.dart';
import '../app_state.dart';

ThunkActionWithExtraArgument<AppState, AppDependency> middlewareRouteWebView(
    [Map<String, dynamic> args = const {}]) {
  return (store, dependency) async {
    dependency.router.webGameScreen(args);
  };
}

ThunkActionWithExtraArgument<AppState, AppDependency>
    middlewareRouteCreateRoom({
  Map<String, dynamic> args = const {},
  bool replace = false,
}) {
  return (store, dependency) async {
    dependency.router.roomCreate(args: args, replace: replace);
  };
}

ThunkActionWithExtraArgument<AppState, AppDependency>
    middlewareRouteConnectRoom({
  Map<String, dynamic> args = const {},
  bool replace = false,
}) {
  return (store, dependency) async {
    dependency.router.roomConnect(args: args, replace: replace);
  };
}

ThunkActionWithExtraArgument<AppState, AppDependency> middlewareRouteGamesList(
    [Map<String, dynamic> args = const {}]) {
  return (store, dependency) async {
    dependency.router.gameListScreen(args);
  };
}

ThunkActionWithExtraArgument<AppState, AppDependency>
    middlewareRouteReplayGamesList([Map<String, dynamic> args = const {}]) {
  return (store, dependency) async {
    dependency.router.replayListScreen(args);
  };
}

ThunkActionWithExtraArgument<AppState, AppDependency> middlewareRouteReplayGame(
    [Map<String, dynamic> args = const {}]) {
  return (store, dependency) async {
    dependency.router.replayGameScreen(args);
  };
}

ThunkActionWithExtraArgument<AppState, AppDependency>
    middlewareRouteTicTacToeGame([Map<String, dynamic> args = const {}]) {
  return (store, dependency) async {
    dependency.router.ticTacToeGame(args);
  };
}

ThunkActionWithExtraArgument<AppState, AppDependency>
    middlewareRouteConnectFourGame([Map<String, dynamic> args = const {}]) {
  return (store, dependency) async {
    dependency.router.connectFourGame(args);
  };
}

ThunkActionWithExtraArgument<AppState, AppDependency> middlewareRouteDixitGame(
    [Map<String, dynamic> args = const {}]) {
  return (store, dependency) async {
    dependency.router.dixitGame(args);
  };
}

ThunkActionWithExtraArgument<AppState, AppDependency>
    middlewareRouteUserProfile([Map<String, dynamic> args = const {}]) {
  return (store, dependency) async {
    dependency.router.userProfileSettings(args);
  };
}

ThunkActionWithExtraArgument<AppState, AppDependency> middlewareShowLeaderboard(
    [Map<String, dynamic>? arguments]) {
  return (store, dependency) async {
    var router = dependency.router;
    router.leaderboard(arguments);
  };
}

ThunkActionWithExtraArgument<AppState, AppDependency>
    middlewareShowAchievements([Map<String, dynamic>? arguments]) {
  return (store, dependency) async {
    var router = dependency.router;
    router.achievements(arguments);
  };
}

ThunkActionWithExtraArgument<AppState, AppDependency>
    middlewareShowNoNetworkRoomDialog([Map<String, dynamic>? arguments]) {
  return (store, dependency) async {
    var router = dependency.router;
    router.noNetworkRoomDialog(arguments);
  };
}

ThunkActionWithExtraArgument<AppState, AppDependency>
    middlewareShowStartGameConfirmationDialog(
        {Map<String, dynamic> args = const {}, bool replace = false}) {
  return (store, dependency) async {
    var router = dependency.router;
    router.startGameConfirmationDialog(args: args, replace: replace);
  };
}

ThunkActionWithExtraArgument<AppState, AppDependency>
    middlewareRouteErrorDialog([Map<String, dynamic>? arguments]) {
  return (store, dependency) async {
    var router = dependency.router;
    router.errorDialogWidget(arguments);
  };
}

ThunkActionWithExtraArgument<AppState, AppDependency> middlewareRouterPop(
    [Map<String, dynamic> args = const {}]) {
  return (store, dependency) async {
    dependency.router.pop();
  };
}

ThunkActionWithExtraArgument<AppState, AppDependency>
    middlewareRouteHelpConnect([Map<String, dynamic> args = const {}]) {
  return (store, dependency) async {
    dependency.router.helpConnect(args);
  };
}

ThunkActionWithExtraArgument<AppState, AppDependency>
    middlewareRouteiOSAllowNetworkPermission(
        [Map<String, dynamic> args = const {}]) {
  return (store, dependency) async {
    dependency.router.allowLocalNetworkPermission(args);
  };
}

ThunkActionWithExtraArgument<AppState, AppDependency> middlewareRouteMafiaGame(
    [Map<String, dynamic> args = const {}]) {
  return (store, dependency) async {
    dependency.router.mafiaGame(args);
  };
}