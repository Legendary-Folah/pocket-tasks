import 'dart:convert';
import 'dart:core';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_tasks/model/add_task_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TaskListNotifier extends StateNotifier<List<AddTaskModel>> {
  TaskListNotifier() : super([]) {
    _loadTasks();
  }

  void _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final rawTasks = prefs.getStringList('tasks') ?? [];

    state = rawTasks.map((taskString) {
      final data = json.decode(taskString);
      return AddTaskModel(
        title: data['title'],
        note: data['note'],
        dueDate: DateTime.parse(data['dueDate']),
        isCompleted: data['isCompleted'],
      );
    }).toList();
  }

  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final rawList = state.map((task) {
      return json.encode({
        'title': task.title,
        'note': task.note,
        'dueDate': task.dueDate.toIso8601String(),
        'isCompleted': task.isCompleted,
      });
    }).toList();
    await prefs.setStringList('tasks', rawList);
  }

  void addTask(AddTaskModel task) {
    state = [...state, task];
    _saveTasks();
  }

  void deleteTask(int index) {
    if (index < 0 || index >= state.length) return;
    state = [...state]..removeAt(index);
    _saveTasks();
  }

  void toggleTask(int index) {
    final updatedTasks = [...state]..removeAt(index);
    state = updatedTasks;
    _saveTasks();
  }
}

final taskListProvider =
    StateNotifierProvider<TaskListNotifier, List<AddTaskModel>>((ref) {
      return TaskListNotifier();
    });
