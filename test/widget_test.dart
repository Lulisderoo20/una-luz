import 'package:flutter_test/flutter_test.dart';

import 'package:una_luz/main.dart';

void main() {
  testWidgets('Muestra el titulo principal', (WidgetTester tester) async {
    await tester.pumpWidget(const UnaLuzApp());

    expect(find.text('UNA LUZ'), findsOneWidget);
    expect(find.text('Siguiente carta'), findsOneWidget);
  });
}
