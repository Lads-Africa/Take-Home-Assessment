import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Update these imports to match your actual package name and paths
import 'package:qa_assessment_app/main.dart';
import 'package:qa_assessment_app/screens/login_screen.dart';

void main() {
  testWidgets('App builds and shows a MaterialApp', (WidgetTester tester) async {
    // Root smoke test: does the app build without throwing?
    await tester.pumpWidget(const MyApp());

    // Expect there is exactly one MaterialApp in the tree
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  testWidgets('Login screen shows input fields and login button',
      (WidgetTester tester) async {
    // Pump only the login screen inside a MaterialApp for testing
    await tester.pumpWidget(
      const MaterialApp(
        home: LoginScreen(),
      ),
    );

    // We expect two text fields (email + password) using TextFormField.
    // If your implementation uses TextField instead, change TextFormField → TextField below.
    final textFields = find.byType(TextFormField);
    expect(
      textFields,
      findsNWidgets(2),
      reason:
          'Expected 2 text fields on the login screen (email & password). Adjust test if your implementation differs.',
    );

    // We expect one primary button (e.g. ElevatedButton) for logging in.
    expect(
      find.byType(ElevatedButton),
      findsOneWidget,
      reason:
          'Expected exactly one ElevatedButton for login action on the login screen.',
    );

    // Basic interaction: enter text into the two fields to ensure they are writable.
    final emailField = textFields.at(0);
    final passwordField = textFields.at(1);

    await tester.enterText(emailField, 'user@test.com');
    await tester.enterText(passwordField, 'password');

    // No assertions on the actual text (password might be obscured); the fact that
    // enterText does not throw is enough to show the fields are interactive.
  });
}
