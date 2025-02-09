/*
 *
 *  *
 *  * Created on 30 3 2023
 *
 */

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ErrorDialogLocalisation {
  final AppLocalizations localizations;

  ErrorDialogLocalisation(this.localizations);

  get error => localizations.error;

  get genericError => localizations.genericError;

  get close => localizations.close;

  get ok => localizations.ok;

  get camera => localizations.camera;

  get cameraPermission => localizations.cameraPermission;

  get wifi => localizations.wifi;

  get connectToWifi => localizations.wifiRequiredWarning;

  get failedToConnectToRoom => localizations.failedToConnectToRoom;

  get failedToCreateRoom => localizations.failedToCreateRoom;

}