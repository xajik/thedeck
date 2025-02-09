/*
 *
 *  *
 *  * Created on 17 1 2023
 *
 */

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:redux/redux.dart';
import 'package:the_deck/utils/context_extension.dart';
import 'package:thedeck_common/the_deck_common.dart';

import '../../../../redux/app_state.dart';
import '../../../../ui/widgets/title_toolbar_widget.dart';
import '../../../localisation/game_name_localisation.dart';
import '../../../widgets/custom_elevated_button.dart';
import 'room_connect_localizations.dart';
import 'room_connect_screen_view_model.dart';

class RoomConnectScreenWidget extends StatefulWidget {
  static const route = 'game/room/connect';

  const RoomConnectScreenWidget({Key? key}) : super(key: key);

  @override
  State<RoomConnectScreenWidget> createState() =>
      _RoomConnectScreenWidgetState();
}

class _RoomConnectScreenWidgetState extends State<RoomConnectScreenWidget> {
  final GlobalKey _qrKey = GlobalKey(debugLabel: _Constants.qrKey);
  MobileScannerController _cameraController = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, RoomConnectScreenViewModel>(
      converter: (Store<AppState> store) =>
          RoomConnectScreenViewModel.create(store),
      onInitialBuild: (vm) {
        vm.disconnectFromRoom();
        vm.updateWifiInfo();
        vm.requestCameraPermission();
      },
      builder: (BuildContext context, RoomConnectScreenViewModel vm) {
        final localization =
        RoomConnectLocalizations(context.appLocalizations());
        final gameNameLocalization =
        GameNameLocalization(context.appLocalizations());
        final textTheme = context.textTheme();
        return WillPopScope(
          onWillPop: () async {
            vm.disconnectFromRoom();
            return Future.value(true);
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TitleToolbarWidget(
                    title: localization.connectToRoom,
                  ),
                  _wifiNameRow(localization, vm, textTheme),
                  Text(
                    localization.connectToSameWifi,
                    textAlign: TextAlign.center,
                    style: textTheme.bodySmall,
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: vm.participants == null
                          ? _buildMobileScanner(vm)
                          : _buildParticipantList(
                        vm,
                        localization,
                        textTheme,
                        gameNameLocalization,
                      ),
                    ),
                  ),
                  _bottomText(vm, localization, textTheme),
                  _disconnectIfPossible(vm, localization),
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

  Widget _wifiNameRow(RoomConnectLocalizations localization,
      RoomConnectScreenViewModel vm, TextTheme textTheme) {
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

  Widget _disconnectIfPossible(RoomConnectScreenViewModel vm,
      RoomConnectLocalizations localization) {
    return vm.details != null
        ? CustomElevatedButton(
      onPressed: () {
        vm.disconnectFromRoom();
        _restartCamera();
      },
      child: Text(localization.disconnect),
    )
        : const SizedBox.shrink();
  }

  Padding _bottomText(RoomConnectScreenViewModel vm,
      RoomConnectLocalizations localization, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.only(
        left: _Constants.padding,
        right: _Constants.contentPadding,
        bottom: _Constants.bottomPadding,
      ),
      child: (vm.details != null)
          ? Text(
        localization.waitingForHost,
        textAlign: TextAlign.center,
        style: textTheme.titleLarge,
      )
          : Text(
        localization.scanCodeToConnect,
        textAlign: TextAlign.center,
        style: textTheme.titleLarge,
      ),
    );
  }

  Widget _buildMobileScanner(RoomConnectScreenViewModel vm) {
    return Container(
      constraints: const BoxConstraints(
          maxHeight: 512, maxWidth: 512, minHeight: 96, minWidth: 96),
      width: double.infinity,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double size = constraints.maxWidth;
          return Container(
            width: size,
            height: size,
            padding: const EdgeInsets.all(_Constants.contentPadding),
            child: MobileScanner(
              allowDuplicates: false,
              key: _qrKey,
              controller: _cameraController,
              onDetect: _onQRViewCreated(vm),
            ),
          );
        },
      ),
    );
  }

  _onQRViewCreated(RoomConnectScreenViewModel vm) {
    return (Barcode barcode, MobileScannerArguments? args) {
      final rawJson = barcode.rawValue;
      final details = vm.roomDetails(rawJson);
      if (details != null) {
        _cameraController.stop();
        _showConfirmationDialog(details, vm);
      }
    };
  }

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  void _restartCamera() {
    _cameraController.dispose();
    _cameraController = MobileScannerController();
    _cameraController.start();
  }

  Widget _buildParticipantList(RoomConnectScreenViewModel vm,
      RoomConnectLocalizations localization,
      TextTheme textTheme,
      GameNameLocalization gameNameLocalization,) {
    final game = GamesListExtension.getById(vm.details?.details.gameId ?? -1);
    String? gameTitle;
    if (game != null) {
      gameTitle = game.title(gameNameLocalization);
    } else {
      gameTitle = vm.details?.details.gameName;
    }

    final participants = vm.participants;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        gameTitle == null
            ? const SizedBox.shrink()
            : Text(
          localization.youJoinedGameRoom(gameTitle),
          style: textTheme.displayLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: _Constants.bottomPadding),
        Text(
          localization.participants,
          style: textTheme.titleLarge,
        ),
        participants?.isEmpty == true
            ? Text(localization.roomIsEmpty)
            : Flexible(
          child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: vm.participants?.length ?? 0,
              itemBuilder: (context, index) {
                return Center(
                    child: Text(
                      vm.participants?[index].profile.nickname ?? '',
                      style: textTheme.titleMedium,
                    ));
              }),
        ),
      ],
    );
  }

  void _showConfirmationDialog(RoomCreateDetails details,
      RoomConnectScreenViewModel vm) {
    final localization = RoomConnectLocalizations(context.appLocalizations());
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(localization.connectToRoom),
          content:
          Text(localization.doYouWantToConnect(details.details.gameName)),
          actions: [
            TextButton(
              onPressed: () {
                _restartCamera();
                vm.disconnectFromRoom();
                vm.popScreen();
              },
              child: Text(localization.cancel),
            ),
            TextButton(
              onPressed: () {
                vm.connect(details);
                vm.popScreen();
              },
              child: Text(localization.connect),
            ),
          ],
        );
      },
    );
  }
}

class _Constants {
  static const qrKey = 'QR';
  static const padding = 4.0;
  static const contentPadding = 16.0;
  static const bottomPadding = 36.0;
}
