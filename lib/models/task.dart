enum TaskPriority { high, medium, low }

enum TaskStatus { inProgress, pending, completed }

enum TaskCategory { assignment, project, quiz, exam, other }

class TaskMilestone {
  final String id;
  String title;
  bool isCompleted;

  TaskMilestone({
    required this.id,
    required this.title,
    this.isCompleted = false,
  });

  TaskMilestone copyWith({
    String? id,
    String? title,
    bool? isCompleted,
  }) {
    return TaskMilestone(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class TaskAttachment {
  final String name;
  final String size;
  final String type; // pdf, csv, doc, etc.

  TaskAttachment({
    required this.name,
    required this.size,
    required this.type,
  });
}

class TaskItem {
  final String id;
  String title;
  String courseCode;
  String courseName;
  TaskCategory category;
  DateTime dueDate;
  String dueTime;
  TaskPriority priority;
  TaskStatus status;
  String description;
  List<TaskMilestone> milestones;
  List<TaskAttachment> attachments;
  bool isCompleted;

  TaskItem({
    required this.id,
    required this.title,
    required this.courseCode,
    required this.courseName,
    required this.category,
    required this.dueDate,
    required this.dueTime,
    required this.priority,
    required this.status,
    this.description = '',
    List<TaskMilestone>? milestones,
    List<TaskAttachment>? attachments,
    this.isCompleted = false,
  })  : milestones = milestones ?? [],
        attachments = attachments ?? [];

  double get progress {
    if (milestones.isEmpty) {
      return isCompleted ? 1.0 : (status == TaskStatus.inProgress ? 0.5 : 0.0);
    }
    final completedCount = milestones.where((m) => m.isCompleted).length;
    return completedCount / milestones.length;
  }

  String get categoryLabel {
    switch (category) {
      case TaskCategory.assignment:
        return 'Assignment';
      case TaskCategory.project:
        return 'Project';
      case TaskCategory.quiz:
        return 'Quiz';
      case TaskCategory.exam:
        return 'Exam';
      case TaskCategory.other:
        return 'Other';
    }
  }

  String get priorityLabel {
    switch (priority) {
      case TaskPriority.high:
        return 'High Priority';
      case TaskPriority.medium:
        return 'Medium Priority';
      case TaskPriority.low:
        return 'Low Priority';
    }
  }

  String get statusLabel {
    if (isCompleted || status == TaskStatus.completed) return 'Completed';
    switch (status) {
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.pending:
        return 'Pending';
      case TaskStatus.completed:
        return 'Completed';
    }
  }
}

