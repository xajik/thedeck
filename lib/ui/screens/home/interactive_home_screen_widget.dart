/*
 *
 *  *
 *  * Created on 2 4 2023
 *
 */

import 'package:dpad_container/dpad_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';
import 'package:the_deck/di/app_dependency.dart';
import 'package:the_deck/di/db/entity/user_entity.dart';
import 'package:the_deck/di/device_type.dart';
import 'package:the_deck/dto/achievement_dto.dart';
import 'package:the_deck/ui/localisation/game_name_localisation.dart';
import 'package:the_deck/ui/style/color_utils.dart';
import 'package:the_deck/ui/widgets/custom_elevated_button.dart';
import 'package:the_deck/utils/context_extension.dart';
import 'package:thedeck_common/the_deck_common.dart';

import '../../../di/db/entity/user_profile_entity.dart';
import '../../../dto/rank_dto.dart';
import '../../../redux/app_state.dart';
import '../../../redux/middleware/reduxt_middleware_lifecycle.dart';
import '../../localisation/achievement_localisation.dart';
import '../../localisation/rank_localisation.dart';
import '../../style/custom_style_utils.dart';
import '../../style/dimmension_utils.dart';
import '../../widgets/tween_icon_widget.dart';
import '../no_network_room/no_network_room_dialog_widget_widget.dart';
import '../replay/replay_game/replay_game_screen_widget.dart';
import 'interactive_home_screen_localisation.dart';
import 'interactive_home_screen_view_model..dart';

//singleton
Function(AppLifecycleState state)? _lifecycleListener;

class InteractiveHomeScreen extends StatelessWidget {
  static const route = '/';

