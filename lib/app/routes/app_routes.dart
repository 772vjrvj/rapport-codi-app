/// 앱의 최상위 화면 경로입니다.
/// Drawer와 로그인 화면에서 문자열을 직접 쓰지 않도록 한 곳에서 관리합니다.
abstract final class AppRoutes {
  static const String login = '/login';
  static const String schedule = '/schedule';
  static const String treatmentRecords = '/treatment-records';
  static const String consultationRecords = '/consultation-records';
  static const String members = '/members';
  static const String notices = '/notices';
  static const String support = '/support';
  static const String account = '/account';
}
