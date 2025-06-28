class AddTaskModel {
  final String title;
  final String note;
  final DateTime dueDate;
  final bool isCompleted;

  AddTaskModel({
    required this.dueDate,
    this.isCompleted = false,
    required this.note,
    required this.title,
  });
}
