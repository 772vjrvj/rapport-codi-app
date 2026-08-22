import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

abstract final class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Timer? _loginTestTimer;

  static Future<void> initialize() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: android);

    await _plugin.initialize(settings: settings);
  }

  static Future<void> requestPermission() async {
    await _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  /// APK 확인용: 로그인 성공 후 앱이 실행 중인 상태에서 1분 뒤 알림을 표시합니다.
  static void scheduleLoginTestNotification() {
    _loginTestTimer?.cancel();
    _loginTestTimer = Timer(const Duration(minutes: 1), () async {
      const details = NotificationDetails(
        android: AndroidNotificationDetails(
          'rapport_codi_test',
          '라포코디 테스트 알림',
          channelDescription: '로그인 후 알림 동작을 확인하기 위한 테스트 채널입니다.',
          importance: Importance.high,
          priority: Priority.high,
        ),
      );

      await _plugin.show(
        id: 1001,
        title: '라포코디',
        body: '민준이의 새로운 소식을 확인해보세요.',
        notificationDetails: details,
      );
    });
  }
}
