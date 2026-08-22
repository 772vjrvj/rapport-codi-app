class ApiConfig {
  ApiConfig._();

  // Android Emulator에서 로컬 Spring Boot 서버 연결 시 사용
  // static const String baseUrl = 'http://10.0.2.2';

  // 운영 서버
  static const String baseUrl = 'https://rapportcodi.com';

  static const Duration connectTimeout = Duration(seconds: 10);
}
