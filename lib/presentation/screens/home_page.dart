import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_tasks/core/colors.dart';
import 'package:pocket_tasks/presentation/screens/add_task_screen.dart';
import 'package:pocket_tasks/presentation/screens/task_list.dart';
import 'package:pocket_tasks/provider/theme_provider.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key});
  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

int _currentIndex = 0;

class _MyHomePageState extends ConsumerState<MyHomePage> {
  final List _pocketLists = [AddTaskScreen(), TaskList()];

  @override
  Widget build(BuildContext context) {
    final darkMode = ref.watch(themeProvider);
    final theme = ref.watch(themeProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pocket Tasks',
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
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: darkMode ? ColorsConst.kBlack : ColorsConst.kWhite,
        currentIndex: _currentIndex,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.note), label: 'Notes'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Task Lists'),
        ],
      ),
      body: _pocketLists.elementAt(_currentIndex),
    );
  }
}
