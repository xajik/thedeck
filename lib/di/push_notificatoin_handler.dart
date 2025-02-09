/*
 *
 *  *
 *  * Created on 6 5 2023
 *
 */

// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:the_deck/di/analytics.dart';
import 'package:the_deck/di/logger.dart';

class PushNotificationHandler {
  final Logger _logger;
  final Analytics _analytics;

  PushNotificationHandler(
    this._logger,
    this._analytics,
  );

  Future<void> setup() async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    //TODO: update icons  see https://github.com/zo0r/react-native-push-notification/issues/730#issuecomment-389545259
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
            onDidReceiveLocalNotification: (int id, String? title, String? body,
                String? payload) async {});
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void listenForeground() {
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   _parseMessage(message);
    // });
  }

  void requestPermission() {
    // final messaging = FirebaseMessaging.instance;
    // messaging
    //     .requestPermission(
    //   alert: true,
    //   announcement: false,
    //   badge: true,
    //   carPlay: false,
    //   criticalAlert: false,
    //   provisional: false,
    //   sound: true,
    // )
    //     .then((settings) {
    //   _logger.d("User granted permission: ${settings.authorizationStatus}");
    //   _analytics.reportPushNotificationPermission(
    //     settings.authorizationStatus.toString(),
    //   );
    // });
  }
}

/*
* Handle background push notification
* */
// @pragma('vm:entry-point')
// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   //await Analytics().init(); - do we need to?
//   await _parseMessage(message);
// }

// Future<void> _parseMessage(RemoteMessage message) async {
//   final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

//   const AndroidNotificationDetails androidPlatformChannelSpecifics =
//       AndroidNotificationDetails(
//     _Constants.channelId,
//     _Constants.channelName,
//     importance: Importance.high,
//     priority: Priority.high,
//   );
//   const DarwinNotificationDetails iOSPlatformChannelSpecifics =
//       DarwinNotificationDetails();
//   const NotificationDetails platformChannelSpecifics = NotificationDetails(
//       android: androidPlatformChannelSpecifics,
//       iOS: iOSPlatformChannelSpecifics);

//   await flutterLocalNotificationsPlugin.show(
//     0, // id
//     message.notification?.title ?? 'The Deck',
//     message.notification?.body ?? 'Check out game updates!',
//     platformChannelSpecifics,
//   );
// }

mixin _Constants {
  static const String channelId = 'TheDeck';
  static const String channelName = 'Game updates';
}
