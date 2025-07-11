import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart';
import 'package:timezone/timezone.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Notification',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Notification'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    init();
    super.initState();
  }

  Future<void> init() async {
    initializeTimeZones();

    // https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
    setLocalLocation(getLocation('Asia/Jakarta'));

    const androidSettings = AndroidInitializationSettings('ic_launcher');
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);

    await notificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showInstantNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    await notificationsPlugin.show(
      id,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'instant_notification_channel_id',
          'Instant Notifications',
          channelDescription: 'Instant notification channel',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  Future<void> scheduleReminder({
    required int id,
    required String title,
    required String body,
  }) async {
    TZDateTime now = TZDateTime.now(local);
    TZDateTime scheduleDate = now.add(Duration(seconds: 3));

    await notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduleDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'instant_notification_channel_id',
          'Instant Notifications',
          channelDescription: 'Instant notification channel',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8,
          children: <Widget>[
            FilledButton(
              onPressed: () {
                showInstantNotification(
                  id: 0,
                  title: 'Instant notif',
                  body: 'body',
                );
              },
              child: Text('Instan notif'),
            ),
            FilledButton(
              onPressed: () {
                scheduleReminder(id: 1, title: 'Schedule notif', body: 'body');
              },
              child: Text('Scheduled notif'),
            ),
          ],
        ),
      ),
    );
  }
}
