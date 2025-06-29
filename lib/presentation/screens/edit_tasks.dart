import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_tasks/core/colors.dart';
import 'package:pocket_tasks/core/constants.dart';
import 'package:pocket_tasks/model/add_task_model.dart';
import 'package:pocket_tasks/presentation/widgets/custom_button.dart';
import 'package:pocket_tasks/presentation/widgets/custom_text_field.dart';
import 'package:pocket_tasks/provider/add_task_provider.dart';
import 'package:pocket_tasks/provider/theme_provider.dart';

class EditTasks extends ConsumerStatefulWidget {
  const EditTasks({super.key, required this.addTaskModel, required this.index});

  final AddTaskModel addTaskModel;
  final int index;

  @override
  ConsumerState<EditTasks> createState() => _EditTasksState();
}

class _EditTasksState extends ConsumerState<EditTasks> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  DateTime? selectedDate;
  bool isCompleted = false;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.addTaskModel.title;
    _noteController.text = widget.addTaskModel.note;
    selectedDate = widget.addTaskModel.dueDate;
  }

  @override
  Widget build(BuildContext context) {
    final darkMode = ref.watch(themeProvider);
    final theme = ref.watch(themeProvider.notifier);

    void pickDate(BuildContext context) async {
      final now = DateTime.now();
      final picked = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: now,
        lastDate: DateTime(now.year + 5),
      );
      if (picked != null && picked != selectedDate) {
        setState(() {
          selectedDate = picked;
        });
      }
    }

    void submitTask() {
      try {
        if (_formKey.currentState?.validate() ?? false) {
          if (selectedDate == null) {
            context.showErrorSnackBar(message: 'Please select a due date.');
            return;
          }
          if (_titleController.text.isEmpty && _noteController.text.isEmpty) {
            context.showErrorSnackBar(message: 'Please enter a title or note.');
            return;
          }
          final tasks = AddTaskModel(
            dueDate: selectedDate!,
            note: _noteController.text.trim(),
            title: _titleController.text.trim(),
          );
          ref.read(taskListProvider.notifier).updateTask(widget.index, tasks);
          _titleController.clear();
          _noteController.clear();
          selectedDate = null;
          context.showSuccessSnackBar(message: 'Task updated successfully!');
        }
      } catch (e) {
        context.showErrorSnackBar(message: 'Failed to update task: $e');
        throw Exception('Failed to update task: $e');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Task',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
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
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              spacing: 10,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomTextFormField(
                  controller: _titleController,
                  labelText: 'Title',
                ),
                SizedBox(height: 10),
                CustomTextFormField(controller: _noteController, maxLines: 7),
                SizedBox(height: 10),
                Row(
                  spacing: 4,
                  children: [
                    Expanded(
                      child: Text(
                        selectedDate != null
                            ? 'Due: ${selectedDate!.toLocal().toString().split(' ')[0]}'
                            : 'No due date selected',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: darkMode
                              ? ColorsConst.kWhite
                              : ColorsConst.kBlack,
                        ),
                      ),
                    ),
                    Expanded(
                      child: CustomButton(
                        height: 40,
                        onPressed: () {
                          pickDate(context);
                        },
                        width: 160,
                        text: 'Pick Due Date',
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                CustomButton(
                  height: 50,
                  text: 'Update Task',
                  width: double.infinity,
                  onPressed: () {
                    submitTask();
                    Future.delayed(Duration(seconds: 3), () {
                      Navigator.pop(context, true);
                    });
                    // debugPrint('Task submitted');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
