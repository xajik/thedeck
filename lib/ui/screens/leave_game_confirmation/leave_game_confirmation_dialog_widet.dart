/*
 *
 *  *
 *  * Created on 1 4 2023
 *
 */

import 'package:dpad_container/dpad_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:the_deck/utils/context_extension.dart';

import '../../../redux/app_state.dart';
import '../../style/color_utils.dart';
import '../../widgets/custom_elevated_button.dart';
import '../game_list/game_list_localisation.dart';
import 'leave_game_onfirmation_view_model.dart';

class LeaveGameConfirmationDialogWidget extends StatefulWidget {
  static const route = "game/leave";

  const LeaveGameConfirmationDialogWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<LeaveGameConfirmationDialogWidget> createState() =>
      _LeaveGameConfirmationDialogWidgetState();
}

class _LeaveGameConfirmationDialogWidgetState
    extends State<LeaveGameConfirmationDialogWidget> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, LeaveGameConfirmationViewModel>(
      converter: (store) => LeaveGameConfirmationViewModel.fromStore(store),
      builder: (context, vm) {
        final textTheme = context.textTheme();
        final localisation = GameListLocalisation(context.appLocalizations());
        onClickLeave() {
          vm.leaveGame();
        }

        onClickPop() {
          Navigator.pop(context);
        }

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_Constants.dialogCorner),
          ),
          title: Text(
            localisation.leaveGame,
            style: context
                .textTheme()
                .titleMedium
                ?.copyWith(color: AppColors.black, fontWeight: FontWeight.bold),
          ),
          content: Text(
            localisation.areYouSureYouWantToLeave,
            style: textTheme.titleSmall?.copyWith(color: AppColors.black),
          ),
          actions: <Widget>[
            DpadContainer(
              onClick: onClickLeave,
              onFocus: (focus) {},
              child: CustomElevatedButton.disabled(
                width: _Constants.buttonWidth,
                onPressed: onClickLeave,
                child: Text(
                  localisation.yes.toUpperCase(),
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
                    localisation.no.toUpperCase(),
                    style:
                        textTheme.labelLarge?.copyWith(color: AppColors.white),
                  )),
            ),
          ],
        );
      },
    );
  }
}

mixin _Constants {
  static const double dialogCorner = 16.0;
  static const double buttonWidth = 96;
}
