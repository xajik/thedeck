/*
 *
 *  *
 *  * Created on 27 7 2023
 *
 */

import 'package:flutter/material.dart';

import 'base_game_view_model.dart';

abstract class BaseGameScreenWidget extends StatelessWidget {
  static const route = "game/tic-tac-toe";
  final bool canPop;

  const BaseGameScreenWidget({Key? key, required this.canPop})
      : super(key: key);

  Widget popBody({required BaseGameViewModel vm, required Widget child}) {
    return WillPopScope(
      onWillPop: () {
        if (canPop) {
          vm.disposeGame();
          return Future.value(true);
        }
        if (vm.isGameOver) {
          vm.disposeGame();
        } else {
          vm.showLeaveGameDialog();
        }
        return Future.value(vm.isGameOver);
      },
      child: child,
    );
  }
}
