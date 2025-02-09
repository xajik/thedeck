/*
 *
 *  *
 *  * Created on 1 4 2023
 *
 */

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConnectFourScreenLocalization {
  final AppLocalizations localizations;

  ConnectFourScreenLocalization(this.localizations);

  get connectFour => localizations.connectFour;

  get yellow => localizations.yellow;

  get red => localizations.red;

  get draw => localizations.draw;

  winnerIs(winner) => localizations.theWinnerIs(winner);

  get startGame => localizations.startGame;

  nextTurn(player) => localizations.nextTurn(player);
}
