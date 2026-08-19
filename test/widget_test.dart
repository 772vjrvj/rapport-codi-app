import 'package:flutter_test/flutter_test.dart';

import 'package:rapport_codi/app/app.dart';

void main() {
  testWidgets('Rapport Codi app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const RapportCodiApp());

    expect(find.text('Rapport Codi'), findsOneWidget);
  });
}