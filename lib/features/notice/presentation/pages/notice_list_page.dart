import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';
import '../../../../app/widgets/main_app_drawer.dart';
import '../models/notice_ui.dart';
import 'notice_detail_page.dart';

class NoticeListPage extends StatelessWidget {
  const NoticeListPage({super.key});

  static const notices = [
    NoticeUi(
      id: 'N01',
      title: '치료일지 관련',
      writer: '박병준',
      role: '대표님',
      createdAt: '2026-08-18 18:39',
      category: '지침',
      content: '치료일지 작성 및 확인과 관련된 안내입니다. 센터 운영 기준에 맞춰 기록을 작성해주세요.',
      important: true,
    ),
    NoticeUi(
      id: 'N02',
      title: '라포아동발달센터 프리랜서치료사 업무협약 내용',
      writer: '조민석',
      role: '센터장님',
      createdAt: '2026-08-17 14:00',
      category: '지침',
      content: '센터와 선생님 업무협약에 관련한 내용입니다.',
      attachments: ['서울성모의원 부설 라포아동발달센터 프리랜서 치료사 업무협약.pdf'],
    ),
    NoticeUi(
      id: 'N03',
      title: '일지 작성요령',
      writer: '조민석',
      role: '센터장님',
      createdAt: '2026-08-16 16:11',
      category: '지침',
      content: '회기 기록과 상담 기록 작성 시 필요한 기본 작성 요령을 안내합니다.',
      attachments: ['치료일지_작성요령.pdf'],
    ),
    NoticeUi(
      id: 'N04',
      title: '평가관련 세부 옵션',
      writer: '박병준',
      role: '대표님',
      createdAt: '2026-08-04 12:24',
      category: '지침',
      content: '평가 일정 등록 및 기록 시 사용하는 세부 옵션에 대한 안내입니다.',
    ),
    NoticeUi(
      id: 'N05',
      title: '치료 및 평가자료 관련',
      writer: '박병준',
      role: '대표님',
      createdAt: '2026-08-01 12:50',
      category: '지침',
      content: '치료 및 평가자료 관리와 관련된 공지입니다.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MainAppDrawer(selected: AppMenu.notices),
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            onPressed: () => Scaffold.of(context).openDrawer(),
            icon: const Icon(Icons.menu_rounded),
          ),
        ),
        title: const Text('공지사항'),
      ),
      body: SafeArea(
        top: false,
        child: ListView.separated(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 26),
          itemCount: notices.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final notice = notices[index];
            return Material(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => NoticeDetailPage(notice: notice),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (notice.important) ...[
                            const Text(
                              '중요',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFFE26943),
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          Expanded(
                            child: Text(
                              notice.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textStrong,
                              ),
                            ),
                          ),
                          if (notice.attachments.isNotEmpty)
                            const Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: Icon(
                                Icons.attach_file_rounded,
                                size: 19,
                                color: AppColors.primary,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 9),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notice.createdAt,
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ),
                          Text(
                            '${notice.writer} / ${notice.role}',
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textMuted,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            notice.category,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.primaryDark,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
