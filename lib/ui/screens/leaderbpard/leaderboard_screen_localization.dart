/*
 *
 *  *
 *  * Created on 23 4 2023
 *
 */

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LeaderboardLocalisation {

  final AppLocalizations localizations;

  LeaderboardLocalisation(this.localizations);

  get leaderboard => localizations.leaderboard;

  yourScore(name) => localizations.yourScore(name);

}