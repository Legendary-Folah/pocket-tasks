import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pocket_tasks/presentation/screens/home_page.dart';
import 'package:pocket_tasks/provider/theme_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(appThemeProvider);
    return MaterialApp(
      theme: theme,
      debugShowCheckedModeBanner: false,
      title: 'Pocket Tasks',
      home: const MyHomePage(),
    );
  }
}
