/*
* Android Module
*  <service
*            android:name="com.dexterous.flutterlocalnotifications.ForegroundService"
*            android:exported="false"
*            android:stopWithTask="false" />
*
*        <receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver" />
*        <receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver">
*            <intent-filter>
*                <action android:name="android.intent.action.BOOT_COMPLETED"/>
*            </intent-filter>
*        </receiver>
*
*   *
*/

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../utlis.dart';

class NotificationApi {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static final onNotification = BehaviorSubject<String?>();

  static Future init({bool initSchedluled = false}) async {
    var IOSSetting = const DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestCriticalPermission: true,
      requestSoundPermission: true,
      defaultPresentAlert: true,
      defaultPresentBadge: true,
      defaultPresentSound: true,
    );

    var andriodSetting = const AndroidInitializationSettings("@mipmap/ic_launcher");
    InitializationSettings settings =
        InitializationSettings(android: andriodSetting, iOS: IOSSetting);
    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) async {
        onNotification.add(details.payload.toString());
      },
      onDidReceiveBackgroundNotificationResponse: (details) async {
        onNotification.add(details.payload.toString());
      },
      // onSelectNotification: (payload) async {
      //   onNotification.add(payload);
      // },
    );

    if (initSchedluled) {
      try {
        tz.initializeTimeZones();
        String? locationName = await FlutterTimezone.getLocalTimezone();
        tz.setLocalLocation(tz.getLocation(locationName));
      } catch (e) {
        Constants.debugLog(NotificationApi, "FlutterNativeTimezone:Error:\t$e");
      }
    }
  }

  static requestNotificationPermission() async {
    if (Constants.isAndroid()) {
      await _notifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.requestNotificationsPermission();
    }
    if (Constants.isIOS()) {
      await _notifications
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
    if (Constants.isMacOS()) {
      await _notifications
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
  }

  /*
   * NotificationApi.showNotification("title","body",payload:"payload"??"");
   */
  static Future showNotification(
      {int id = 0, String? title, String? body, String? payload}) async {
    _notifications.show(id, title, body, await _notificationDetails(),
        payload: payload);
  }

  /*
   * NotificationApi.showScheduledNotification("title","body",payload:"payload"??"",scheduledDate:DateTime.now().add(Duration(seconds:12)));
   */
  static Future showScheduledNotification(
      {int id = 0,
      String? title,
      String? body,
      String? payload,
      required DateTime scheduledDate}) async {
    _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      await _notificationDetails(),
      payload: payload,
      androidAllowWhileIdle: true,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /*
   * NotificationApi.showScheduledNotification("title","body",payload:"payload"??"",scheduledDate:DateTime.now().add(Duration(seconds:12)));
   */
  static Future showScheduledNotificationDailyBase(
      {int id = 0,
      String? title,
      String? body,
      String? payload,
      required DateTime time}) async {
    _notifications.zonedSchedule(
      id,
      title,
      body,
      // tz.TZDateTime.from(scheduledDate, tz.local),
      _ScheduledDaily(time),
      await _notificationDetails(),
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exact,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static tz.TZDateTime _ScheduledDaily(DateTime time) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
      time.second,
    );
    return scheduledDate.isBefore(now)
        ? scheduledDate.add(const Duration(days: 1))
        : scheduledDate;
  }

  static Future _notificationDetails() async {
    return const NotificationDetails(
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
        threadIdentifier: 'coozy_the_cafe_app',
      ),
      android: AndroidNotificationDetails(
        'coozy_the_cafe_app', //channel id
        'coozy_the_cafe_app',
        channelDescription: 'coozy_the_cafe_app',
        priority: Priority.high,
        category: AndroidNotificationCategory.service,
        importance: Importance.max,
      ),
    );
  }
}
