/*
 *
 *  *
 *  * Created on 21 4 2023
 *
 */

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InteractiveHomeScreenLocalization {
  final AppLocalizations localizations;

  InteractiveHomeScreenLocalization(this.localizations);

  get games => localizations.games;

  get theDeck => localizations.theDeck;

  get createRoom => localizations.createRoom;

  get connectToRoom => localizations.connectToRoom;

  get connect => localizations.connect;

  String get leaderboard => localizations.leaderboard;

  String get welcome => localizations.welcome;

  String get replay => localizations.replay;

  hiYou(name) => localizations.hiYou(name);

  yourScore(name) => localizations.yourScore(name);

  get achievements => localizations.achievements;

  get viewAll => localizations.viewAll;

  get moreGames => localizations.moreGames;


  get wifiRequired => localizations.wifiRequired;

  get wifiRequiredWarning => localizations.wifiRequiredWarning;

  get reconnect => localizations.reconnect;
}
