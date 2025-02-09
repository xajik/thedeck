/*
 *
 * Copyright (c) 2023 TheDeck.com - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited 
 * Proprietary and confidential 
 *
 * Created on 2023-06-23 
 */

import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:the_deck/ui/screens/games/connect_four/connect_foud_screen_widget.dart';
import 'package:the_deck/ui/screens/games/dixit/dixit_screen_widget.dart';
import 'package:the_deck/ui/screens/games/mafia/mafia_screen_widget.dart';
import 'package:the_deck/ui/screens/games/tictactoe/tic_tac_toe_screen_widget.dart';
import 'package:the_deck/ui/widgets/title_toolbar_widget.dart';
import 'package:the_deck/utils/context_extension.dart';
import 'package:thedeck_common/the_deck_common.dart';

import '../../../../redux/app_state.dart';
import 'replay_game_screen_view_model.dart';
import 'replay_game_screen_localisation.dart';

class ReplyGameScreeScreenWidget extends StatelessWidget {
  static const route = 'replay/replay_game_screen';
  static const gameLogIdKey = 'gameLogIdKey';
  final int gameLogId;

  ReplyGameScreeScreenWidget({Key? key, required Map<String, dynamic>? arg})
      : gameLogId = arg?[gameLogIdKey] ?? -1,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ReplyGameScreeViewModel>(
      converter: (Store<AppState> store) =>
          ReplyGameScreeViewModel.create(store),
      onInitialBuild: (ReplyGameScreeViewModel vm) {
        vm.loadGameLog(gameLogId);
      },
      builder: (BuildContext context, ReplyGameScreeViewModel vm) {
        final TextTheme textTheme = context.textTheme();
        final ReplyGameScreeLocalisation locale =
            ReplyGameScreeLocalisation(context.appLocalizations());
        return WillPopScope(
          onWillPop: () {
            vm.onWillPop();
            vm.stopReplay();
            return Future.value(true);
          },
          child: Scaffold(
            body: _buildBody(vm, textTheme, locale),
          ),
        );
      },
    );
  }

  Widget _buildBody(
    ReplyGameScreeViewModel vm,
    TextTheme textTheme,
    ReplyGameScreeLocalisation locale,
  ) {
    final game = vm.gameLogEntity;
    if (game == null) {
      return _buildEmptyBody(vm, textTheme, locale, locale.loading);
    }
    Widget? gameWidget;
    if (GamesList.ticTacToe.id == game.gameId) {
      gameWidget = const TicTacToeScreenWidget(canPop: true);
    }
    if (GamesList.connectFour.id == game.gameId) {
      gameWidget = const ConnectFourScreenWidget(canPop: true);
    }
    if (GamesList.dixit.id == game.gameId) {
      gameWidget = const DixitScreenWidget(canPop: true);
    }
    if (GamesList.mafia.id == game.gameId) {
      gameWidget = const MafiaScreenWidget(canPop: true);
    }
    if (gameWidget != null) {
      return _buildGameBody(gameWidget, vm);
    }
    return _buildEmptyBody(vm, textTheme, locale, locale.error);
  }

  Widget _buildGameBody(Widget body, ReplyGameScreeViewModel vm) {
    return Column(
      children: [
        Expanded(child: body),
        _sliderWidget(vm),
      ],
    );
  }

  SizedBox _sliderWidget(ReplyGameScreeViewModel vm) {
    return SizedBox(
      height: _Constants.sliderHeight,
      child: Slider(
        max: vm.totalMoves.toDouble(),
        divisions: vm.totalMoves == 0 ? null : vm.totalMoves,
        value: vm.progress.toDouble(),
        onChanged: (double value) {},
      ),
    );
  }

  Widget _buildEmptyBody(
    ReplyGameScreeViewModel vm,
    TextTheme textTheme,
    ReplyGameScreeLocalisation locale,
    String title,
  ) {
    return SafeArea(
      child: Column(
        children: [
          TitleToolbarWidget(title: locale.replay),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                Text(
                  title,
                  style: textTheme.displayMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

mixin _Constants {
  static const sliderHeight = 96.0;
}
