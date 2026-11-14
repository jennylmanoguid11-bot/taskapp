enum NotificationType { deadline, exam, update, reminder }

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String time;
  final NotificationType type;
  bool isRead;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.time,
    required this.type,
    this.isRead = false,
  });

  String get typeLabel {
    switch (type) {
      case NotificationType.deadline:
        return 'Deadlines';
      case NotificationType.exam:
        return 'Exams';
      case NotificationType.update:
        return 'Updates';
      case NotificationType.reminder:
        return 'Reminders';
    }
  }
}

