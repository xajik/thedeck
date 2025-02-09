/*
 *
 *  *
 *  * Created on 6 5 2023
 *
 */

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:the_deck/utils/context_extension.dart';

import 'dixit_screen_localisation.dart';
import 'dixit_screen_view_model.dart';

class DixitMapDialogWidget extends StatelessWidget {
  static const route = "game/dixit/map";
  static const vmKey = "vm";
  static const roundKey = "round";
  final bool showRound;
  final DixitScreenViewModel vm;

  DixitMapDialogWidget({Key? key, required Map<String, dynamic> arguments})
      : vm = arguments[vmKey],
        showRound = arguments[roundKey] ?? false,
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
          style: textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.7,
            ),
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Wrap(
                spacing: _Constants.gridPadding,
                runSpacing: _Constants.gridPadding,
                children: List.generate(30, (index) {
                  final Map<String, int> inCell = {};
                  vm.gameField?.gameScore.forEach((key, value) {
                    if (value == index) inCell[key] = value;
                  });
                  return buildCell(context, inCell, vm, textTheme);
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCell(BuildContext context, Map<String, int> inCell,
      DixitScreenViewModel vm, TextTheme textTheme) {
    final count = inCell.length;
    var keys = inCell.keys.toList();
    final tileHeight =
        (MediaQuery.of(context).size.width - _Constants.gridPadding * 6) / 8;
    return Container(
      width: tileHeight,
      height: tileHeight,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.black,
          width: 1.0,
        ),
      ),
      child: count == 0
          ? Container()
          : count == 1
              ? CircleAvatar(
                  backgroundColor: Colors
                      .primaries[Random().nextInt(Colors.primaries.length)],
                  child: Text(
                    vm.userNickName(keys.first)?[0] ?? "",
                    style: textTheme.bodyText1?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                )
              : SizedBox.square(
                child: GridView.count(
                    crossAxisCount: 2,
                    children: List.generate(count, (i) {
                      return CircleAvatar(
                        backgroundColor: Colors
                            .primaries[Random().nextInt(Colors.primaries.length)],
                        child: Text(
                          vm.userNickName(keys[i])?[0] ?? "",
                          style: textTheme.bodyText1?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      );
                    }),
                  ),
              ),
    );
  }
}

mixin _Constants {
  static const double dialogCorner = 8.0;

  static const gridPadding = 4.0;
}
