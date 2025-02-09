/*
 *
 *  *
 *  * Created on 21 4 2023
 *
 */

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserProfileLocalisation {
  final AppLocalizations localizations;

  UserProfileLocalisation(this.localizations);

  get userProfile => localizations.userProfile;

  get save => localizations.save;

  String hiYou(String name) => localizations.hiYou(name);

  get theDeck => localizations.theDeck;

  yourScore(int score) => localizations.yourScore(score);

  get nickname => localizations.nickname;

  get onlyAlphanumeric => localizations.onlyAlphanumeric;

  get pleaseEnterNickName => localizations.pleaseEnterNickName;

  get nickNameExplained => localizations.nickNameExplained;

  get error => localizations.error;

  get wrongInputValue => localizations.wrongInputValue;

}
