import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_tasks/core/colors.dart';
import 'package:pocket_tasks/core/constants.dart';
import 'package:pocket_tasks/model/add_task_model.dart';
import 'package:pocket_tasks/presentation/widgets/custom_button.dart';
import 'package:pocket_tasks/presentation/widgets/custom_text_field.dart';
import 'package:pocket_tasks/provider/add_task_provider.dart';
import 'package:pocket_tasks/provider/theme_provider.dart';

class AddTaskScreen extends ConsumerStatefulWidget {
  const AddTaskScreen({super.key});

  @override
  ConsumerState<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends ConsumerState<AddTaskScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime? selectedDate;
  bool isCompleted = false;
  @override
  Widget build(BuildContext context) {
    final darkMode = ref.watch(themeProvider);

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
          }
          final tasks = AddTaskModel(
            dueDate: selectedDate!,
            note: _noteController.text.trim(),
            title: _titleController.text.trim(),
          );
          ref.read(taskListProvider.notifier).addTask(tasks);
          _titleController.clear();
          _noteController.clear();
          selectedDate = null;
          context.showSuccessSnackBar(message: 'Task added successfully!');
        }
      } catch (e) {
        throw Exception('Failed to submit task: $e');
      }
    }

    return Scaffold(
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
                CustomTextFormField(maxLines: 7, controller: _noteController),
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
                          debugPrint('printing date');
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
                  text: 'Add Task',
                  width: double.infinity,
                  onPressed: () {
                    submitTask();
                    debugPrint('Task submitted');
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
