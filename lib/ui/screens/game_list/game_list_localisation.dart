/*
 * Copyright (c) 2023 TheDeck.com - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 *
 * Created on Tue Jan 10 2023
 */

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GameListLocalisation {

  final AppLocalizations localizations;

  GameListLocalisation(this.localizations);

  get availableGames => localizations.availableGames;

  get games => localizations.games;

  get webGame => localizations.webGame;

  get hostIsDeck => localizations.hostIsDeck;

  get start => localizations.start;

  get leaveGame => localizations.leaveGame;

  get areYouSureYouWantToLeave => localizations.areYouSureYouWantToLeave;

  get yes => localizations.yes;

  get no => localizations.no;

  startTheGame(gameName) => localizations.startTheGame(gameName);

}