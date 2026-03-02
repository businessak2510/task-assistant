import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> init(FlutterLocalNotificationsPlugin plugin) async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(requestAlertPermission: true);

    const InitializationSettings initSettings =
        InitializationSettings(android: androidSettings, iOS: iosSettings);

    await _plugin.initialize(initSettings);
  }

  static Future<void> scheduleDailyNotification() async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'daily_task_channel',
      'Daily Tasks',
      channelDescription: 'Reminder for YouTube upload',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidDetails);

    await _plugin.zonedSchedule(
      0,
      'YouTube Upload Reminder',
      'Aapka samay ho chuka hai YouTube par song upload karne ka!',
      _nextInstanceOfFourPM(),
      notificationDetails,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: 'open_chat',
    );
  }

  // Yahan 'static' hona bahut zaroori hai
  static tz.TZDateTime _nextInstanceOfFourPM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, 16, 0);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}
