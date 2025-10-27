import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lea_property_solutions/main.dart'; // Only import the app you're testing

void main() {
  testWidgets('Login page renders correctly', (WidgetTester tester) async {
    // Build the app (if necessary, wrap in a MaterialApp or other wrapper)
    await tester.pumpWidget(const MyApp());

    // Wait for any animations or async operations to settle
    await tester.pumpAndSettle();

    // Check if "Login" text is found
    expect(find.text('Login'), findsOneWidget);

    // Check for username and password fields
    expect(find.byType(TextFormField), findsNWidgets(2));
    expect(find.widgetWithIcon(TextFormField, Icons.person), findsOneWidget);
    expect(find.widgetWithIcon(TextFormField, Icons.lock), findsOneWidget);

    // Check for "Sign in" button
    expect(find.text('Sign in'), findsOneWidget);
  });
}
