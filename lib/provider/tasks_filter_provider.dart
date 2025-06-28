import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_tasks/model/add_task_model.dart';
import 'package:pocket_tasks/provider/add_task_provider.dart';

enum TaskFilter { all, active, copleted }

final taskFilterProvider = StateProvider<TaskFilter>((ref) {
  return TaskFilter.all;
});

final filteredTasksProvider = Provider<List<AddTaskModel>>((ref) {
  final filter = ref.watch(taskFilterProvider);
  final allTasks = ref.watch(taskListProvider);

  switch (filter) {
    case TaskFilter.active:
      return allTasks.where((task) => !task.isCompleted).toList();
    case TaskFilter.copleted:
      return allTasks.where((task) => task.isCompleted).toList();
    case TaskFilter.all:
      return allTasks;
  }
});
