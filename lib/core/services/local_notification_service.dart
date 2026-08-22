import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../app/routes/app_routes.dart';
import '../../features/schedule/presentation/models/schedule_detail_ui.dart';
import '../../features/schedule/presentation/pages/schedule_case_detail_page.dart';

abstract final class LocalNotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();

  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();

  static Timer? _loginTestTimer;

  static String? _pendingLaunchPayload;

  static Future<void> initialize() async {
    const android = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const settings = InitializationSettings(
      android: android,
    );

    await _plugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );

    final launchDetails =
    await _plugin.getNotificationAppLaunchDetails();

    if (launchDetails?.didNotificationLaunchApp ?? false) {
      final payload =
          launchDetails?.notificationResponse?.payload;

      if (payload != null && payload.isNotEmpty) {
        _pendingLaunchPayload = payload;
      }
    }
  }

  static Future<void> requestPermission() async {
    await _plugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static void _onNotificationResponse(
      NotificationResponse response,
      ) {
    final payload = response.payload;

    if (payload == null || payload.isEmpty) {
      return;
    }

    _openFromPayload(
      payload,
      fromTerminated: false,
    );
  }

  static void openPendingLaunchNotification() {
    final payload = _pendingLaunchPayload;

    if (payload == null || payload.isEmpty) {
      return;
    }

    _pendingLaunchPayload = null;

    _openFromPayload(
      payload,
      fromTerminated: true,
    );
  }

  static void _openFromPayload(
      String payload, {
        required bool fromTerminated,
      }) {
    try {
      final json = jsonDecode(payload);

      if (json is! Map<String, dynamic>) {
        return;
      }

      final type = json['type']?.toString();
      final targetId = json['targetId']?.toString();

      if (type == null || targetId == null) {
        return;
      }

      switch (type) {
        case 'schedule':
          _openSchedule(
            targetId,
            fromTerminated: fromTerminated,
          );
          break;
      }
    } catch (e) {
      debugPrint('[Notification] payload parse error: $e');
    }
  }

  static void _openSchedule(
      String targetId, {
        required bool fromTerminated,
      }) {
    final navigator = navigatorKey.currentState;

    if (navigator == null) {
      return;
    }

    final schedule = _findTestSchedule(targetId);

    if (schedule == null) {
      debugPrint(
        '[Notification] schedule not found: $targetId',
      );
      return;
    }

    if (fromTerminated) {
      navigator.pushNamedAndRemoveUntil(
        AppRoutes.schedule,
            (route) => false,
      );

      WidgetsBinding.instance.addPostFrameCallback((_) {
        final currentNavigator = navigatorKey.currentState;

        if (currentNavigator == null) {
          return;
        }

        currentNavigator.push(
          MaterialPageRoute(
            builder: (_) => ScheduleCaseDetailPage(
              data: schedule,
            ),
          ),
        );
      });

      return;
    }

    navigator.push(
      MaterialPageRoute(
        builder: (_) => ScheduleCaseDetailPage(
          data: schedule,
        ),
      ),
    );
  }

  static ScheduleListDetailData? _findTestSchedule(
      String targetId,
      ) {
    switch (targetId) {
      case 'TEST_SCHEDULE_001':
        return const ScheduleListDetailData(
          kind: ScheduleDetailKind.treatment,
          title: '민준이 · 언어치료',
          teacherName: '서유나',
          teacherRole: '언어재활사',
          memberName: '민준이',
          memberInfo: '남 / 2020-04-15',
          programName: '언어 · 언어치료',
          programInfo: '개인',
          dateText: '2026-08-22 (토)',
          startTime: '10:00',
          endTime: '10:40',
          status: '완료',
          repeatText: '반복 없음',
        );

      default:
        return null;
    }
  }

  static void scheduleLoginTestNotification() {
    _loginTestTimer?.cancel();

    _loginTestTimer =
        Timer(const Duration(minutes: 1), () async {
          const details = NotificationDetails(
            android: AndroidNotificationDetails(
              'rapport_codi_test',
              '라포코디 테스트 알림',
              channelDescription:
              '로그인 후 알림 동작을 확인하기 위한 테스트 채널입니다.',
              importance: Importance.high,
              priority: Priority.high,
            ),
          );

          final payload = jsonEncode({
            'type': 'schedule',
            'targetId': 'TEST_SCHEDULE_001',
          });

          await _plugin.show(
            id: 1001,
            title: '라포코디',
            body: '민준이의 새로운 소식을 확인해보세요.',
            notificationDetails: details,
            payload: payload,
          );
        });
  }
}