import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../app/widgets/main_app_drawer.dart';

class ChildInfoFeedPage extends StatelessWidget {
  const ChildInfoFeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    const posts = [
      _InfoPost(
        category: '언어 · 5세',
        sourceName: 'HealthyChildren.org',
        sourceUrl: 'https://www.healthychildren.org',
        slides: [
          _InfoSlide(
            background: Color(0xFFEAF8F5),
            eyebrow: '민준이에게 추천해요',
            title: '아이의 말을\n조금 더 길게 이어주는\n대화 방법',
            body: '정답을 바로 알려주기보다\n아이의 말 뒤에 한 문장을 덧붙여 주세요.',
          ),
          _InfoSlide(
            background: Color(0xFFFDF4E8),
            eyebrow: '이렇게 해보세요',
            title: '“자동차!”라고 말하면',
            body: '“맞아, 빨간 자동차가\n빠르게 달리고 있네.”처럼\n아이의 말을 자연스럽게 확장해 주세요.',
          ),
          _InfoSlide(
            background: Color(0xFFF2F0FB),
            eyebrow: '기억하기',
            title: '질문보다\n기다림을 조금 더',
            body: '대답을 재촉하지 않고\n5초 정도 기다려주는 것도\n좋은 대화가 될 수 있어요.',
          ),
        ],
      ),
      _InfoPost(
        category: '놀이 · 사회성',
        sourceName: 'CDC Developmental Milestones',
        sourceUrl: 'https://www.cdc.gov/ncbddd/actearly/milestones/',
        slides: [
          _InfoSlide(
            background: Color(0xFFEFF4FD),
            eyebrow: '오늘의 부모 팁',
            title: '차례를 기다리는 힘은\n놀이 속에서 자라요',
            body: '보드게임이 아니어도 괜찮아요.\n블록 하나씩 놓기처럼\n짧은 번갈아 하기로 시작해 보세요.',
          ),
          _InfoSlide(
            background: Color(0xFFFFF2F2),
            eyebrow: '부담 없이',
            title: '한 번에 오래보다\n짧게 여러 번',
            body: '성공 경험을 자주 만들어주면\n아이도 기다리는 규칙을\n더 편하게 받아들일 수 있어요.',
          ),
        ],
      ),
      _InfoPost(
        category: '감각 · 생활',
        sourceName: 'American Academy of Pediatrics',
        sourceUrl: 'https://www.aap.org',
        slides: [
          _InfoSlide(
            background: Color(0xFFF4F8E9),
            eyebrow: '민준이 연령 맞춤',
            title: '몸을 움직인 뒤\n차분한 활동으로\n이어가 보세요',
            body: '충분히 움직인 후 책 보기나\n퍼즐 같은 활동으로 넘어가면\n일상 루틴을 만들기 좋아요.',
          ),
          _InfoSlide(
            background: Color(0xFFFDF1F8),
            eyebrow: '집에서 간단하게',
            title: '쿠션 길 만들기',
            body: '쿠션을 바닥에 놓고\n밟고 넘어가는 짧은 놀이를 한 뒤\n차분한 활동으로 이어가 보세요.',
          ),
          _InfoSlide(
            background: Color(0xFFEAF7FC),
            eyebrow: '중요해요',
            title: '아이마다 반응은 달라요',
            body: '불편해하거나 힘들어하면\n강요하지 말고 현재 치료 선생님과\n아이에게 맞는 방법을 상의해 주세요.',
          ),
        ],
      ),
    ];

    return Scaffold(
      drawer: const MainAppDrawer(selected: AppMenu.childInfo),
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: const Icon(Icons.menu_rounded),
          ),
        ),
        title: const Text(
          '민준이를 위한 정보',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 28),
        itemCount: posts.length,
        separatorBuilder: (_, __) => const SizedBox(height: 18),
        itemBuilder: (_, index) => _InfoPostCard(post: posts[index]),
      ),
    );
  }
}

class _InfoPostCard extends StatefulWidget {
  final _InfoPost post;

  const _InfoPostCard({required this.post});

  @override
  State<_InfoPostCard> createState() => _InfoPostCardState();
}

class _InfoPostCardState extends State<_InfoPostCard> {
  int currentPage = 0;

  Future<void> _openSource() async {
    final uri = Uri.parse(widget.post.sourceUrl);
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('출처 링크를 열 수 없습니다.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 13, 16, 11),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary50,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(
                      widget.post.category,
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: AppColors.primaryDark),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${currentPage + 1}/${widget.post.slides.length}',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
            AspectRatio(
              aspectRatio: 0.96,
              child: PageView.builder(
                itemCount: widget.post.slides.length,
                onPageChanged: (value) => setState(() => currentPage = value),
                itemBuilder: (_, index) => _SlideCard(slide: widget.post.slides[index]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      widget.post.slides.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        width: index == currentPage ? 18 : 6,
                        height: 6,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        decoration: BoxDecoration(
                          color: index == currentPage ? AppColors.primary : AppColors.border,
                          borderRadius: BorderRadius.circular(99),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 9),
                  TextButton.icon(
                    onPressed: _openSource,
                    icon: const Icon(Icons.open_in_new_rounded, size: 16),
                    label: Text(
                      '출처 · ${widget.post.sourceName}',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
                    ),
                    style: TextButton.styleFrom(foregroundColor: AppColors.textBody),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SlideCard extends StatelessWidget {
  final _InfoSlide slide;

  const _SlideCard({required this.slide});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 30),
      decoration: BoxDecoration(
        color: slide.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            slide.eyebrow,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: AppColors.primaryDark,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            slide.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              height: 1.38,
              fontWeight: FontWeight.w900,
              color: AppColors.textStrong,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 23),
          Text(
            slide.body,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              height: 1.75,
              fontWeight: FontWeight.w700,
              color: AppColors.textBody,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoPost {
  final String category;
  final String sourceName;
  final String sourceUrl;
  final List<_InfoSlide> slides;

  const _InfoPost({
    required this.category,
    required this.sourceName,
    required this.sourceUrl,
    required this.slides,
  });
}

class _InfoSlide {
  final Color background;
  final String eyebrow;
  final String title;
  final String body;

  const _InfoSlide({
    required this.background,
    required this.eyebrow,
    required this.title,
    required this.body,
  });
}
