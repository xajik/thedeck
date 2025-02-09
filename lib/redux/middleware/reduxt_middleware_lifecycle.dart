/*
 *
 *  *
 *  * Created on 19 5 2023
 *
 */

import 'package:flutter/material.dart';
import 'package:redux_thunk/redux_thunk.dart';

import '../../di/app_dependency.dart';
import '../app_state.dart';

ThunkActionWithExtraArgument<AppState, AppDependency>
    middlewareRegisterLifecycleListener(Function(AppLifecycleState) listener) {
  return (store, dependency) async {
    dependency.lifecycleState.addListener(listener);
  };
}

ThunkActionWithExtraArgument<AppState, AppDependency>
    middlewareRemoveLifecycleListener(Function(AppLifecycleState) listener) {
  return (store, dependency) async {
    dependency.lifecycleState.removeListener(listener);
  };
}
