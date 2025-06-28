class AddTaskModel {
  final String title;
  final String note;
  final DateTime dueDate;
  final bool isCompleted;

  AddTaskModel({
    required this.dueDate,
    required this.isCompleted,
    required this.note,
    required this.title,
  });

  // factory AddTaskModel.fromJson(Map<String, dynamic> json) {
  //   return AddTaskModel(
  //     dueDate: json['dueDate'] ?? "",
  //     isCompleted: json['isCompleted'] ?? "",
  //     note: json['note'] ?? "",
  //     title: json['title'] ?? "",
  //   );
  // }
}
