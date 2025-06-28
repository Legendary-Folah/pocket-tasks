import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_tasks/provider/add_task_provider.dart';

class TaskList extends ConsumerStatefulWidget {
  const TaskList({super.key});

  @override
  ConsumerState<TaskList> createState() => _TaskListState();
}

class _TaskListState extends ConsumerState<TaskList> {
  @override
  Widget build(BuildContext context) {
    final taskList = ref.watch(taskListProvider);
    return Scaffold(
      body: taskList.isEmpty
          ? Center(child: Text('No Tasks Added yet'))
          : Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
              child: ListView.builder(
                itemCount: taskList.length,
                itemBuilder: (context, index) {
                  final task = taskList[index];
                  return ListTile();
                },
              ),
            ),
    );
  }
}
