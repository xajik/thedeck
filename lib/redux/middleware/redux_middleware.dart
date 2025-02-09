/*
 * Copyright (c) 2023 TheDeck.com - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 *
 * Created on Tue Jan 10 2023
 */

import 'package:redux_thunk/redux_thunk.dart';

import '../../di/app_dependency.dart';
import '../../di/analytics.dart';
import '../app_state.dart';

ThunkActionWithExtraArgument<AppState, AppDependency> _thunkReportCrash(
    dynamic exception,
    {StackTrace? stack}) {
  return (store, dependency) async {
    final Analytics c = dependency.analytics;
    c.nonFatal(exception, stack: stack);
    dependency.logger.e(exception.toString(), stack: stack);
  };
}