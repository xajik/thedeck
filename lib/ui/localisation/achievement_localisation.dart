/*
 *
 *  *
 *  * Created on 22 4 2023
 *
 */

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AchievementLocalization {
  final AppLocalizations localizations;

  AchievementLocalization(this.localizations);

  get achievements => localizations.achievements;

  get firstRun => localizations.firstRun;

  get firstGame => localizations.firstGame;

  get firstWin => localizations.firstWin;

  get firstWinTicTacToe => localizations.firstWinAt(localizations.ticTacToe);

  get firstWinConnectFour =>
      localizations.firstWinAt(localizations.connectFour);

  get firstWinDixit => localizations.firstWinAt(localizations.dixit);

  get first50Games => localizations.firstXGames(50);

  get first10Games => localizations.firstXGames(10);

  get first100Games => localizations.firstXGames(100);

  get first10Wins => localizations.firstXWins(10);

  get first50Wins => localizations.firstXWins(50);

  get first100Wins => localizations.firstXWins(100);

  get loading => localizations.loading;

  get viewAll => localizations.viewAll;
}
