import 'dart:convert';
import 'package:achievement/core/enums.dart';
import 'package:achievement/core/event.dart';
import 'package:achievement/core/notification/payload.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/standalone.dart' as tz;

class LocalNotification {
  static late LocalNotification _inst;

  final _openPayload = Event<Payload>();

  static const String channelId = '0';
  static const String channel = 'achievement';
  static const String channel_desc = 'channel description';
  static const String icon = 'icon_achievement';

  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  Payload? _payload;
  static Payload? get payload => _inst._payload;

  static void init() {
    _inst = LocalNotification._();
  }

  LocalNotification._() {
    _initialize();
  }

  static void clearPayload() {
    _inst._payload = null;
  }

  Future<void> _initialize() async {
    var initSettingAndroid = AndroidInitializationSettings(icon);

    var initSetting = InitializationSettings(android: initSettingAndroid);

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    final notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if (notificationAppLaunchDetails != null &&
        notificationAppLaunchDetails.didNotificationLaunchApp) {
      await onSelectNotification(
          notificationAppLaunchDetails.notificationResponse?.payload);
    }
    await flutterLocalNotificationsPlugin.initialize(
      initSetting,
      onDidReceiveNotificationResponse: (response) {
        onSelectNotificationCallback(response.payload);
      },
    );
  }

  Future<void> onSelectNotification(String? payload) async {
    if (payload == null || payload.isEmpty) {
      return;
    }
    _payload = Payload.fromJson(jsonDecode(payload) as Map<String, dynamic>);
  }

  Future<void> onSelectNotificationCallback(String? payload) async {
    await onSelectNotification(payload);
    if (_payload != null) {
      _openPayload.callLastHandler(_payload);
    }
  }

  static void subscribeOpenPayloadEvent(Function(Payload?) func) {
    _inst._openPayload.subscribe(func);
  }

  static bool unsubscribeOpenPayloadEvent(Function(Payload?) func) {
    return _inst._openPayload.unsubscribe(func);
  }

  static void unsubscribeAllOpenPayloadEvent() {
    _inst._openPayload.unsubscribeAll();
  }

  static Future<void> scheduleNotification(
      int id,
      String title,
      String body,
      DateTime scheduledDate,
      TypeRepition typeRepition,
      int achievementId) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        channelId, channel,
        channelDescription: channel_desc, playSound: true);
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    var dateTimeUtc = scheduledDate.toUtc();
    var tzSchedulerDate = tz.TZDateTime.utc(dateTimeUtc.year, dateTimeUtc.month,
        dateTimeUtc.day, dateTimeUtc.hour, dateTimeUtc.minute);
    await _inst.flutterLocalNotificationsPlugin.zonedSchedule(
        id, title, body, tzSchedulerDate, platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.wallClockTime,
        matchDateTimeComponents: _inst._matchDateTimeComponents(typeRepition),
        payload: jsonEncode(Payload('open', achievementId).toJson()));
  }

  DateTimeComponents? _matchDateTimeComponents(TypeRepition typeRepition) {
    switch (typeRepition) {
      case TypeRepition.day:
        return DateTimeComponents.time;
      case TypeRepition.week:
        return DateTimeComponents.dayOfWeekAndTime;
      default:
        return null;
    }
  }

  static Future<List<PendingNotificationRequest>>
      pendingNotificationRequests() async {
    return await _inst.flutterLocalNotificationsPlugin
        .pendingNotificationRequests();
  }

  static Future<NotificationAppLaunchDetails?>
      getNotificationAppLaunchDetails() async {
    return await _inst.flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails();
  }

  static Future<void> cancelNotification(int id) async {
    await _inst.flutterLocalNotificationsPlugin.cancel(id);
  }

  static Future<void> cancelAllNotification() async {
    await _inst.flutterLocalNotificationsPlugin.cancelAll();
  }
}
