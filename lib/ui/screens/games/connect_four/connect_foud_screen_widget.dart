/*
 *
 *  *
 *  * Created on 1 4 2023
 *
 */

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:the_deck/ui/screens/games/base_game_screen_widget.dart';
import 'package:the_deck/utils/context_extension.dart';
import 'package:thedeck_common/the_deck_common.dart';

import '../../../../redux/app_state.dart';
import '../../../widgets/title_toolbar_widget.dart';
import 'connect_four_localisation.dart';
import 'connect_four_screen_view_model.dart';

class ConnectFourScreenWidget extends BaseGameScreenWidget {
  static const route = "game/connect-four";

  const ConnectFourScreenWidget({Key? key, bool canPop = false})
      : super(key: key, canPop: canPop);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ConnectFourViewModel>(
      converter: (Store<AppState> store) => ConnectFourViewModel.create(store),
      builder: (BuildContext context, ConnectFourViewModel vm) {
        final TextTheme textTheme = context.textTheme();
        final localization =
            ConnectFourScreenLocalization(context.appLocalizations());
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
                      title: localization.connectFour,
                    ),
                    const Spacer(),
                    _buildField(vm),
                    const Spacer(),
                    _buildStatus(vm, localization, textTheme),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildField(ConnectFourViewModel vm) {
    var gameField = vm.gameField;
    if (gameField == null) {
      return Container();
    }
    final board = gameField.field;
    final rows = gameField.rows;
    final cols = gameField.cols;

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(rows, (row) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(cols, (col) {
              final value = board[row][col];
              Color? color;
              if (value == _Constants._red) {
                color = Colors.red;
              } else if (value == _Constants._yellow) {
                color = Colors.yellow;
              }
              return GestureDetector(
                onTap: () => vm.makeTurn(col),
                child: Container(
                  width: 40,
                  height: 40,
                  margin: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: color,
                    border: Border.all(
                      color: Colors.grey.shade500,
                      width: 2.0,
                    ),
                  ),
                ),
              );
            }),
          );
        }),
      ),
    );
  }

  Widget _buildStatus(ConnectFourViewModel vm,
      ConnectFourScreenLocalization localisation, TextTheme textTheme) {
    final field = vm.gameField;
    if (field == null) {
      return const SizedBox.shrink();
    }
    if (field.isGameOver) {
      return Text(localisation.winnerIs(_winnerIs(field, localisation)),
          style: const TextStyle(fontSize: 30));
    } else if (field.lastTurn == _Constants._empty) {
      return Text(localisation.startGame, style: textTheme.titleLarge);
    } else if (field.lastTurn == _Constants._yellow) {
      final title = localisation.nextTurn(localisation.red);
      return Text(title, style: textTheme.titleLarge);
    } else {
      final title = localisation.nextTurn(localisation.yellow);
      return Text(title, style: textTheme.titleLarge);
    }
  }

  String _winnerIs(ConnectFourGameField field,
          ConnectFourScreenLocalization localisation) =>
      field.winnerIsYellow
          ? localisation.yellow
          : field.isDraw
              ? localisation.draw
              : localisation.red;
}

mixin _Constants {
  static const int _empty = ConnectFourGameField.empty;
  static const int _yellow = ConnectFourGameField.yellow;
  static const int _red = ConnectFourGameField.red;
}
