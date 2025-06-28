import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_tasks/core/colors.dart';
import 'package:pocket_tasks/model/add_task_model.dart';
import 'package:pocket_tasks/presentation/widgets/custom_text_field.dart';
import 'package:pocket_tasks/provider/add_task_provider.dart';

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
    // final formData = ref.watch(taskListProvider);

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
          final tasks = AddTaskModel(
            dueDate: selectedDate!,
            isCompleted: isCompleted,
            note: _noteController.text.trim(),
            title: _titleController.text.trim(),
          );
          ref.read(taskListProvider.notifier).addTask(tasks);
          _titleController.clear();
          _noteController.clear();
        }
      } catch (e) {
        throw Exception('Failed to submit task: $e');
      }
    }

    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            spacing: 15,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextFormField(
                noteController: _titleController,
                labelText: 'Title',
              ),
              SizedBox(height: 16),
              CustomTextFormField(
                maxLines: 7,
                labelText: 'Note',
                noteController: _noteController,
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    selectedDate != null
                        ? 'Due: ${selectedDate!.toLocal().toString().split(' ')[0]}'
                        : 'No due date selected',
                  ),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () => pickDate(context),
                    child: Text('Pick Due Date'),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Checkbox(
                    value: isCompleted,
                    onChanged: (value) {
                      setState(() {
                        isCompleted = value ?? false;
                      });
                    },
                  ),
                  Text('Completed'),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(ColorsConst.kPurple),
                ),
                onPressed: () {
                  // Logic to add task goes here
                },
                child: const Text(
                  'Add Task',
                  style: TextStyle(
                    color: ColorsConst.kWhite,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
