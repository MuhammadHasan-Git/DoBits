import 'dart:developer';
import 'dart:math' as math;

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationServices {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    // Android initialization
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Ios initialization
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

    // the initialization settings are initialized after they are setted
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        log('onDidReceiveNotificationResponse: $details');
      },
    );
  }

  Future<void>? deleteNotification(id) async {
    return await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void>? zonedScheduleNotification({
    required String title,
    required String body,
    required DateTime selectedTime,
  }) async {
    await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: math.Random().nextInt(1000),
        channelKey: 'reminder_channel_key',
        title: title,
        body: body,
      ),
      schedule: NotificationCalendar.fromDate(date: selectedTime),
    );
  
  }
}
