import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/config/api_config.dart';
import '../../../core/network/api_exception.dart';
import 'auth_models.dart';

class AuthApi {
  AuthApi._();

  static final AuthApi instance = AuthApi._();

  Future<MobileLoginResponse> login({
    required String loginId,
    required String password,
    required String deviceId,
  }) async {
    final response = await _post(
      '/api/mobile/auth/login',
      body: {
        'loginId': loginId,
        'password': password,
        'deviceId': deviceId,
      },
    );

    final json = _decodeJson(response);

    if (response.statusCode != 200) {
      throw _toApiException(response, json);
    }

    final result = MobileLoginResponse.fromJson(json);

    if (result.accessToken.isEmpty || result.refreshToken.isEmpty) {
      throw const ApiException(
        message: '로그인 응답에 토큰이 없습니다.',
      );
    }

    return result;
  }

  Future<MobileRefreshResponse> refresh({
    required String refreshToken,
  }) async {
    final response = await _post(
      '/api/mobile/auth/refresh',
      body: {
        'refreshToken': refreshToken,
      },
    );

    final json = _decodeJson(response);

    if (response.statusCode != 200) {
      throw _toApiException(response, json);
    }

    final result = MobileRefreshResponse.fromJson(json);

    if (result.accessToken.isEmpty) {
      throw const ApiException(
        message: 'Access Token 재발급 응답이 올바르지 않습니다.',
      );
    }

    return result;
  }

  Future<void> logout({
    required String refreshToken,
  }) async {
    final response = await _post(
      '/api/mobile/auth/logout',
      body: {
        'refreshToken': refreshToken,
      },
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final json = _decodeJson(response);
      throw _toApiException(response, json);
    }
  }

  Future<http.Response> _post(
    String path, {
    required Map<String, dynamic> body,
  }) {
    final uri = Uri.parse('${ApiConfig.baseUrl}$path');

    return http
        .post(
          uri,
          headers: const {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode(body),
        )
        .timeout(ApiConfig.connectTimeout);
  }

  Map<String, dynamic> _decodeJson(http.Response response) {
    if (response.bodyBytes.isEmpty) {
      return <String, dynamic>{};
    }

    try {
      final text = utf8.decode(response.bodyBytes);
      final decoded = jsonDecode(text);

      if (decoded is Map<String, dynamic>) {
        return decoded;
      }

      return <String, dynamic>{};
    } catch (_) {
      return <String, dynamic>{};
    }
  }

  ApiException _toApiException(
    http.Response response,
    Map<String, dynamic> json,
  ) {
    final serverMessage = json['message']?.toString();

    if (serverMessage != null && serverMessage.trim().isNotEmpty) {
      return ApiException(
        statusCode: response.statusCode,
        message: serverMessage,
      );
    }

    switch (response.statusCode) {
      case 400:
        return const ApiException(
          statusCode: 400,
          message: '요청 정보를 확인해주세요.',
        );
      case 401:
        return const ApiException(
          statusCode: 401,
          message: '아이디 또는 비밀번호를 확인해주세요.',
        );
      case 403:
        return const ApiException(
          statusCode: 403,
          message: '접근 권한이 없습니다.',
        );
      default:
        return ApiException(
          statusCode: response.statusCode,
          message: '서버 요청에 실패했습니다. (${response.statusCode})',
        );
    }
  }
}
