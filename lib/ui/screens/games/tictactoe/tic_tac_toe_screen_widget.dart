/*
 *
 *  *
 *  * Created on 11 3 2023
 *
 */

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:thedeck_common/the_deck_common.dart';

import '../../../../utils/context_extension.dart';
import '../../../../redux/app_state.dart';
import '../../../../ui/widgets/title_toolbar_widget.dart';
import '../../../style/color_utils.dart';
import '../base_game_screen_widget.dart';
import 'tic_tac_toe_localisation.dart';
import 'tic_tac_toe_screen_view_model.dart';

class TicTacToeScreenWidget extends BaseGameScreenWidget {
  static const route = "game/tic-tac-toe";

  const TicTacToeScreenWidget({Key? key, bool canPop = false})
      : super(key: key, canPop: canPop);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, TicTacToeScreenViewModel>(
      converter: (Store<AppState> store) =>
          TicTacToeScreenViewModel.create(store),
      builder: (BuildContext context, TicTacToeScreenViewModel vm) {
        final TextTheme textTheme = context.textTheme();
        final localization =
            TicTacToeScreenLocalization(context.appLocalizations());
        return popBody(
          vm: vm,
          child: Scaffold(
            extendBody: true,
            resizeToAvoidBottomInset: false,
            body: SafeArea(
              bottom: false,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TitleToolbarWidget(title: localization.ticTacToe),
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

  Widget _buildField(TicTacToeScreenViewModel vm) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (j) {
            return GestureDetector(
              onTap: () {
                vm.makeTurn(i, j);
              },
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Center(
                  child: _buildFieldElement(vm, i, j),
                ),
              ),
            );
          }),
        );
      }),
    );
  }

  Widget _buildFieldElement(TicTacToeScreenViewModel vm, int x, int y) {
    var field = vm.gameField;
    if (field == null) {
      return Container();
    }
    if (field.field[x][y] == _Constants._cross) {
      return const Icon(
        Icons.clear,
        size: _Constants.iconSize,
        color: AppColors.black,
      );
    } else if (field.field[x][y] == _Constants._zero) {
      return const Icon(
        Icons.circle,
        size: _Constants.iconSize,
        color: AppColors.black,
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget _buildStatus(TicTacToeScreenViewModel vm,
      TicTacToeScreenLocalization localisation, TextTheme textTheme) {
    var field = vm.gameField;
    if (field == null) {
      return Container();
    }
    if (field.isGameOver) {
      return Text(
        localisation.winnerIs(_winnerIs(field, localisation)),
        style: textTheme.titleLarge,
      );
    } else if (field.lastTurn == _Constants._empty) {
      return Text(localisation.startGame, style: textTheme.titleLarge);
    } else if (field.lastTurn == _Constants._cross) {
      final title = localisation.nextTurn(localisation.cross);
      return Text(title, style: textTheme.titleLarge);
    } else {
      final title = localisation.nextTurn(localisation.zero);
      return Text(title, style: textTheme.titleLarge);
    }
  }

  String _winnerIs(
          TicTacToeGameField field, TicTacToeScreenLocalization localisation) =>
      field.winner == _Constants._cross
          ? localisation.cross
          : field.winner == _Constants._zero
              ? localisation.zero
              : localisation.draw;
}

mixin _Constants {
  static const int _empty = TicTacToeGameField.empty;
  static const int _cross = TicTacToeGameField.cross;
  static const int _zero = TicTacToeGameField.zero;
  static const iconSize = 60.0;
}
