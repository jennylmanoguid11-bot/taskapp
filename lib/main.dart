import 'package:flutter/material.dart';
import 'screens/home_shell.dart';
import 'services/task_service.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final taskService = TaskService();

  runApp(TaskTrackApp(taskService: taskService));
}

class TaskTrackApp extends StatelessWidget {
  final TaskService taskService;

  const TaskTrackApp({super.key, required this.taskService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TaskTrack Student App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: HomeShell(taskService: taskService),
    );
  }
}
