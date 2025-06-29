import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_tasks/model/add_task_model.dart';
import 'package:pocket_tasks/provider/theme_provider.dart';

class TasksDetailsScreen extends ConsumerStatefulWidget {
  const TasksDetailsScreen({super.key, required this.addTaskModel});

  final AddTaskModel addTaskModel;

  @override
  ConsumerState<TasksDetailsScreen> createState() => _TasksDetailsScreenState();
}

class _TasksDetailsScreenState extends ConsumerState<TasksDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final darkMode = ref.watch(themeProvider);
    final theme = ref.watch(themeProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Task Details',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: darkMode ? Icon(Icons.light_mode) : Icon(Icons.dark_mode),
            onPressed: () {
              theme.toggleTheme();
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 15,
          children: [
            Column(
              spacing: 5,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Title',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.5,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  widget.addTaskModel.title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
            Column(
              spacing: 5,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Note',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.5,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  widget.addTaskModel.note,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
