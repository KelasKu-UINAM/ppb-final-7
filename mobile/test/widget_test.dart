import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile/app.dart';

void main() {
  testWidgets('KelasKu UINAM splash renders', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: KelaskuApp()),
    );
    await tester.pump();

    expect(find.text('KelasKu UINAM'), findsOneWidget);
    expect(find.text('UIN Alauddin Makassar'), findsOneWidget);
  });
}
