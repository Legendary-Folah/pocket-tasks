import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pocket_tasks/presentation/screens/edit_tasks.dart';
import 'package:pocket_tasks/model/add_task_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  testWidgets('edit task screen shows initial values', (
    WidgetTester tester,
  ) async {
    final task = AddTaskModel(
      title: 'Title',
      note: 'Note',
      dueDate: DateTime(2025, 1, 1),
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(home: EditTasks(addTaskModel: task, index: 0)),
      ),
    );

    // Check that the initial values appear
    expect(find.text('Title'), findsOneWidget);
    expect(find.text('Note'), findsOneWidget);
  });
}
