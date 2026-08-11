import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pkk_dasawisma_app/main.dart';

void main() {
  testWidgets('LoginPage renders correctly and performs login', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verify that LoginPage header and form elements exist
    expect(find.text('PKK DASAWISMA'), findsOneWidget);
    expect(find.text('Masuk ke Akun'), findsOneWidget);
    expect(find.text('Email / NIP'), findsOneWidget);
    expect(find.text('Kata Sandi'), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, 'MASUK'), findsOneWidget);

    // Enter email/NIP and password
    await tester.enterText(find.byType(TextFormField).at(0), 'admin@pkk.id');
    await tester.enterText(find.byType(TextFormField).at(1), 'password123');

    // Tap the MASUK button
    await tester.tap(find.widgetWithText(ElevatedButton, 'MASUK'));
    await tester.pump();

    // Expect loading state or async processing
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Wait for mock API response and navigation
    await tester.pumpAndSettle(const Duration(milliseconds: 1500));

    // Verify navigation to DashboardPage
    expect(find.text('Dashboard PKK Dasawisma'), findsOneWidget);
    expect(find.text('Data Keluarga'), findsOneWidget);
  });
}
