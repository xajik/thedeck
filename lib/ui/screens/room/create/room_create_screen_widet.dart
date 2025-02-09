/*
 *
 *  *
 *  * Created on 17 1 2023
 *
 */

import 'package:dpad_container/dpad_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:thedeck_common/the_deck_common.dart';

import '../../../../utils/context_extension.dart';
import '../../../../redux/app_state.dart';
import '../../../../ui/widgets/title_toolbar_widget.dart';
import '../../../localisation/game_name_localisation.dart';
import '../../../style/color_utils.dart';
import '../../../widgets/custom_elevated_button.dart';
import 'room_create_localization.dart';
import 'room_create_screen_view_model.dart';
import 'package:qr_flutter/qr_flutter.dart';

class RoomCreateScreenWidget extends StatelessWidget {
  static const String route = "game/room/create";
  static const String hostIsTheDeckKey = "hostIsTheDeck";

  final GameDetails gameDetails;
  final bool hostIsTheDeck;

  const RoomCreateScreenWidget({
    Key? key,
    required this.gameDetails,
    required this.hostIsTheDeck,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, RoomCreateViewModel>(
      converter: (Store<AppState> store) => RoomCreateViewModel.create(store),
      onInitialBuild: (vm) => vm.createRoom(gameDetails, hostIsTheDeck),
      builder: (BuildContext context, RoomCreateViewModel vm) {
        final localization = RoomCreateLocalization(context.appLocalizations());
        final gameNameLocalization =
            GameNameLocalization(context.appLocalizations());
        final textTheme = context.textTheme();
        return WillPopScope(
          onWillPop: () {
            vm.disposeRoom();
            return Future.value(true);
          },
          child: Scaffold(
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TitleToolbarWidget(
                    title: localization.createRoom,
                  ),
                  _wifiNameRow(localization, vm, textTheme),
                  Text(
                    localization.connectToSameWifi,
                    textAlign: TextAlign.center,
                    style: textTheme.bodySmall,
                  ),
                  Expanded(
                    child: qrCodeView(
                      vm,
                      localization,
                      textTheme,
                      gameNameLocalization,
                    ),
                  ),
                  const SizedBox(
                    height: _Constants.bottomPadding,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _wifiNameRow(RoomCreateLocalization localization,
      RoomCreateViewModel vm, TextTheme textTheme) {
    final wifiName = vm.wifiName;
    if (wifiName == null) {
      return const SizedBox.shrink();
    }
    return Text(
      localization.youWifi(wifiName),
      textAlign: TextAlign.center,
      style: textTheme.bodyMedium,
    );
  }

  Widget qrCodeView(
    RoomCreateViewModel vm,
    RoomCreateLocalization localization,
    TextTheme textTheme,
    GameNameLocalization gameNameLocalization,
  ) {
    final game = GamesListExtension.getById(gameDetails.gameId);
    String? gameTitle;
    if (game != null) {
      gameTitle = game.title(gameNameLocalization);
    } else {
      gameTitle = gameDetails.gameName;
    }

    final roomCreateDetails = vm.roomCreateDetails;
    if (roomCreateDetails == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(gameTitle, style: textTheme.displayLarge),
            Text(
              localization.loading,
              style: textTheme.bodyMedium,
            ),
          ],
        ),
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(gameDetails.gameName, style: textTheme.displayLarge),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(_Constants.padding),
            child: QrImage(
              data: roomCreateDetails.toJson(),
              version: QrVersions.auto,
            ),
          ),
        ),
        _buildStartGameWidget(vm, localization, textTheme),
        const SizedBox(
          height: _Constants.padding,
        ),
        _buildJoinedList(vm, localization, textTheme),
      ],
    );
  }

  Widget _buildStartGameWidget(RoomCreateViewModel vm,
      RoomCreateLocalization localization, TextTheme textTheme) {
    final onClick = vm.isReady == false
        ? null
        : () async {
            vm.startGame();
          };
    return DpadContainer(
      onClick: onClick ?? () {},
      onFocus: (bool isFocused) {},
      child: CustomElevatedButton(
        onPressed: onClick,
        child: Text(
          localization.start,
          style: textTheme.titleLarge?.copyWith(color: AppColors.white),
        ),
      ),
    );
  }

  _buildJoinedList(RoomCreateViewModel vm, RoomCreateLocalization localization,
      TextTheme textTheme) {
    return Flexible(
      fit: FlexFit.tight,
      flex: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            localization.participants,
            style: textTheme.titleLarge,
          ),
          vm.joinedList.isEmpty
              ? Text(localization.roomIsEmpty)
              : ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: vm.joinedList.length,
                  itemBuilder: (context, index) {
                    return Center(child: Text(vm.joinedList[index]));
                  }),
        ],
      ),
    );
  }
}

class _Constants {
  static const padding = 16.0;
  static const bottomPadding = 32.0;
}
