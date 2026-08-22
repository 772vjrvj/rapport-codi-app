import 'dart:math';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  TokenStorage._();

  static final TokenStorage instance = TokenStorage._();

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _loginIdKey = 'login_id';
  static const String _deviceIdKey = 'device_id';

  final FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      migrateWithBackup: true,
    ),
  );

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      _storage.write(
        key: _accessTokenKey,
        value: accessToken,
      ),
      _storage.write(
        key: _refreshTokenKey,
        value: refreshToken,
      ),
    ]);
  }

  Future<void> saveAccessToken(String accessToken) {
    return _storage.write(
      key: _accessTokenKey,
      value: accessToken,
    );
  }

  Future<String?> getAccessToken() {
    return _storage.read(key: _accessTokenKey);
  }

  Future<String?> getRefreshToken() {
    return _storage.read(key: _refreshTokenKey);
  }

  Future<void> saveLoginId(String loginId) {
    return _storage.write(
      key: _loginIdKey,
      value: loginId,
    );
  }

  Future<String?> getLoginId() {
    return _storage.read(key: _loginIdKey);
  }

  /// Access / Refresh Token 및 로그인 관련 값만 삭제한다.
  /// DEVICE_ID는 앱 설치 단위 식별값으로 계속 유지한다.
  Future<void> clearSession() async {
    await Future.wait([
      _storage.delete(key: _accessTokenKey),
      _storage.delete(key: _refreshTokenKey),
      _storage.delete(key: _loginIdKey),
    ]);
  }

  Future<String> getOrCreateDeviceId() async {
    final savedDeviceId = await _storage.read(key: _deviceIdKey);

    if (savedDeviceId != null && savedDeviceId.isNotEmpty) {
      return savedDeviceId;
    }

    final random = Random.secure();
    final randomText = List.generate(
      4,
      (_) => random.nextInt(0xFFFFFFFF).toRadixString(16).padLeft(8, '0'),
    ).join();

    final deviceId =
        'APP_${DateTime.now().millisecondsSinceEpoch}_$randomText';

    await _storage.write(
      key: _deviceIdKey,
      value: deviceId,
    );

    return deviceId;
  }
}
