/*
 *
 * Copyright (c) 2023 TheDeck.com - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited 
 * Proprietary and confidential 
 *
 * Created on 2023-06-23 
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:the_deck/ui/style/dimmension_utils.dart';
import 'package:the_deck/utils/context_extension.dart';
import 'package:thedeck_common/the_deck_common.dart';

import '../../../../di/app_dependency.dart';
import '../../../../di/db/entity/game_log_entity.dart';
import '../../../../redux/app_state.dart';
import '../../../localisation/game_name_localisation.dart';
import '../../../style/color_utils.dart';
import '../../../widgets/title_toolbar_widget.dart';
import '../replay_game/replay_game_screen_widget.dart';
import 'replay_list_view_model.dart';
import 'replay_list_localisation.dart';

class ReplayListScreenWidget extends StatelessWidget {
  static const route = 'replay/replay_list';

  const ReplayListScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ReplayListViewModel>(
      converter: (Store<AppState> store) => ReplayListViewModel.create(store),
      onInitialBuild: (vm) => vm.loadReplayList(),
      builder: (BuildContext context, ReplayListViewModel vm) {
        final TextTheme textTheme = context.textTheme();
        final ReplayListLocalisation locale =
            ReplayListLocalisation(context.appLocalizations());
        final gameLocalization =
            GameNameLocalization(context.appLocalizations());
        final isTv = _isTvDevice(context);
        return Scaffold(
          extendBody: true,
          resizeToAvoidBottomInset: false,
          body: Scaffold(
            body: SafeArea(
              child: _buildBody(
                locale,
                vm,
                textTheme,
                gameLocalization,
                isTv,
              ),
            ),
          ),
        );
      },
    );
  }

  Column _buildBody(
    ReplayListLocalisation locale,
    ReplayListViewModel vm,
    TextTheme textTheme,
    GameNameLocalization gameLocalization,
    bool isTv,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        TitleToolbarWidget(
          title: locale.replay,
        ),
        Expanded(
          child: GridView.count(
            crossAxisCount: 3,
            children: List.generate(vm.replayList.length, (index) {
              final replay = vm.replayList[index];
              return _buildGridTile(
                vm,
                textTheme,
                gameLocalization,
                replay,
                isTv,
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildGridTile(
    ReplayListViewModel vm,
    TextTheme textTheme,
    GameNameLocalization gameLocalization,
    GameLogEntity replay,
    bool isTv,
  ) {
    final title =
        GamesListExtension.getById(replay.gameId)?.title(gameLocalization);
    return GestureDetector(
      onTap: () => vm.replayGameScreen(
        {ReplyGameScreeScreenWidget.gameLogIdKey: replay.id},
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(Dim.paddingSmall),
            child: Image.asset(
              _Constant.cardBackPlaceholder,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: Dim.paddingXSmall,
              bottom: Dim.paddingXSmall,
            ),
            color: AppColors.white.withOpacity(0.8),
            child: Text(
              title ?? gameLocalization.unknown,
              textAlign: TextAlign.center,
              style: textTheme.bodyLarge?.copyWith(
                color: AppColors.black,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  _isTvDevice(BuildContext context) {
    final deps = Provider.of<AppDependency>(context, listen: false);
    return deps.buildInfo.isTv;
  }
}

mixin _Constant {
  static const cardBackPlaceholder = 'assets/image/cards/back.jpg';
}
