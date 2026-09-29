import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:taskflow/providers/task_provider.dart';
import 'package:taskflow/screens/home_screen.dart';
import 'package:taskflow/services/api_service.dart';

import 'task_provider_test.dart' show FakeStorage;

void main() {
  testWidgets('adding a task shows it in the list', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => TaskProvider(FakeStorage(), ApiService()),
        child: const MaterialApp(home: HomeScreen()),
      ),
    );

    expect(find.text('No tasks yet'), findsOneWidget);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).first, 'Learn Flutter');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    expect(find.text('Learn Flutter'), findsOneWidget);
  });
}
