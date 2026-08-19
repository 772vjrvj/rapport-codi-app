import 'package:flutter/material.dart';

import 'consultation_record_list_page.dart';
import 'treatment_record_list_page.dart';

class Chapter14RecordsDemoPage extends StatelessWidget {
  const Chapter14RecordsDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chapter 14',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            title: const Text('치료 기록 목록'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const TreatmentRecordListPage(),
              ),
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('상담/평가 기록 목록'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const ConsultationRecordListPage(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
