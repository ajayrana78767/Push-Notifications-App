// ignore_for_file: use_super_parameters, library_private_types_in_public_api, deprecated_member_use
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart';

FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeTimeZones();
  AndroidInitializationSettings androidSettings =
      const AndroidInitializationSettings('@mipmap/ic_launcher');

  InitializationSettings initializationSettings =
      InitializationSettings(android: androidSettings);
  await notificationsPlugin.initialize(initializationSettings);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.red),
      home: const FlutterTimeDemo(),
    );
  }
}

class FlutterTimeDemo extends StatefulWidget {
  const FlutterTimeDemo({Key? key}) : super(key: key);

  @override
  _FlutterTimeDemoState createState() => _FlutterTimeDemoState();
}

class _FlutterTimeDemoState extends State<FlutterTimeDemo> {
  late String _timeString;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timeString =
        '${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}';
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeString =
            '${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}';
        if (DateTime.now().second % 5 == 0) {
          showNotifications();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void showNotifications() async {
    AndroidNotificationDetails androidDetails =
        const AndroidNotificationDetails(
      'notifications-youtube',
      'Youtube Notifications',
      enableLights: true,
      priority: Priority.max,
      importance: Importance.max,
    );
    NotificationDetails notiDetails = NotificationDetails(
      android: androidDetails,
    );

    await notificationsPlugin.show(
      0,
      'Sample Notification',
      'Notification after the 5 seconds',
      notiDetails,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pinkAccent,
        centerTitle: true,
        title: const Text(
          'Push Notifications',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Text(
          _timeString,
          style: const TextStyle(fontSize: 30),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: showNotifications,
      //   child: const Icon(Icons.notification_add),
      // ),
    );
  }
}
