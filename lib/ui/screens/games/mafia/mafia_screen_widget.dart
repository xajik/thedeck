/*
 *
 *  *
 *  * Created on 28 7 2023
 *  
 */

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:the_deck/ui/screens/games/base_game_screen_widget.dart';
import 'package:the_deck/utils/context_extension.dart';
import 'package:thedeck_common/the_deck_common.dart';

import '../../../../redux/app_state.dart';
import '../../../style/color_utils.dart';
import '../../../style/dimmension_utils.dart';
import '../../../widgets/custom_elevated_button.dart';
import '../../../widgets/title_toolbar_widget.dart';
import 'mafia_screen_view_model.dart';
import 'mafia_screen_localisation.dart';

class MafiaScreenWidget extends BaseGameScreenWidget {
  static const route = 'game/mafia_screen_widget';

  const MafiaScreenWidget({Key? key, bool canPop = false})
      : super(key: key, canPop: canPop);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, MafiaViewModel>(
      converter: (Store<AppState> store) => MafiaViewModel.create(store),
      builder: (BuildContext context, MafiaViewModel vm) {
        final TextTheme textTheme = context.textTheme();
        final MafiaLocalisation locale =
            MafiaLocalisation(context.appLocalizations());
        return popBody(
          vm: vm,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              bottom: false,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TitleToolbarWidget(
                      title: locale.title,
                    ),
                    Expanded(
                      child: _buildBody(vm, locale, textTheme),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(
    MafiaViewModel vm,
    MafiaLocalisation locale,
    TextTheme textTheme,
  ) {
    final gameField = vm.gameField;
    if (gameField == null) {
      return Center(
        child: Text(
          locale.loading,
          style: textTheme.headlineLarge?.copyWith(color: AppColors.black),
        ),
      );
    }

    final phase = gameField.round.phase;

    if (gameField.isGameOver) {
      Widget body = _buildGameOverBody(locale, textTheme);
      //TODO:Add action to restart the game
      return _composeBody(phase, textTheme, locale, vm, body, null);
    }

    List<Widget?> stateWidgets = List.empty();

    if (phase == MafiaGamePhase.night) {
      stateWidgets = _buildNightBody(vm, locale, textTheme, gameField);
    } else if (phase == MafiaGamePhase.night_summary) {
      stateWidgets = _buildNightSummaryBody(vm, locale, textTheme, gameField);
    } else if (phase == MafiaGamePhase.day) {
      stateWidgets = _buildDayBody(vm, locale, textTheme, gameField);
    } else if (phase == MafiaGamePhase.day_summary) {
      stateWidgets = _buildDaySummaryBody(vm, locale, textTheme, gameField);
    }
    final body = stateWidgets.isNotEmpty ? stateWidgets[0] : null;
    final action = stateWidgets.length >= 2 ? stateWidgets[1] : null;
    if (body != null) {
      return _composeBody(phase, textTheme, locale, vm, body, action);
    }

    return Center(
      child: Text(
        locale.loading,
        style: textTheme.headlineLarge?.copyWith(color: AppColors.black),
      ),
    );
  }

  Widget _composeBody(
      MafiaGamePhase phase,
      TextTheme textTheme,
      MafiaLocalisation locale,
      MafiaViewModel vm,
      Widget body,
      Widget? action) {
    final phaseWidget = _phaseTitleWidget(phase, textTheme, locale);
    final roleRow = _roleRowWidget(vm, textTheme, locale);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: phaseWidget,
        ),
        roleRow,
        Expanded(child: body),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const SizedBox(width: 48),
            action ?? const SizedBox(width: 48),
            IconButton(
              icon: Icon(vm.showRoleVisible
                  ? Icons.remove_red_eye_rounded
                  : Icons.remove_red_eye_outlined),
              onPressed: () => vm.toggleShowRole(),
            ),
          ],
        ),
        const SizedBox(height: 48),
      ],
    );
  }

  Center _buildGameOverBody(MafiaLocalisation locale, TextTheme textTheme) {
    return Center(
      child: Text(
        locale.gameOver,
        style: textTheme.headlineLarge,
      ),
    );
  }

  Text _phaseTitleWidget(
    MafiaGamePhase phase,
    TextTheme textTheme,
    MafiaLocalisation locale,
  ) {
    final phaseWidget = Text(
      phase.summary(locale),
      textAlign: TextAlign.start,
      style: textTheme.bodyLarge?.copyWith(color: AppColors.black),
    );
    return phaseWidget;
  }

  Widget _roleRowWidget(
    MafiaViewModel vm,
    TextTheme textTheme,
    MafiaLocalisation locale,
  ) {
    final role = vm.player?.role;

    final isAlive =
        vm.gameField?.round.alivePlayers.contains(vm.player?.userId);

    final roleRow = Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dim.dialogCornerRadius),
          color: AppColors.indigo),
      child: Container(
        padding: const EdgeInsets.all(Dim.padding),
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(
                  backgroundColor: AppColors.white,
                  child: Icon(
                    Icons.person,
                    color: AppColors.purpleDark,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: Dim.paddingSmall),
                  child: Text(
                    vm.participant?.profile.nickname ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        textTheme.titleLarge?.copyWith(color: AppColors.white),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: Dim.paddingXSmall),
                  child: Text(
                    isAlive == true
                        ? "${locale.alive} ❤️"
                        : "${locale.dead} ☠️",
                    style:
                        textTheme.titleMedium?.copyWith(color: AppColors.white),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: Dim.paddingSmall),
              child: Row(
                children: [
                  Text(
                    "${locale.yourRole}: ",
                    style:
                        textTheme.titleMedium?.copyWith(color: AppColors.grey),
                  ),
                  Text(
                    vm.showRoleVisible
                        ? (role?.title(locale) ?? locale.hidden)
                        : locale.hidden,
                    style:
                        textTheme.titleMedium?.copyWith(color: AppColors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    return Padding(
      padding: const EdgeInsets.all(Dim.padding),
      child: roleRow,
    );
  }

  List<Widget?> _buildNightBody(
    MafiaViewModel vm,
    MafiaLocalisation locale,
    TextTheme textTheme,
    MafiaGameField gameField,
  ) {
    Widget? action;
    Widget? carousel;

    if (vm.userId == null) {
      action = const SizedBox.shrink();
    } else if (gameField.alivePlayers.contains(vm.userId) == false) {
      action = Text(
        locale.youAreDead,
        style: textTheme.titleMedium?.copyWith(color: AppColors.black),
      );
    } else if (gameField.round.nextMoveRole == vm.player?.role) {
      action = Center(
        child: CustomElevatedButton(
          onPressed: () => {
            vm.makeTurn(),
          },
          child: Text(
            vm.showRoleVisible
                ? vm.player?.role.ability.title(locale) ?? locale.doAction
                : locale.doAction,
            style: textTheme.titleMedium?.copyWith(color: AppColors.white),
          ),
        ),
      );
    } else {
      action = Text(
        "😴",
        style: textTheme.titleMedium?.copyWith(color: AppColors.black),
      );
    }

    final set = vm.gameField?.alivePlayers;
    if (set != null) {
      carousel = _baseCarousel(vm, child: _playersCards(set, vm, textTheme));
    }

    return [
      Column(
        children: [
          const SizedBox(height: Dim.padding),
          Expanded(child: carousel ?? const SizedBox.expand()),
          const SizedBox(height: Dim.padding),
        ],
      ),
      action
    ];
  }

  List<Widget>? _playersCards(
      Set<String> players, MafiaViewModel vm, TextTheme textTheme) {
    return players.map((e) {
      final p = vm.players.firstWhere((v) => v.userId == e);
      final c = vm.participants.firstWhere((v) => v.userId == e);
      return _playersCard(vm, p, c, textTheme);
    }).toList();
  }

  Widget _playersCard(
    MafiaViewModel vm,
    MafiaGamePlayer p,
    GameParticipant c,
    TextTheme textTheme,
  ) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Card(
        color: AppColors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dim.dialogCornerRadius * 2),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 48,
                backgroundColor: AppColors.white,
                child: Icon(
                  Icons.person,
                  color: AppColors.purpleDark,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(Dim.padding),
                child: Text(
                  c.profile.nickname,
                  style: textTheme.headlineSmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _baseCarousel(MafiaViewModel vm,
      {List<Widget>? child, enableInfiniteScroll = true}) {
    return CarouselSlider(
      options: CarouselOptions(
        aspectRatio: 16 / 9,
        enlargeFactor: 0.3,
        viewportFraction: 0.7,
        enlargeCenterPage: true,
        initialPage: 0,
        enableInfiniteScroll: enableInfiniteScroll,
        scrollDirection: Axis.horizontal,
        enlargeStrategy: CenterPageEnlargeStrategy.zoom,
        onPageChanged: (index, reason) {
          vm.carouselSelectPlayer(index);
        },
      ),
      items: child,
    );
  }

  List<Widget?> _buildNightSummaryBody(
    MafiaViewModel vm,
    MafiaLocalisation locale,
    TextTheme textTheme,
    MafiaGameField gameField,
  ) {
    var summary = "${locale.asOneMoreNightPass}\n";

    vm.gameField?.round.nightMoves.forEach((k, v) {
      if (v.isNotEmpty) {
        final affectedPlayers = v
            .map((e) => vm.participants.firstWhere((p) => p.userId == e))
            .map((e) => e.profile.nickname)
            .reduce((v, e) => "$v, $e");
        summary += "\n$affectedPlayers were ${k.title(locale)}. \n";
      }
    });

    Widget? action;
    if (vm.userId == null) {
      action = const SizedBox.shrink();
    } else {
      Center(
        child: CustomElevatedButton(
          onPressed: () => {
            vm.makeTurn(),
          },
          child: Text(
            locale.moveOn,
            style: textTheme.titleMedium?.copyWith(color: AppColors.white),
          ),
        ),
      );
    }
    return [
      Container(
        padding: const EdgeInsets.all(Dim.padding),
        alignment: Alignment.center,
        child: Text(
          summary,
          style: textTheme.headlineLarge?.copyWith(color: AppColors.black),
        ),
      ),
      action,
    ];
  }

  List<Widget> _buildDayBody(
    MafiaViewModel vm,
    MafiaLocalisation locale,
    TextTheme textTheme,
    MafiaGameField gameField,
  ) {
    Widget? action;

    if (vm.userId == null) {
      action = const SizedBox.shrink();
    } else if (gameField.round.alivePlayers.contains(vm.userId)) {
      action = CustomElevatedButton(
        onPressed: () => {
          vm.makeTurn(),
        },
        child: Text(
          locale.vote,
          style: textTheme.titleMedium?.copyWith(color: AppColors.white),
        ),
      );
    } else {
      action = Text(
        "😵",
        style: textTheme.titleMedium?.copyWith(color: AppColors.black),
      );
    }

    Widget? carousel;
    final set = vm.gameField?.round.playersToEliminate;
    if (set != null) {
      carousel = _baseCarousel(vm, child: _playersCards(set, vm, textTheme));
    }

    return [
      Column(
        children: [
          const SizedBox(height: Dim.padding),
          Expanded(child: carousel ?? const SizedBox.expand()),
          const SizedBox(height: Dim.padding),
        ],
      ),
      Center(child: action),
    ];
  }

  List<Widget?> _buildDaySummaryBody(
    MafiaViewModel vm,
    MafiaLocalisation locale,
    TextTheme textTheme,
    MafiaGameField gameField,
  ) {
    final votes = gameField.round.dayVotes;

    var summary = "${locale.citizensVoted}:\n";

    votes.map((k, v) {
      final n =
          vm.participants.firstWhere((p) => p.userId == k).profile.nickname;
      return MapEntry(n, v.length);
    }).forEach((k, v) {
      summary += "\n$v ${locale.votesFor} $k";
    });

    final eliminated = gameField.round.eliminatedPlayer;

    if (eliminated != null) {
      summary += "\n$eliminated ${locale.wasEliminated}";
    } else {
      summary += "\n${locale.noOneWasEliminated}";
    }

    Widget? action;
    if (vm.userId == null) {
      action = const SizedBox.shrink();
    } else {
      action = Center(
        child: CustomElevatedButton(
          onPressed: () => {},
          child: Text(
            gameField.round.eliminatedPlayer != null
                ? locale.voteAgain
                : locale.goToTheNextRound,
            style: textTheme.titleMedium?.copyWith(color: AppColors.white),
          ),
        ),
      );
    }

    return [
      Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(Dim.padding),
              child: Text(
                summary,
                style: textTheme.titleMedium?.copyWith(color: AppColors.black),
              ),
            ),
          ),
          action,
        ],
      )
    ];
  }
}
