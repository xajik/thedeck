/*
 *
 *  *
 *  * Created on 12 4 2023
 *
 */

import 'package:flutter/material.dart';
import 'package:the_deck/ui/screens/games/dixit/dixit_screen_view_model.dart';
import 'package:the_deck/utils/context_extension.dart';
import 'package:thedeck_common/the_deck_common.dart';

import 'dixit_screen_localisation.dart';

class DixitLeaderboardDialogWidget extends StatelessWidget {
  static const route = "game/dixit/leaderboard";
  static const vmKey = "vm";
  final DixitScreenViewModel vm;

  DixitLeaderboardDialogWidget(
      {Key? key, required Map<String, dynamic> arguments})
      : vm = arguments[DixitLeaderboardDialogWidget.vmKey],
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = context.textTheme();
    final localisation = DixitScreenLocalisatoin(context.appLocalizations());
    return GestureDetector(
      onTap: () {
        //Prevent from closing the dialog
      },
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(_Constants.dialogCorner),
        ),
        title: Text(
          localisation.leaderboard,
          style: context.textTheme().titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...vm.players
                .map((e) => _buildPlayerRow(e, textTheme,
                    vm.gameField?.gameScore ?? {}, vm, localisation))
                .toList(),
            Padding(
              padding: const EdgeInsets.only(top: _Constants.paddingDefault),
              child: Text(
                localisation.scoreToWin(_Constants.scoreToWin),
                textAlign: TextAlign.left,
                style: context.textTheme().titleMedium,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPlayerRow(
    DixitGamePlayer e,
    TextTheme textTheme,
    Map<String, int> gameScore,
    DixitScreenViewModel vm,
    DixitScreenLocalisatoin localisation,
  ) {
    return Row(
      children: [
        Expanded(
          child: Text(
            vm.userNickName(e.userId) ?? localisation.unknown,
            style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Text(
          gameScore[e.userId]?.toString() ?? "0",
          style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

mixin _Constants {
  static const double dialogCorner = 8.0;

  static const paddingDefault = 16.0;

  static const scoreToWin = 30;
}
