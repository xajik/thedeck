/*
 * Copyright (c) 2023 TheDeck.com - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 *
 * Created on Tue Jan 10 2023
 */

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';
import 'package:the_deck/di/analytics.dart';
import 'package:the_deck/dto/game_dto.dart';
import 'package:the_deck/ui/localisation/game_name_localisation.dart';
import 'package:the_deck/di/device_type.dart';
import 'package:thedeck_common/the_deck_common.dart';
import '../../../di/app_dependency.dart';
import '../../style/color_utils.dart';
import '../../../utils/context_extension.dart';
import '../../../redux/app_state.dart';
import '../../widgets/title_toolbar_widget.dart';
import '../no_network_room/no_network_room_dialog_widget_widget.dart';
import 'game_list_localisation.dart';
import 'game_list_screen_view_model.dart';

class GameListScreenWidget extends StatelessWidget {
  static const route = "game/list";

  const GameListScreenWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, GameListScreenViewModel>(
      converter: (Store<AppState> store) =>
          GameListScreenViewModel.create(store),
      builder: (BuildContext context, GameListScreenViewModel vm) {
        final textTheme = context.textTheme();
        final localization = GameListLocalisation(context.appLocalizations());
        final gameLocalization =
            GameNameLocalization(context.appLocalizations());
        final isTv = _isTvDevice(context);
        return Scaffold(
          body: SafeArea(
            child:
                _buildBody(localization, isTv, vm, textTheme, gameLocalization),
          ),
        );
      },
    );
  }

  Column _buildBody(
      GameListLocalisation localization,
      isTv,
      GameListScreenViewModel vm,
      TextTheme textTheme,
      GameNameLocalization gameLocalization) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        TitleToolbarWidget(
          title: localization.games,
          actions: [
            ToolbarMenuAction(
              icon: Icons.connect_without_contact,
              onPressed: () {
                _canConnect(
                  isTv,
                  vm,
                  NoNetworkRoomDialogState.connect,
                );
              },
            ),
          ],
        ),
        Expanded(
          child: GridView.count(
            crossAxisCount: 3,
            children: List.generate(vm.games.length, (index) {
              final game = vm.games[index];
              return _buildGridTile(
                vm,
                localization,
                textTheme,
                gameLocalization,
                game,
                isTv,
              );
            }),
          ),
        ),
      ],
    );
  }

  void _canConnect(
      bool isTv, GameListScreenViewModel vm, NoNetworkRoomDialogState state,
      [GameDetails? details]) {
    if (vm.hasInternet) {
      if (state == NoNetworkRoomDialogState.create) {
        if (details == null) {
          vm.showGenericErrorDialog();
        } else if (isTv) {
          vm.createRoom(details);
        } else {
          vm.showStartGameConfirmationDialog(details);
        }
      } else {
        vm.roomConnect();
      }
    } else {
      vm.showNoWifiCreateRoomDialog(state, details);
    }
  }

  Widget _buildGridTile(
    GameListScreenViewModel vm,
    GameListLocalisation localization,
    TextTheme textTheme,
    GameNameLocalization gameLocalization,
    Game game,
    bool isTv,
  ) {
    return GestureDetector(
      onTap: () {
        _canConnect(
          isTv,
          vm,
          NoNetworkRoomDialogState.create,
          game.details,
        );
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(_Constants.padding),
            child: Image.asset(
              game.image,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: _Constants.paddingXSmall,
              bottom: _Constants.paddingXSmall,
            ),
            color: AppColors.white.withOpacity(0.9),
            child: Text(
              game.title(gameLocalization),
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

mixin _Constants {
  static const double padding = 8.0;
  static const paddingXSmall = 4.0;
}
