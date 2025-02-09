/*
 * Copyright (c) 2023 TheDeck.com - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 *
 * Created on Tue Jan 10 2023
 */

// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

// import '../firebase_options.dart';

class MockFirebase {

  Future<void> logEvent({required String name, Map<String, dynamic> parameters = const {}}) async {}
}

class Analytics {
  // late FirebaseAnalytics _analytics;
  // late FirebaseAnalyticsObserver _observer;

  final MockFirebase _analytics = MockFirebase();

  // get observer => _observer;

  Future<Analytics> init() async {
    // final app = await Firebase.initializeApp(
    //   options: DefaultFirebaseOptions.currentPlatform,
    // );
    // _analytics = FirebaseAnalytics.instanceFor(app: app);
    // await _analytics.setAnalyticsCollectionEnabled(kReleaseMode);
    // _observer = FirebaseAnalyticsObserver(analytics: _analytics);
    // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    return this;
  }

  // Crashlitics

  void crash() {
    // FirebaseCrashlytics.instance.crash();
  }

  void nonFatal(dynamic exception, {StackTrace? stack}) {
    // FirebaseCrashlytics.instance.recordError(exception, stack);
  }

  // Seet User ID

  Future<void> setUserLocalKey(String userKey) async {
    // await _analytics.setUserId(id: userKey);
  }

  //region: Analytics

  Future<void> reportPushNotificationPermission(String value) async {
    await _analytics.logEvent(
      name: _Event.pushNotificationPermission,
      parameters: <String, dynamic>{
        _Param.value: value,
      },
    );
  }

  Future<void> reportGameSelected(int gameId, bool isDeck) async {
    await _analytics.logEvent(
      name: _Event.gameSelected,
      parameters: <String, dynamic>{
        _Param.value: gameId,
        _Param.isDeck: isDeck ? 1 : 0,
      },
    );
  }

  Future<void> reportSaveNickname() async {
    await _analytics.logEvent(name: _Event.saveNickname);
  }

  Future<void> reportConnectedToGame(int gameId) async {
    await _analytics.logEvent(
      name: _Event.connectToGame,
      parameters: <String, dynamic>{
        _Param.value: gameId,
      },
    );
  }

  Future<void> reportTimeoutToConnect() async {
    await _analytics.logEvent(name: _Event.timeoutToConnect);
  }

  Future<void> reportCrashOnConnect() async {
    await _analytics.logEvent(name: _Event.crashToConnect);
  }

  Future<void> reportFailedCreateRoom(int? error) async {
    await _analytics.logEvent(
      name: _Event.failedToCreateRoom,
      parameters: <String, dynamic>{
        _Param.value: error,
      },
    );
  }

  Future<void> reportServerStartGame(bool started) async {
    await _analytics.logEvent(
      name: _Event.serverStartGame,
      parameters: <String, dynamic>{
        _Param.value: started.toString(),
      },
    );
  }

  Future<void> reportErrorDialog(String type) async {
    await _analytics.logEvent(
      name: _Event.errorDialogShown,
      parameters: <String, dynamic>{
        _Param.value: type,
      },
    );
  }

}

mixin _Event {
  static const String pushNotificationPermission = "pushNotificationPermission";
  static const String gameSelected = "game_selected";
  static const String connectToGame = "connect_to_game";
  static const String saveNickname = "save_nickname";
  static const String timeoutToConnect = "timeout_to_connect";
  static const String crashToConnect = "crash_to_connect";
  static const String failedToCreateRoom = "faile_create_room";
  static const String serverStartGame = "server_start_game";
  static const String errorDialogShown = "error_dialog_shown";
}

mixin _Param {
  static const String value = "value";
  static const String isDeck = "is_deck";
}
