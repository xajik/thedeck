/*
 *
 *  *
 *  * Created on 1 4 2023
 *
 */

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:provider/provider.dart';
import 'package:the_deck/utils/context_extension.dart';
import 'package:thedeck_common/the_deck_common.dart';

import '../../../di/app_dependency.dart';
import '../../../redux/app_state.dart';
import '../../style/color_utils.dart';
import '../../widgets/custom_elevated_button.dart';
import '../game_list/game_list_localisation.dart';
import 'start_game_confirmation_view_model.dart';

class StartGameConfirmationDialogWidget extends StatefulWidget {
  static const route = "game/confirmation";
  static const gameDetailsKey = "gameDetails";
  final GameDetails gameDetails;

  StartGameConfirmationDialogWidget({
    Key? key,
    required Map<String, dynamic> arguments,
  })  : gameDetails = arguments[gameDetailsKey],
        super(key: key);

  @override
  State<StartGameConfirmationDialogWidget> createState() =>
      _StartGameConfirmationDialogWidgetState();
}

class _StartGameConfirmationDialogWidgetState
    extends State<StartGameConfirmationDialogWidget> {
  bool? _hostIsTheDeck = false;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, StartGameConfirmationViewModel>(
      converter: (store) => StartGameConfirmationViewModel.fromStore(store),
      builder: (context, viewModel) {
        final analytics =
            Provider.of<AppDependency>(context, listen: false).analytics;
        final textTheme = context.textTheme();
        final localisation = GameListLocalisation(context.appLocalizations());
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_Constants.dialogCorner),
          ),
          title: Text(
            localisation.startTheGame(widget.gameDetails.gameName),
            style: context
                .textTheme()
                .titleMedium
                ?.copyWith(color: AppColors.black, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: [
                  Checkbox(
                    value: _hostIsTheDeck,
                    onChanged: (bool? value) {
                      setState(() {
                        _hostIsTheDeck = value;
                      });
                    },
                  ),
                  Text(localisation.hostIsDeck),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            CustomElevatedButton(
              width: _Constants.buttonWidth,
              child: Text(
                localisation.start.toUpperCase(),
                style: textTheme.button?.copyWith(color: AppColors.white),
              ),
              onPressed: () {
                Navigator.pop(context);
                final hostIfTheDeck = _hostIsTheDeck ?? false;
                analytics.reportGameSelected(
                  widget.gameDetails.gameId,
                  hostIfTheDeck,
                );
                viewModel.createRoom(widget.gameDetails, hostIfTheDeck);
              },
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
