import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/task_provider.dart';
import 'screens/home_screen.dart';
import 'services/task_storage.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TaskProvider(TaskStorage())..loadTasks(),
      child: const TaskFlowApp(),
    ),
  );
}

class TaskFlowApp extends StatelessWidget {
  const TaskFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskFlow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}
