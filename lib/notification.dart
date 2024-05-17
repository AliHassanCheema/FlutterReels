import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Local Notification Example'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              await Permission.notification.request();
              var status = await Permission.notification.status;
              if (status.isDenied) {
                Permission.notification.request();
              }
              NotificationService.showNotification(
                  'Notification Title', 'This is a notification body!');
            },
            child: const Text('Show Notification'),
          ),
        ),
      ),
    );
  }
}
