import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../app/routes/app_routes.dart';
import '../../features/auth/data/auth_api.dart';
import '../config/api_config.dart';
import '../services/local_notification_service.dart';
import 'api_exception.dart';
import 'token_storage.dart';

class ApiClient {
  ApiClient._();

  static final ApiClient instance = ApiClient._();

  final TokenStorage _tokenStorage = TokenStorage.instance;
  final AuthApi _authApi = AuthApi.instance;

  Future<bool>? _refreshFuture;

  Future<dynamic> get(
    String path, {
    Map<String, String>? queryParameters,
  }) async {
    final uri = _buildUri(
      path,
      queryParameters: queryParameters,
    );

    return _send(
      () async {
        final accessToken = await _tokenStorage.getAccessToken();

        return http
            .get(
              uri,
              headers: _headers(accessToken),
            )
            .timeout(ApiConfig.connectTimeout);
      },
    );
  }

  Future<dynamic> post(
    String path, {
    Object? body,
    Map<String, String>? queryParameters,
  }) async {
    final uri = _buildUri(
      path,
      queryParameters: queryParameters,
    );

    return _send(
      () async {
        final accessToken = await _tokenStorage.getAccessToken();

        return http
            .post(
              uri,
              headers: _headers(accessToken),
              body: body == null ? null : jsonEncode(body),
            )
            .timeout(ApiConfig.connectTimeout);
      },
    );
  }

  Future<dynamic> put(
    String path, {
    Object? body,
    Map<String, String>? queryParameters,
  }) async {
    final uri = _buildUri(
      path,
      queryParameters: queryParameters,
    );

    return _send(
      () async {
        final accessToken = await _tokenStorage.getAccessToken();

        return http
            .put(
              uri,
              headers: _headers(accessToken),
              body: body == null ? null : jsonEncode(body),
            )
            .timeout(ApiConfig.connectTimeout);
      },
    );
  }

  Future<dynamic> delete(
    String path, {
    Object? body,
    Map<String, String>? queryParameters,
  }) async {
    final uri = _buildUri(
      path,
      queryParameters: queryParameters,
    );

    return _send(
      () async {
        final accessToken = await _tokenStorage.getAccessToken();

        return http
            .delete(
              uri,
              headers: _headers(accessToken),
              body: body == null ? null : jsonEncode(body),
            )
            .timeout(ApiConfig.connectTimeout);
      },
    );
  }

  Future<dynamic> _send(
    Future<http.Response> Function() request, {
    bool canRetry = true,
  }) async {
    final response = await request();

    if (response.statusCode == 401 && canRetry) {
      final refreshed = await _refreshAccessToken();

      if (refreshed) {
        return _send(
          request,
          canRetry: false,
        );
      }

      await _moveToLogin();

      throw const ApiException(
        statusCode: 401,
        message: '로그인이 만료되었습니다. 다시 로그인해주세요.',
      );
    }

    return _handleResponse(response);
  }

  Future<bool> _refreshAccessToken() {
    final running = _refreshFuture;

    if (running != null) {
      return running;
    }

    final future = _doRefreshAccessToken();
    _refreshFuture = future;

    return future.whenComplete(() {
      _refreshFuture = null;
    });
  }

  Future<bool> _doRefreshAccessToken() async {
    final refreshToken = await _tokenStorage.getRefreshToken();

    if (refreshToken == null || refreshToken.isEmpty) {
      await _tokenStorage.clearSession();
      return false;
    }

    try {
      final response = await _authApi.refresh(
        refreshToken: refreshToken,
      );

      await _tokenStorage.saveAccessToken(response.accessToken);
      return true;
    } catch (_) {
      await _tokenStorage.clearSession();
      return false;
    }
  }

  dynamic _handleResponse(http.Response response) {
    final text = utf8.decode(response.bodyBytes);

    dynamic data;

    if (text.trim().isNotEmpty) {
      try {
        data = jsonDecode(text);
      } catch (_) {
        data = text;
      }
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    }

    String message = '서버 요청에 실패했습니다.';

    if (data is Map<String, dynamic>) {
      final serverMessage = data['message']?.toString();

      if (serverMessage != null && serverMessage.trim().isNotEmpty) {
        message = serverMessage;
      }
    }

    if (response.statusCode == 403) {
      message = '접근 권한이 없습니다.';
    }

    throw ApiException(
      statusCode: response.statusCode,
      message: message,
    );
  }

  Uri _buildUri(
    String path, {
    Map<String, String>? queryParameters,
  }) {
    final uri = Uri.parse('${ApiConfig.baseUrl}$path');

    if (queryParameters == null || queryParameters.isEmpty) {
      return uri;
    }

    return uri.replace(
      queryParameters: queryParameters,
    );
  }

  Map<String, String> _headers(String? accessToken) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (accessToken != null && accessToken.isNotEmpty) {
      headers['Authorization'] = 'Bearer $accessToken';
    }

    return headers;
  }

  Future<void> _moveToLogin() async {
    final navigator = LocalNotificationService.navigatorKey.currentState;

    if (navigator == null) {
      return;
    }

    // 현재 요청 처리 중 Navigator 상태 변경 충돌을 피한다.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LocalNotificationService.navigatorKey.currentState
          ?.pushNamedAndRemoveUntil(
        AppRoutes.login,
        (route) => false,
      );
    });
  }
}
