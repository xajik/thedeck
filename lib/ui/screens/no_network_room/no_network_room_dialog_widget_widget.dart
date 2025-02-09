/*
 *
 * Copyright (c) 2023 TheDeck.com - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited 
 * Proprietary and confidential 
 *
 * Created on 2023-06-23 
 */

import 'package:dpad_container/dpad_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:the_deck/utils/context_extension.dart';
import 'package:thedeck_common/the_deck_common.dart';

import '../../../di/app_dependency.dart';
import '../../../redux/app_state.dart';
import '../../style/color_utils.dart';
import '../../style/dimmension_utils.dart';
import '../../widgets/custom_elevated_button.dart';
import 'no_network_room_dialog_widget_view_model.dart';
import 'no_network_room_dialog_widget_localisation.dart';

enum NoNetworkRoomDialogState {
  create,
  connect,
}

class NoNetworkRoomDialogScreenWidget extends StatelessWidget {
  static const route = '/no_network_room_dialog_widget';
  static const stateKey = "state";
  static const gameDetailsKey = "gameDetails";

  final NoNetworkRoomDialogState _state;
  final GameDetails? _gameDetails;

  NoNetworkRoomDialogScreenWidget(
      {Key? key, required Map<String, dynamic>? arguments})
      : _state = arguments?[stateKey] ?? NoNetworkRoomDialogState.create,
        _gameDetails = arguments?[gameDetailsKey],
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, NoNetworkRoomDialogViewModel>(
      converter: (Store<AppState> store) =>
          NoNetworkRoomDialogViewModel.create(store),
      builder: (BuildContext context, NoNetworkRoomDialogViewModel vm) {
        final TextTheme textTheme = context.textTheme();
        final NoNetworkRoomDialogLocalisation locale =
            NoNetworkRoomDialogLocalisation(context.appLocalizations());

        onClickCreate() {
          Navigator.pop(context);
          if (_state == NoNetworkRoomDialogState.create) {
            final details = _gameDetails;
            if (details == null) {
              vm.showGenericError();
            } else {
              if (_isTvDevice(context)) {
                vm.createRoom(details);
              } else {
                vm.gameConfirmationDialog(details);
              }
            }
          } else if (_state == NoNetworkRoomDialogState.connect) {
            vm.connectToRoom();
          }
        }

        onClickPop() {
          Navigator.pop(context);
        }

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dim.dialogCornerRadius),
          ),
          title: Text(
            locale.createRoom,
            style: context
                .textTheme()
                .titleMedium
                ?.copyWith(color: AppColors.black, fontWeight: FontWeight.bold),
          ),
          content: Text(
            locale.makeSureYouAreConnected,
            style: textTheme.titleSmall?.copyWith(color: AppColors.black),
          ),
          actions: <Widget>[
            DpadContainer(
              onClick: onClickCreate,
              onFocus: (focus) {},
              child: CustomElevatedButton.disabled(
                width: _Constants.buttonWidth,
                onPressed: onClickCreate,
                child: Text(
                  (_state == NoNetworkRoomDialogState.create
                          ? locale.create
                          : locale.connect)
                      .toUpperCase(),
                  style: textTheme.labelLarge?.copyWith(color: AppColors.white),
                ),
              ),
            ),
            DpadContainer(
              onClick: onClickPop,
              onFocus: (focus) {},
              child: CustomElevatedButton(
                  width: _Constants.buttonWidth,
                  onPressed: onClickPop,
                  child: Text(
                    locale.cancel.toUpperCase(),
                    style:
                        textTheme.labelLarge?.copyWith(color: AppColors.white),
                  )),
            ),
          ],
        );
      },
    );
  }

  _isTvDevice(BuildContext context) {
    final deps = Provider.of<AppDependency>(context, listen: false);
    return deps.buildInfo.isTv;
  }
}

mixin _Constants {
  static const double buttonWidth = 120;
}