  const InteractiveHomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, InteractiveHomeScreenViewModel>(
      converter: (Store<AppState> store) =>
          InteractiveHomeScreenViewModel.create(store),
      onInitialBuild: (vm) {
        lifecycleListener(AppLifecycleState state) {
          if (state == AppLifecycleState.resumed) {
            vm.onResume();
          }
        }

        _lifecycleListener = lifecycleListener;
        vm.appStart(lifecycleListener);
        //Wifi listener
        vm.registerConnectivityListener();
      },
      onDispose: (store) {
        final lifecycleListener = _lifecycleListener;
        if (lifecycleListener != null) {
          store.dispatch(middlewareRemoveLifecycleListener(lifecycleListener));
        }
      },
      builder: (BuildContext context, InteractiveHomeScreenViewModel vm) {
        final TextTheme textTheme = context.textTheme();
        final locale =
            InteractiveHomeScreenLocalization(context.appLocalizations());
        final rankLocale = RankLocalization(context.appLocalizations());
        final achievementsLocale =
            AchievementLocalization(context.appLocalizations());
        final gameNamelocale = GameNameLocalization(context.appLocalizations());
        final canConnectToTheRoom = _canConnectToTheRoom(context);
        return Scaffold(
          extendBody: true,
          resizeToAvoidBottomInset: false,
          body: Scaffold(
            backgroundColor: AppColors.white,
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBody(
                    textTheme,
                    locale,
                    vm,
                    rankLocale,
                    achievementsLocale,
                    gameNamelocale,
                    canConnectToTheRoom,
                  ),
                  canConnectToTheRoom
                      ? _buildButtonsRow(textTheme, locale, vm, context)
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(
    TextTheme textTheme,
    InteractiveHomeScreenLocalization locale,
    InteractiveHomeScreenViewModel vm,
    RankLocalization rankLocale,
    AchievementLocalization achievementsLocale,
    GameNameLocalization gameNamelocale,
    bool canConnectToTheRoom,
  ) {
    final body = SingleChildScrollView(
      child: Column(
        children: [
          _buildUserHeader(
            textTheme,
            locale,
            vm,
            rankLocale,
            canConnectToTheRoom,
          ),
          canConnectToTheRoom
              ? _buildAchievementsPreviewList(
                  textTheme,
                  achievementsLocale,
                  vm,
                )
              : const SizedBox.shrink(),
          canConnectToTheRoom
              ? _buildLeaderboardHeader(textTheme, locale, vm)
              : const SizedBox.shrink(),
          _buildPopularGamesHeader(
            textTheme,
            vm,
            locale,
            gameNamelocale,
            canConnectToTheRoom,
          ),
          vm.replayListGames.isEmpty
              ? const SizedBox.shrink()
              : _buildReplayGamesHeader(
                  textTheme,
                  vm,
                  locale,
                  gameNamelocale,
                  canConnectToTheRoom,
                ),
        ],
      ),
    );
    final reconnectRoom = vm.roomReconnectInfo;
    if (reconnectRoom != null) {
      return Expanded(
        child: Stack(
          children: [
            body,
            Container(
              alignment: Alignment.bottomCenter,
              padding: const EdgeInsets.only(
                bottom: _Constants.paddingXSmall,
              ),
              child: _roomReconnectButton(vm, locale, textTheme),
            ),
          ],
        ),
      );
    }
    return Expanded(
      child: body,
    );
  }

  Widget _roomReconnectButton(InteractiveHomeScreenViewModel vm,
      InteractiveHomeScreenLocalization locale, TextTheme textTheme) {
    return GestureDetector(
      onTap: () => vm.reconnectToGameRoom(),
      child: Container(
        height: _Constants.reconnectHeight,
        padding: const EdgeInsets.only(
          left: _Constants.padding,
        ),
        decoration: BoxDecoration(
          color: AppColors.indigo,
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              locale.reconnect,
              style: textTheme.bodyMedium?.copyWith(color: AppColors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(left: _Constants.paddingSmall),
              child: CircleAvatar(
                radius: _Constants.padding,
                backgroundColor: AppColors.white.withAlpha(70),
                child: IconButton(
                  iconSize: _Constants.padding,
                  onPressed: () => vm.removeReconnectRoom(),
                  splashRadius: _Constants.reconnectHeight,
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserHeader(
    TextTheme textTheme,
    InteractiveHomeScreenLocalization locale,
    InteractiveHomeScreenViewModel vm,
    RankLocalization rankLocale,
    bool canConnectToTheRoom,
  ) {
    final user = vm.user;
    var image = user?.image;
    return Container(
      margin: const EdgeInsets.all(_Constants.padding),
      padding: const EdgeInsets.all(_Constants.paddingSmall),
      decoration: gradientRoundedBoxDecoration(),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.white,
                width: _Constants.iconBorderWidth,
              ),
            ),
            child: CircleAvatar(
              backgroundImage: image == null
                  ? Image.asset(_Constants.imageDefaultAvatar).image
                  : NetworkImage(image),
              radius: _Constants.iconRadius,
              backgroundColor: AppColors.white,
            ),
          ),
          const SizedBox(width: _Constants.paddingSmall),
          canConnectToTheRoom
              ? _userHeaderStatus(locale, user, textTheme, rankLocale)
              : Text(
                  "${locale.welcome} @ ${locale.theDeck}",
                  style: textTheme.titleLarge?.copyWith(color: AppColors.white),
                ),
          const Spacer(),
          canConnectToTheRoom
              ? IconButton(
                  icon: const Icon(
                    Icons.settings,
                    color: AppColors.white,
                  ),
                  onPressed: () => vm.showUserProfile(),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Column _userHeaderStatus(InteractiveHomeScreenLocalization locale,
      UserEntity? user, TextTheme textTheme, RankLocalization rankLocale) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          locale.hiYou(user?.nickName ?? locale.theDeck),
          style: textTheme.titleLarge?.copyWith(color: AppColors.white),
        ),
        const SizedBox(width: _Constants.paddingSmall),
        Text(
          RankExtension.getUserRanksFromScore(user?.score ?? 0)
              .title(rankLocale),
          style: textTheme.titleMedium?.copyWith(color: AppColors.white),
        ),
        Text(
          locale.yourScore(user?.score ?? 0),
          style: textTheme.bodySmall?.copyWith(color: AppColors.white),
        ),
      ],
    );
  }

  Widget _buildAchievementsPreviewList(
    TextTheme textTheme,
    AchievementLocalization locale,
    InteractiveHomeScreenViewModel vm,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: _Constants.padding),
          padding:
              const EdgeInsets.symmetric(horizontal: _Constants.paddingSmall),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                locale.achievements,
                style: textTheme.subtitle1?.copyWith(
                  color: AppColors.purpleDark,
                  fontWeight: FontWeight.bold,
                ),
              ),
              _viewAppButton(
                () => vm.showAchievements(),
                locale.viewAll,
                textTheme,
              )
            ],
          ),
        ),
        const SizedBox(height: _Constants.paddingSmall),
        SizedBox(
          height: _Constants.tileHeight,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: vm.achievements.length,
            physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics()),
            itemBuilder: (BuildContext context, int index) {
              final AchievementBadge achievement = vm.achievements[index];
              return SizedBox(
                width: _Constants.tileHeight,
                child: Padding(
                  padding:
                      const EdgeInsets.only(right: _Constants.paddingSmall),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: _Constants.tileAchievementIcon,
                        height: _Constants.tileAchievementIcon,
                        child: Image.asset(
                          achievement.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Text(
                        achievement.title(locale),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: textTheme.bodySmall?.copyWith(
                          color: AppColors.purpleDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderboardHeader(
    TextTheme textTheme,
    InteractiveHomeScreenLocalization locale,
    InteractiveHomeScreenViewModel vm,
  ) {
    if (vm.leaderboard.isEmpty) {
      return const SizedBox.shrink();
    }
    return Container(
      margin: const EdgeInsets.only(
        top: _Constants.paddingSmall,
        bottom: _Constants.paddingSmall,
        left: _Constants.padding,
        right: _Constants.padding,
      ),
      padding: const EdgeInsets.all(_Constants.padding),
      decoration: gradientRoundedBoxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                locale.leaderboard,
                style: textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
              _viewAppButton(
                () => vm.showLeaderboard(),
                locale.viewAll,
                textTheme,
                gradient: false,
              )
            ],
          ),
          const SizedBox(height: _Constants.paddingSmall),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: vm.leaderboard
                .take(3) //MAX 3 users on home page
                .map((e) => _buildLeaderboardUser(e, locale, textTheme))
                .toList(),
          ),
        ],
      ),
    );
  }

  _canConnectToTheRoom(BuildContext context) {
    final deps = Provider.of<AppDependency>(context, listen: false);
    return !deps.buildInfo.isTv;
  }
}

Widget _buildLeaderboardUser(
  UserProfileEntity user,
  InteractiveHomeScreenLocalization locale,
  TextTheme textTheme,
) {
  var userImage = user.image;
  return SizedBox(
    width: _Constants.tileAchievementIcon,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.white,
              width: _Constants.iconBorderWidth,
            ),
          ),
          child: CircleAvatar(
            backgroundColor: AppColors.white,
            backgroundImage: userImage == null
                ? Image.asset(_Constants.imageDefaultUser).image
                : NetworkImage(userImage),
            radius: _Constants.iconRadius * 0.75,
          ),
        ),
        Text(
          user.nickName,
          style: textTheme.bodyMedium?.copyWith(color: AppColors.white),
          textAlign: TextAlign.center,
          maxLines: 1,
        ),
        Text(
          locale.yourScore(user.score),
          style: textTheme.bodySmall?.copyWith(color: AppColors.white),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

Widget _buildPopularGamesHeader(
  TextTheme textTheme,
  InteractiveHomeScreenViewModel vm,
  InteractiveHomeScreenLocalization locale,
  GameNameLocalization gameNameLocale,
  bool canConnectToTheRoom,
) {
  final popularGames = vm.recentGames;
  return Column(
    children: [
      Container(
        margin: const EdgeInsets.symmetric(horizontal: _Constants.padding),
        padding:
            const EdgeInsets.symmetric(horizontal: _Constants.paddingSmall),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              locale.games,
              style: textTheme.titleLarge?.copyWith(
                color: AppColors.purpleDark,
              ),
            ),
            canConnectToTheRoom
                ? _viewAppButton(
                    () => vm.gameListScreen(),
                    locale.viewAll,
                    textTheme,
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
      const SizedBox(height: _Constants.paddingSmall),
      SizedBox(
        height: _Constants.tileHeight * 1.2,
        child: ListView.builder(
          padding: const EdgeInsets.only(left: 16.0),
          scrollDirection: Axis.horizontal,
          physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics()),
          itemCount: popularGames.length,
          itemBuilder: (BuildContext context, int index) {
            onClick() async {
              final details = popularGames[index].details;

              if (vm.hasInternet) {
                if (canConnectToTheRoom) {
                  vm.showStartGameConfirmationDialog(details);
                } else {
                  vm.createDeckRoom(details);
                }
              } else {
                _showNoWifiCreateRoomDialog(
                  vm,
                  NoNetworkRoomDialogState.create,
                  details,
                );
              }
            }

            final tile = GestureDetector(
              onTap: onClick,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: vm.focusedGamedIndex == index
                      ? Border.all(
                          color: AppColors.purpleDark,
                          width: 2.0,
                        )
                      : null,
                ),
                margin: const EdgeInsets.all(_Constants.paddingXSmall),
                padding: const EdgeInsets.all(_Constants.paddingXSmall),
                width: _Constants.tileHeight,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      popularGames[index].image,
                      fit: BoxFit.fitHeight,
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        top: _Constants.paddingXSmall,
                        bottom: _Constants.paddingXSmall,
                      ),
                      color: AppColors.white.withOpacity(0.9),
                      width: _Constants.tileAchievementIcon,
                      child: Text(
                        popularGames[index].title(gameNameLocale),
                        textAlign: TextAlign.center,
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
            );
            if (canConnectToTheRoom) {
              return tile;
            }
            return DpadContainer(
              onClick: onClick,
              onFocus: (bool isFocused) {
                if (isFocused) {
                  vm.focusGamedIndex(index);
                }
              },
              child: tile,
            );
          },
        ),
      ),
    ],
  );
}

Widget _buildReplayGamesHeader(
  TextTheme textTheme,
  InteractiveHomeScreenViewModel vm,
  InteractiveHomeScreenLocalization locale,
  GameNameLocalization gameNameLocale,
  bool canConnectToTheRoom,
) {
  final replayGames = vm.replayListGames;
  return Column(
    children: [
      Container(
        margin: const EdgeInsets.symmetric(horizontal: _Constants.padding),
        padding:
            const EdgeInsets.symmetric(horizontal: _Constants.paddingSmall),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              locale.replay,
              style: textTheme.titleLarge?.copyWith(
                color: AppColors.purpleDark,
              ),
            ),
            canConnectToTheRoom
                ? _viewAppButton(
                    () => vm.replayListScreen(),
                    locale.viewAll,
                    textTheme,
                  )
                : const SizedBox.shrink(),
          ],
        ),
      ),
      const SizedBox(height: _Constants.paddingSmall),
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.indigo.withOpacity(0.7),
              AppColors.purpleBright.withOpacity(0.7),
            ],
          ),
        ),
        height: _Constants.tileHeight * 1.2,
        child: ListView.builder(
          padding: const EdgeInsets.only(left: 16.0),
          scrollDirection: Axis.horizontal,
          physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics()),
          itemCount: replayGames.length,
          itemBuilder: (BuildContext context, int index) {
            final replayGame = replayGames[index];
            return GestureDetector(
              onTap: () => vm.replayGameScreen(
                {ReplyGameScreeScreenWidget.gameLogIdKey: replayGame.id},
              ),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: vm.focusedGamedIndex == index
                      ? Border.all(
                          color: AppColors.purpleDark,
                          width: 2.0,
                        )
                      : null,
                ),
                margin: const EdgeInsets.all(_Constants.paddingXSmall),
                padding: const EdgeInsets.all(_Constants.paddingXSmall),
                width: _Constants.tileHeight,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      _Constants.cardBackPlaceholder,
                      fit: BoxFit.fitHeight,
                    ),
                    Container(
                      padding: const EdgeInsets.only(
                        top: _Constants.paddingXSmall,
                        bottom: _Constants.paddingXSmall,
                      ),
                      color: AppColors.white.withOpacity(0.9),
                      width: _Constants.tileAchievementIcon,
                      child: Text(
                        GamesListExtension.getById(replayGame.gameId)
                                ?.title(gameNameLocale) ??
                            gameNameLocale.unknown,
                        textAlign: TextAlign.center,
                        style: textTheme.bodyMedium?.copyWith(
                          color: AppColors.black,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}

void _showWifiRequireErrorDialog(InteractiveHomeScreenViewModel vm) {
  vm.showNoWifiErrorDialog();
}

void _showNoWifiCreateRoomDialog(
  InteractiveHomeScreenViewModel vm, [
  NoNetworkRoomDialogState state = NoNetworkRoomDialogState.create,
  GameDetails? details,
]) {
  vm.showNoWifiCreateRoomDialog(state, details);
}

Widget _buildButtonsRow(
  TextTheme textTheme,
  InteractiveHomeScreenLocalization locale,
  InteractiveHomeScreenViewModel vm,
  BuildContext context,
) {
  return Container(
    margin: const EdgeInsets.all(_Constants.padding),
    padding: const EdgeInsets.only(
      top: _Constants.padding + _Constants.paddingXSmall,
      bottom: _Constants.padding,
      right: _Constants.padding,
      left: _Constants.padding,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(_Constants.borderRadius),
      color: AppColors.indigo.withOpacity(0.2),
    ),
    alignment: Alignment.center,
    child: Row(
      children: [
        Expanded(
          flex: 1,
          child: vm.hasInternet
              ? Container()
              : GestureDetector(
                  child: const AnimatedIconColor(iconData: Icons.wifi_rounded),
                  onTap: () => _showWifiRequireErrorDialog(vm),
                ),
        ),
        Expanded(
          flex: 4,
          child: CustomElevatedButton(
            onPressed: () async {
              if (vm.hasInternet) {
                vm.roomConnect();
              } else {
                _showNoWifiCreateRoomDialog(
                    vm, NoNetworkRoomDialogState.connect);
              }
            },
            width: _Constants.buttonWidth,
            height: _Constants.buttonHeight,
            icon: const Icon(Icons.connect_without_contact,
                color: AppColors.white),
            child: Text(
              locale.connect.toUpperCase(),
              style: textTheme.labelLarge?.copyWith(
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Center(
            child: IconButton(
              icon: const Icon(
                Icons.help,
                color: AppColors.white,
              ),
              onPressed: () => vm.showHelpConnect(),
            ),
          ),
        ),
      ],
    ),
  );
}

GestureDetector _viewAppButton(
  void Function() viewAllTap,
  String viewAllTitle,
  TextTheme textTheme, {
  bool gradient = true,
}) {
  return GestureDetector(
    onTap: viewAllTap,
    child: Container(
      padding: const EdgeInsets.symmetric(
        horizontal: _Constants.padding,
        vertical: _Constants.paddingSmall,
      ),
      decoration: BoxDecoration(
        gradient: gradient
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.indigo.withOpacity(0.85),
                  AppColors.purpleBright.withOpacity(0.95),
                ],
              )
            : null,
        color: gradient ? null : AppColors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(_Constants.borderRadiusSmall),
      ),
      child: Text(
        viewAllTitle,
        style: textTheme.bodySmall?.copyWith(
          color: Colors.white,
        ),
      ),
    ),
  );
}

mixin _Constants {
  static const padding = 16.0;
  static const paddingXSmall = 4.0;
  static const paddingSmall = 8.0;
  static const iconRadius = 36.0;
  static const reconnectHeight = 32.0;

  static const borderRadius = 16.0;
  static const borderRadiusSmall = 8.0;

  static const iconBorderWidth = 1.0;

  static const imageDefaultAvatar = "assets/image/default_avatar.png";
  static const imageDefaultUser = "assets/image/default_user.png";
  static const cardBackPlaceholder = 'assets/image/cards/back.jpg';

  static const tileHeight = 115.0;

  static const tileAchievementIcon = 86.0;

  static const buttonWidth = 200.0;
  static const buttonHeight = 48.0;
}
