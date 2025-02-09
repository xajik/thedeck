/*
 *
 * Copyright (c) 2023 TheDeck.com - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited 
 * Proprietary and confidential 
 *
 * Created on 2023-05-21 
 */

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UserPermissionDialogLocalisation {
  final AppLocalizations localizations;

  UserPermissionDialogLocalisation(this.localizations);

  get userPermission => localizations.userPermission;

  get ok => localizations.ok;

  get localNetworkPermission => localizations.localNetworkPermission;
}
