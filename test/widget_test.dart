import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pkk_dasawisma_app/main.dart';

void main() {
  testWidgets('LoginPage renders correctly and performs login', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify that LoginPage header and form elements exist
    expect(find.text('PKKITA'), findsAtLeastNWidgets(1));
    expect(find.text('Selamat Datang Kembali 👋'), findsOneWidget);
    expect(find.text('Username / NIP'), findsOneWidget);
    expect(find.text('Kata Sandi'), findsOneWidget);
    expect(find.text('Masuk ke PKKITA'), findsOneWidget);

    // Enter email/NIP and password
    await tester.enterText(find.byType(TextFormField).at(0), 'admin@pkk.id');
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');

    // Tap the login button
    final loginButton = find.text('Masuk ke PKKITA');
    await tester.ensureVisible(loginButton);
    await tester.tap(loginButton);
    await tester.pump();

    // Expect loading state or async processing
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for mock API response and navigation
    await tester.pumpAndSettle(const Duration(milliseconds: 1500));

    // Verify navigation to DashboardPage
    expect(find.text('Total KK'), findsOneWidget);
    expect(find.text('Tambah Data KK'), findsOneWidget);
  });
}
