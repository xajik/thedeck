/*
 *
 *  *
 *  * Created on 11 3 2023
 *
 */

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TicTacToeScreenLocalization {
  final AppLocalizations localizations;

  TicTacToeScreenLocalization(this.localizations);

  get ticTacToe => localizations.ticTacToe;

  get zero => localizations.zero;

  get cross => localizations.cross;

  get draw => localizations.draw;

  winnerIs(winner) => localizations.theWinnerIs(winner);

  get startGame => localizations.startGame;

  nextTurn(player) => localizations.nextTurn(player);
}
