import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('notification_icon');

    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _notifications.initialize(initializationSettings);
  }

  static Future<void> showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformSpecifics =
        AndroidNotificationDetails('your_channel_id', 'Your Channel Name',
            importance: Importance.high,
            priority: Priority.high,
            ticker: 'Flutter Notification',
            playSound: true);
    const NotificationDetails platformSpecifics =
        NotificationDetails(android: androidPlatformSpecifics);

    await _notifications.show(0, title, body, platformSpecifics);
  }
}
