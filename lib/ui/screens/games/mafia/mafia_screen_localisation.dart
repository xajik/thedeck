/*
 *
 *  *
 *  * Created on 28 7 2023
 *  
 */

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MafiaLocalisation {
  final AppLocalizations localizations;

  MafiaLocalisation(this.localizations);

  String get title => localizations.mafia;

  String get loading => localizations.loading;

  String get gameOver => localizations.gameOver;

  String get heal => localizations.heal;

  String get kill => localizations.kill;

  String get jail => localizations.jail;

  String get immunity => localizations.immunity;

  String get select => localizations.select;

  String get doAction => localizations.doAction;

  String get hidden => localizations.hidden;

  String get yourRole => localizations.yourRole;

  String get mafia => localizations.mafia;

  String get detective => localizations.detective;

  String get doctor => localizations.doctor;

  String get lawyer => localizations.lawyer;

  String get citizen => localizations.citizen;

  String get daySummaryPhaseDescription =>
      localizations.daySummaryPhaseDescription;

  String get dayPhaseDescription => localizations.dayPhaseDescription;

  String get nightPhaseDescription => localizations.nightPhaseDescription;

  String get nightSummaryPhaseDescription =>
      localizations.nightSummaryPhaseDescription;

  String get youAreDead => localizations.youAreDead;

  String get moveOn => localizations.moveOn;

  String get vote => localizations.vote;

  String get asOneMoreNightPass => localizations.asOneMoreNightPass;

  String get alive => localizations.alive;

  String get dead => localizations.dead;

  String get voteAgain => localizations.voteAgain;

  String get goToTheNextRound => localizations.goToTheNextRound;

  String get citizensVoted => localizations.citizensVoted;

  String get votesFor => localizations.votesFor;

  String get wasEliminated => localizations.wasEliminated;

  String get noOneWasEliminated => localizations.noOneWasEliminated;
}
