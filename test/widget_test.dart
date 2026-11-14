import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/services/task_service.dart';

void main() {
  testWidgets('TaskTrack App loads dashboard smoke test', (WidgetTester tester) async {
    final taskService = TaskService();
    await tester.pumpWidget(TaskTrackApp(taskService: taskService));

    // Verify dashboard title or welcome banner is present
    expect(find.text('TaskTrack Student App'), findsOneWidget);
    expect(find.text('Good morning, Jennyl! 👋'), findsOneWidget);
  });
}
