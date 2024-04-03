// ignore_for_file: library_private_types_in_public_api, unused_local_variable

import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

FlutterLocalNotificationsPlugin notificationsPlugin =
    FlutterLocalNotificationsPlugin();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AndroidInitializationSettings androidSettings =
      const AndroidInitializationSettings("@mipmap/launcher_icon");

  DarwinInitializationSettings iosSettings = const DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestCriticalPermission: true,
    requestProvisionalPermission: true,
    requestSoundPermission: true,
  );
  InitializationSettings initializationSettings =
      InitializationSettings(android: androidSettings, iOS: iosSettings);
  bool? initialized =
      await notificationsPlugin.initialize(initializationSettings);
  log('Notifications :$initialized');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
  const FlutterTimeDemo({super.key});

  @override
  _FlutterTimeDemoState createState() => _FlutterTimeDemoState();
}

class _FlutterTimeDemoState extends State<FlutterTimeDemo> {
  late String _timeString;

  @override
  void initState() {
    _timeString =
        "${DateTime.now().hour} : ${DateTime.now().minute} :${DateTime.now().second}";
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _getCurrentTime());
    super.initState();
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
    DarwinNotificationDetails iosDetails = const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    NotificationDetails notiDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    await notificationsPlugin.show(
        0, 'sample notification', 'This is a notification', notiDetails);
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
      floatingActionButton: FloatingActionButton(
        onPressed: showNotifications,
        child: const Icon(Icons.notification_add),
      ),
    );
  }

  void _getCurrentTime() {
    setState(() {
      _timeString =
          "${DateTime.now().hour} : ${DateTime.now().minute} :${DateTime.now().second}";
    });
  }
}
