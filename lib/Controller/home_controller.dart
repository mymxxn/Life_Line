import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:lifeline/main.dart';

class HomeController extends GetxController {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();
  final androidChannel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This Channel is used for importance notifucations',
    importance: Importance.high,
  );
  Future<void> initNotification() async {
    await initPlatformState();
    await _firebaseMessaging.requestPermission();
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
    // _firebaseMessaging.getInitialMessage().then(handleMessage)
    final fCMToken = await _firebaseMessaging.getToken();
    log(fCMToken.toString());
    FirebaseMessaging.onBackgroundMessage(handleBackgoundMessage);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      final notification = message.notification;
      if (notification == null) return;
      _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
              android: AndroidNotificationDetails(
                  androidChannel.id, androidChannel.name,
                  channelDescription: androidChannel.description,
                  icon: '@drawable/ic_launcher',
                  actions: [
                AndroidNotificationAction(
                  'accept',
                  'Accept',
                ),
                AndroidNotificationAction(
                  'decline',
                  'Decline',
                  cancelNotification: true,
                )
              ])),
          payload: jsonEncode(message.toMap()));
    });

    // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    //   final notification = message.notification;
    //   navigatorKey.currentState?.pushNamed('/approvals');
    // if (notification != null && notification.body != null) {
    //   final title = notification.title;
    //   switch (title) {
    //     case "test data":
    //       navigatorKey.currentState?.pushNamed('/announcement');
    //       break;
    //     case "MyTask":
    //       navigatorKey.currentState?.pushNamed('/myTask');
    //       break;
    //     case "Merchandise Test":
    //       navigatorKey.currentState?.pushNamed('/merchandise');
    //       break;
    //     case "Salesinvoice":
    //       navigatorKey.currentState?.pushNamed('/salesInvoice');
    //       break;
    //     case "Salesorder":
    //       navigatorKey.currentState?.pushNamed('/salesOrder');
    //       break;
    //     default:

    //       break;
    //   }
    // }
    // });

    // await sendFCMToken(fCMToken.toString());
  }

  initPlatformState() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      // await UserSimplePreferences.setDeviceId(androidInfo.model!);
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      // await UserSimplePreferences.setDeviceId(iosInfo.utsname.machine!);
    }
  }
}
