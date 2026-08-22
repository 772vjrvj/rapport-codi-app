import '../../../core/network/token_storage.dart';
import 'auth_api.dart';
import 'auth_models.dart';

class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  final AuthApi _authApi = AuthApi.instance;
  final TokenStorage _tokenStorage = TokenStorage.instance;

  Future<MobileLoginResponse> login({
    required String loginId,
    required String password,
  }) async {
    final deviceId = await _tokenStorage.getOrCreateDeviceId();

    final response = await _authApi.login(
      loginId: loginId.trim(),
      password: password,
      deviceId: deviceId,
    );

    await _tokenStorage.saveTokens(
      accessToken: response.accessToken,
      refreshToken: response.refreshToken,
    );

    await _tokenStorage.saveLoginId(response.loginId);

    return response;
  }

  /// 앱 실행 시 저장된 Refresh Token으로 로그인 유지 여부를 확인한다.
  ///
  /// 현재 서버는 Refresh Token 절대 만료 방식이므로,
  /// 최초 로그인 후 30일이 지나면 false가 되고 다시 로그인이 필요하다.
  Future<bool> tryAutoLogin() async {
    final refreshToken = await _tokenStorage.getRefreshToken();

    if (refreshToken == null || refreshToken.isEmpty) {
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

  Future<void> logout() async {
    final refreshToken = await _tokenStorage.getRefreshToken();

    try {
      if (refreshToken != null && refreshToken.isNotEmpty) {
        await _authApi.logout(
          refreshToken: refreshToken,
        );
      }
    } finally {
      // 서버 로그아웃 API 성공 여부와 관계없이
      // 앱에서는 Access / Refresh Token을 반드시 제거한다.
      await _tokenStorage.clearSession();
    }
  }
}
