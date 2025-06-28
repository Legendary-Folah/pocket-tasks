import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_tasks/core/colors.dart';
import 'package:pocket_tasks/provider/add_task_provider.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
                itemCount: taskList.length,
                itemBuilder: (context, index) {
                  final task = taskList[index];
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
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                task.note,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Text(
                                '${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}',
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
