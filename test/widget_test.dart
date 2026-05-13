import 'package:flutter_test/flutter_test.dart';
import 'package:tugas_pbm_productapp/main.dart';
import 'package:tugas_pbm_productapp/screens/login_page.dart';

void main() {
  testWidgets('PrelovedArea smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // We pass '/login' as the initial route for testing
    await tester.pumpWidget(const PrelovedApp(initialRoute: '/login'));

    // Verify that the login page is displayed.
    expect(find.text('PrelovedArea'), findsOneWidget);
    expect(find.byType(LoginPage), findsOneWidget);
  });
}
