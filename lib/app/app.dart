import 'package:flutter/material.dart';

import '../features/schedule/presentation/pages/main_schedule_page.dart';
import 'theme/app_theme.dart';

class RapportCodiApp extends StatelessWidget {
  const RapportCodiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rapport Codi',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.build(),
      home: const MainSchedulePage(),
    );
  }
}
