/*
 * Copyright (c) 2023 TheDeck.com - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 *
 * Created on Tue Jan 10 2023
 */

import 'package:flutter/material.dart';
import 'package:thedeck_common/the_deck_common.dart';

import '../screens/achievements/achievements_screen_widget.dart';
import '../screens/error/error_dialog_widget.dart';
import '../screens/game_list/game_list_screen_widget.dart';
import '../screens/games/connect_four/connect_foud_screen_widget.dart';
import '../screens/games/dixit/dixit_leaderboard_screen_widget.dart';
import '../screens/games/dixit/dixit_map_screen_widget.dart';
import '../screens/games/dixit/dixit_screen_widget.dart';
import '../screens/games/mafia/mafia_screen_widget.dart';
import '../screens/help_connect/help_connect_widget.dart';
import '../screens/leaderbpard/leaderboard_screen_widget.dart';
import '../screens/leave_game_confirmation/leave_game_confirmation_dialog_widet.dart';
import '../screens/no_network_room/no_network_room_dialog_widget_widget.dart';
import '../screens/replay/replay_game/replay_game_screen_widget.dart';
import '../screens/replay/replay_list/replay_list_screen_widget.dart';
import '../screens/start_game_confirmation/start_game_confirmation_dialog_widet.dart';
import '../screens/games/tictactoe/tic_tac_toe_screen_widget.dart';
import '../screens/home/interactive_home_screen_widget.dart';
import '../screens/profile/user_profile_screen_widget.dart';
import '../screens/room/connect/room_connect_screen_widget.dart';
import '../screens/room/create/room_create_screen_widet.dart';
import '../screens/user_permission/user_permission_dialog_widget_widget.dart';
import '../screens/web_game/web_game_screen_widget.dart';
import '../widgets/full_screen_image.dart';
import 'material_dialog_page_router.dart';

mixin ApplicationRoutes {
  static const String isDialogKey = "isDialog";

  static RouteFactory factory() => (settings) {
        Widget? widget;
        final args = settings.arguments as Map<String, dynamic>?;
        switch (settings.name) {
          case InteractiveHomeScreen.route:
            widget = const InteractiveHomeScreen();
            break;
          case GameListScreenWidget.route:
            widget = const GameListScreenWidget();
            break;
          case ReplayListScreenWidget.route:
            widget = const ReplayListScreenWidget();
            break;
          case ReplyGameScreeScreenWidget.route:
            widget = ReplyGameScreeScreenWidget(arg: args);
            break;
          case WebGameScreenWidget.route:
            widget = const WebGameScreenWidget();
            break;
          case RoomCreateScreenWidget.route:
            if (args != null) {
              widget = RoomCreateScreenWidget(
                gameDetails: GameDetails.fromJson(args),
                hostIsTheDeck: args[RoomCreateScreenWidget.hostIsTheDeckKey],
              );
            } else {
              assert(
                  false, 'Need to provide game details for ${settings.name}');
            }
            break;
          case RoomConnectScreenWidget.route:
            widget = const RoomConnectScreenWidget();
            break;
          case TicTacToeScreenWidget.route:
            widget = const TicTacToeScreenWidget();
            break;
          case ConnectFourScreenWidget.route:
            widget = const ConnectFourScreenWidget();
            break;
          case DixitScreenWidget.route:
            widget = const DixitScreenWidget();
            break;
          case DixitLeaderboardDialogWidget.route:
            widget = DixitLeaderboardDialogWidget(
              arguments: args!,
            );
            break;
          case DixitMapDialogWidget.route:
            widget = DixitMapDialogWidget(
              arguments: args!,
            );
            break;
          case ErrorDialogWidget.route:
            widget = ErrorDialogWidget(
              arguments: args,
            );
            break;
          case StartGameConfirmationDialogWidget.route:
            widget = StartGameConfirmationDialogWidget(
              arguments: args!,
            );
            break;
          case UserProfileScreenWidget.route:
            widget = UserProfileScreenWidget(
              arguments: args!,
            );
            break;
          case LeaderboardScreenWidget.route:
            widget = const LeaderboardScreenWidget();
            break;
          case AchievementsScreenWidget.route:
            widget = const AchievementsScreenWidget();
            break;
          case FullScreenImageWidget.route:
            widget = FullScreenImageWidget.fromMap(args: args!);
            break;
          case LeaveGameConfirmationDialogWidget.route:
            widget = const LeaveGameConfirmationDialogWidget();
            break;
          case HelpConnectScreenWidget.route:
            widget = const HelpConnectScreenWidget();
            break;
          case UserPermissionDialogScreenWidget.route:
            widget = const UserPermissionDialogScreenWidget();
            break;
          case NoNetworkRoomDialogScreenWidget.route:
            widget = NoNetworkRoomDialogScreenWidget(
              arguments: args,
            );
            break;
          case MafiaScreenWidget.route:
            widget = const MafiaScreenWidget();
            break;
        }
        if (widget == null) {
          assert(false, 'Need to implement ${settings.name}');
        } else {
          if (args?[isDialogKey] == true) {
            return MaterialDialogPageRoute(
              settings: settings,
              builder: (context) {
                return widget!;
              },
            );
          } else {
            return MaterialPageRoute(
              settings: settings,
              builder: (context) {
                return widget!;
              },
            );
          }
        }
      };
}
