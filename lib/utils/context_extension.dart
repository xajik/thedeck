/*
 * Copyright (c) 2023 TheDeck.com - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 *
 * Created on Tue Jan 10 2023
 */

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension AppTheme on BuildContext {
  TextTheme textTheme() => Theme.of(this).textTheme;
  ThemeData themeData() => Theme.of(this);
}

extension AppLocalization on BuildContext {
  AppLocalizations appLocalizations() => AppLocalizations.of(this)!;
}
