/*
 *
 *  *
 *  * Created on 17 1 2023
 *
 */

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RoomCreateLocalization {
  final AppLocalizations localizations;

  RoomCreateLocalization(this.localizations);

  get createRoom => localizations.createRoom;

  get loading => localizations.loading;

  get dispose => localizations.dispose;

  get start => localizations.start;

  get participants => localizations.participants;

  get roomIsEmpty => localizations.roomIsEmpty;

  youWifi(wifi) => localizations.youWifi(wifi);

  get connectToSameWifi => localizations.connectToSameWifi;
}
