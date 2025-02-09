/*
 *
 *  *
 *  * Created on 17 1 2023
 *
 */

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RoomConnectLocalizations {
  final AppLocalizations appLocalizations;

  RoomConnectLocalizations(this.appLocalizations);

  get connectToRoom => appLocalizations.connectToRoom;

  doYouWantToConnect(String game) => appLocalizations.doYouWantToConnect(game);

  get cancel => appLocalizations.cancel;

  get connect => appLocalizations.connect;

  get scan => appLocalizations.scan;

  get scanCodeToConnect => appLocalizations.scanCodeToConnect;

  get roomId => appLocalizations.roomId;

  get waitingForHost => appLocalizations.waitingForHost;

  get participants => appLocalizations.participants;

  get roomIsEmpty => appLocalizations.roomIsEmpty;

  get disconnect => appLocalizations.disconnect;

  youJoinedGameRoom(game) => appLocalizations.youJoinedGameRoom(game);

  get connectToSameWifi => appLocalizations.connectToSameWifi;

  youWifi(wifi) => appLocalizations.youWifi(wifi);

}
