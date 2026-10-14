import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_app/main.dart';

void main() {
  testWidgets('shows the furniture catalog', (WidgetTester tester) async {
    await tester.pumpWidget(const FurnitureApp());

    expect(find.text('Cozy Corner'), findsOneWidget);
    expect(find.text('Oslo Sofa'), findsOneWidget);
  });
}
