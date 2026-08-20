class NoticeUi {
  final String id;
  final String title;
  final String writer;
  final String role;
  final String createdAt;
  final String category;
  final String content;
  final bool important;
  final List<String> attachments;

  const NoticeUi({
    required this.id,
    required this.title,
    required this.writer,
    required this.role,
    required this.createdAt,
    required this.category,
    required this.content,
    this.important = false,
    this.attachments = const [],
  });
}
