/// 날짜/시간 표기를 앱 전체에서 동일하게 맞추기 위한 유틸입니다.
abstract final class AppDateTime {
  static const List<String> _weekdays = ['월', '화', '수', '목', '금', '토', '일'];

  static String twoDigits(int value) => value.toString().padLeft(2, '0');

  static String date(DateTime value) {
    return '${value.year}-${twoDigits(value.month)}-${twoDigits(value.day)} '
        '(${_weekdays[value.weekday - 1]})';
  }

  static String time(DateTime value) {
    return '${twoDigits(value.hour)}:${twoDigits(value.minute)}';
  }

  static String month(DateTime value) {
    return '${value.year}년 ${twoDigits(value.month)}월';
  }
}
