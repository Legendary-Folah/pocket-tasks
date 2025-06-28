import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_tasks/core/colors.dart';
import 'package:pocket_tasks/provider/add_task_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pocket_tasks/provider/tasks_filter_provider.dart';
import 'package:pocket_tasks/provider/theme_provider.dart';

class TaskList extends ConsumerStatefulWidget {
  const TaskList({super.key});

  @override
  ConsumerState<TaskList> createState() => _TaskListState();
}

class _TaskListState extends ConsumerState<TaskList> {
  @override
  Widget build(BuildContext context) {
    final filteredTasks = ref.watch(filteredTasksProvider);
    final currentFilter = ref.watch(taskFilterProvider);
    final darkMode = ref.watch(themeProvider);
    return Scaffold(
      appBar: AppBar(
        actions: [
          DropdownButton<TaskFilter>(
            value: currentFilter,
            underline: const SizedBox(),
            icon: const Icon(Icons.filter_list, color: ColorsConst.kBlack),
            dropdownColor: ColorsConst.kGrey,
            items: TaskFilter.values.map((filter) {
              return DropdownMenuItem<TaskFilter>(
                value: filter,
                child: Text(
                  filter == TaskFilter.all
                      ? 'All'
                      : filter == TaskFilter.active
                      ? 'Active'
                      : 'Completed',
                  style: TextStyle(
                    color: darkMode ? ColorsConst.kWhite : ColorsConst.kBlack,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
            onChanged: (filter) {
              if (filter != null) {
                ref.read(taskFilterProvider.notifier).state = filter;
              }
            },
          ),
        ],
      ),
      body: filteredTasks.isEmpty
          ? Center(
              child: Column(
                spacing: 30,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/emptylist.svg',
                    height: 50,
                    width: 80,
                  ),
                  Text(
                    'No Tasks Available',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            )
          : Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 20),
              child: ListView.builder(
                itemCount: filteredTasks.length,
                itemBuilder: (context, index) {
                  final task = filteredTasks[index];
                  return Column(
                    spacing: 10,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${index + 1}.',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Expanded(
                            child: ListTile(
                              title: Text(
                                task.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: task.isCompleted ? 14 : 16,
                                  fontWeight: FontWeight.w600,
                                  decoration: task.isCompleted
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  fontStyle: task.isCompleted
                                      ? FontStyle.italic
                                      : FontStyle.normal,
                                ),
                              ),
                              subtitle: Text(
                                task.note,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: task.isCompleted ? 13 : 15,
                                  fontWeight: task.isCompleted
                                      ? FontWeight.w300
                                      : FontWeight.w400,
                                  decoration: task.isCompleted
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  fontStyle: task.isCompleted
                                      ? FontStyle.italic
                                      : FontStyle.normal,
                                ),
                              ),
                              trailing: Text(
                                '${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}',
                                style: TextStyle(
                                  decoration: task.isCompleted
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                  fontStyle: task.isCompleted
                                      ? FontStyle.italic
                                      : FontStyle.normal,
                                  fontSize: 12,
                                  fontWeight: task.isCompleted
                                      ? FontWeight.w300
                                      : FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Checkbox(
                            value: task.isCompleted,
                            onChanged: (value) {
                              ref
                                  .read(taskListProvider.notifier)
                                  .toggleTask(index);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: ColorsConst.kRed),
                            onPressed: () {
                              ref
                                  .read(taskListProvider.notifier)
                                  .deleteTask(index);
                            },
                          ),
                        ],
                      ),
                      Divider(color: ColorsConst.kGrey, height: 1),
                    ],
                  );
                },
              ),
            ),
    );
  }
}
