/*
 * Copyright (c) 2023 TheDeck.com - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 *
 * Created on Tue Jan 10 2023
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:redux/redux.dart';
import 'package:the_deck/di/analytics.dart';
import 'package:the_deck/redux/app_state.dart';
import 'di/app_dependency.dart';
import 'redux/reducers/app_reducer.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:provider/provider.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'ui/route/routes_factory.dart';
import 'ui/screens/home/interactive_home_screen_widget.dart';
import 'ui/style/theme_utils.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dependency = await AppDependencyProvider.create();
  // FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  runApp(_buildApp(dependency));
}

Widget _buildApp(AppDependency dependency) {
  final Store<AppState> store = Store<AppState>(
    appStateReducer,
    initialState: AppState.create(),
    middleware: [
      ExtraArgumentThunkMiddleware<AppState, AppDependency>(
        dependency,
      )
    ],
  );
  _lifecycleListener(dependency);
  return MultiProvider(
    providers: [
      Provider(
        create: (c) => dependency,
      ),
    ],
    child: StoreProvider(
      store: store,
      child: _materialApp(dependency.router.key, dependency.analytics),
    ),
  );
}

Widget _materialApp(
  GlobalKey<NavigatorState> navigatorKey,
  Analytics analytics,
) {
  AppTheme.setSystemBarColor();
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    theme: AppTheme.themeData,
    // darkTheme: AppTheme.darkThemeData,
    // themeMode: ThemeMode.system,
    debugShowCheckedModeBanner: false,
    onGenerateRoute: ApplicationRoutes.factory(),
    initialRoute: InteractiveHomeScreen.route,
    navigatorKey: navigatorKey,
    navigatorObservers: [
      // analytics.observer,
    ],
  );
}

_lifecycleListener(AppDependency dependency) {
  final log = dependency.logger;
  SystemChannels.lifecycle.setMessageHandler((message) async {
    log.d('New state: $message', tag: "Lifecycle");
    AppLifecycleState? state;
    if (message == AppLifecycleState.resumed.toString()) {
      state = AppLifecycleState.resumed;
    } else if (message == AppLifecycleState.inactive.toString()) {
      state = AppLifecycleState.inactive;
    } else if (message == AppLifecycleState.paused.toString()) {
      state = AppLifecycleState.paused;
    } else if (message == AppLifecycleState.detached.toString()) {
      state = AppLifecycleState.detached;
    } else {
      log.e('Unknown state: $message', tag: "Lifecycle");
    }
    if (state != null) {
      dependency.lifecycleState.setLifecycleState(state);
    }
  });
}
