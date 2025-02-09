/*
 *
 * Copyright (c) 2023 TheDeck.com - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited 
 * Proprietary and confidential 
 *
 * Created on 2023-06-23 
 */

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NoNetworkRoomDialogLocalisation {
  final AppLocalizations localizations;

  NoNetworkRoomDialogLocalisation(this.localizations);

  String get createRoom => localizations.createRoom;

  String get makeSureYouAreConnected => localizations.makeSureYouAreConnected;

  String get cancel => localizations.cancel;

  String get create => localizations.create;

  String get connect => localizations.connect;
}
