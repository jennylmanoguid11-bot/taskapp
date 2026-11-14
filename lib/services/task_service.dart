import 'package:flutter/material.dart';
import '../models/task.dart';
import '../models/notification_item.dart';
import '../models/student_profile.dart';

class TaskService extends ChangeNotifier {
  // Current Student Profile (from Stitch Profile screen)
  final StudentProfile _profile = StudentProfile(
    name: 'Ma. Jennyl Manoguid',
    program: 'BS Computer Science',
    yearLevel: '3rd Year',
    studentId: '2023-08492',
    university: 'Polytechnic University of the Philippines',
    email: 'jennyl.manoguid@student.edu',
    gpa: '3.85',
    completedTasks: 42,
    onTimeRate: '96%',
    studyStreak: '12 Days',
  );

  StudentProfile get profile => _profile;

  // Active Tasks Seeded from Stitch Designs
  final List<TaskItem> _tasks = [
    TaskItem(
      id: 'task-1',
      title: 'CS301 Algorithm Analysis Report',
      courseCode: 'CS301',
      courseName: 'Design & Analysis of Algorithms',
      category: TaskCategory.assignment,
      dueDate: DateTime.now().add(const Duration(hours: 4)),
      dueTime: '11:59 PM',
      priority: TaskPriority.high,
      status: TaskStatus.inProgress,
      description:
          'Complete empirical benchmarking of Quicksort, Mergesort, and Radix Sort with asymptotic runtime proofs and big-O asymptotic notation complexity diagrams.',
      milestones: [
        TaskMilestone(id: 'm1', title: 'Implement sorting algorithms in C++', isCompleted: true),
        TaskMilestone(id: 'm2', title: 'Collect execution time metrics for N=100,000', isCompleted: true),
        TaskMilestone(id: 'm3', title: 'Draft asymptotic runtime comparison chart', isCompleted: false),
        TaskMilestone(id: 'm4', title: 'Submit final PDF report to University portal', isCompleted: false),
      ],
      attachments: [
        TaskAttachment(name: 'CS301_Rubric_v2.pdf', size: '2.4 MB', type: 'pdf'),
        TaskAttachment(name: 'benchmark_dataset.csv', size: '840 KB', type: 'csv'),
      ],
    ),
    TaskItem(
      id: 'task-2',
      title: 'Database Systems Midterm Quiz',
      courseCode: 'IT204',
      courseName: 'Relational Database Management Systems',
      category: TaskCategory.quiz,
      dueDate: DateTime.now().add(const Duration(days: 1)),
      dueTime: '2:00 PM',
      priority: TaskPriority.high,
      status: TaskStatus.pending,
      description:
          'Comprehensive midterm assessment covering BCNF Normalization, Relational Algebra, SQL Complex Joins, and Index optimization strategies.',
      milestones: [
        TaskMilestone(id: 'm2-1', title: 'Review BCNF and 3NF functional dependencies', isCompleted: true),
        TaskMilestone(id: 'm2-2', title: 'Practice subqueries and self-joins', isCompleted: false),
        TaskMilestone(id: 'm2-3', title: 'Review transactions and ACID properties', isCompleted: false),
      ],
      attachments: [
        TaskAttachment(name: 'DBMS_Exam_Review_Notes.pdf', size: '4.1 MB', type: 'pdf'),
      ],
    ),
    TaskItem(
      id: 'task-3',
      title: 'UI/UX Flutter Mobile App Prototype',
      courseCode: 'IT312',
      courseName: 'Human Computer Interaction',
      category: TaskCategory.project,
      dueDate: DateTime.now().add(const Duration(days: 3)),
      dueTime: '5:00 PM',
      priority: TaskPriority.medium,
      status: TaskStatus.inProgress,
      description:
          'Develop high-fidelity Flutter interactive prototype following Google Stitch design system specifications with state management and responsive widgets.',
      milestones: [
        TaskMilestone(id: 'm3-1', title: 'Export Stitch color tokens and typography', isCompleted: true),
        TaskMilestone(id: 'm3-2', title: 'Build Dashboard and Task List screens', isCompleted: true),
        TaskMilestone(id: 'm3-3', title: 'Implement Add Task modal and Calendar tab', isCompleted: true),
        TaskMilestone(id: 'm3-4', title: 'Conduct user usability test sessions', isCompleted: false),
      ],
      attachments: [
        TaskAttachment(name: 'Stitch_Design_Spec.pdf', size: '1.2 MB', type: 'pdf'),
      ],
    ),
    TaskItem(
      id: 'task-4',
      title: 'Computer Networks Lab 3 Wireshark',
      courseCode: 'CS205',
      courseName: 'Data Communications and Networking',
      category: TaskCategory.assignment,
      dueDate: DateTime.now().add(const Duration(days: 5)),
      dueTime: '11:59 PM',
      priority: TaskPriority.low,
      status: TaskStatus.pending,
      description:
          'Capture TCP three-way handshake packets using Wireshark and document sliding window flow control mechanisms.',
      milestones: [
        TaskMilestone(id: 'm4-1', title: 'Capture pcap trace in lab environment', isCompleted: false),
        TaskMilestone(id: 'm4-2', title: 'Analyze sequence numbers and ACK packets', isCompleted: false),
      ],
      attachments: [
        TaskAttachment(name: 'Lab3_Instructions.pdf', size: '750 KB', type: 'pdf'),
      ],
    ),
    TaskItem(
      id: 'task-5',
      title: 'Technical Writing Research Proposal',
      courseCode: 'ENG102',
      courseName: 'Technical Communication & Research',
      category: TaskCategory.assignment,
      dueDate: DateTime.now().subtract(const Duration(days: 2)),
      dueTime: '3:00 PM',
      priority: TaskPriority.medium,
      status: TaskStatus.completed,
      isCompleted: true,
      description:
          'Submit 10-page academic proposal on ethical AI frameworks in university learning systems.',
      milestones: [
        TaskMilestone(id: 'm5-1', title: 'Draft literature review (15 references)', isCompleted: true),
        TaskMilestone(id: 'm5-2', title: 'Peer review and professor sign-off', isCompleted: true),
        TaskMilestone(id: 'm5-3', title: 'Final APA formatting submission', isCompleted: true),
      ],
      attachments: [
        TaskAttachment(name: 'Research_Proposal_Final.pdf', size: '3.8 MB', type: 'pdf'),
      ],
    ),
  ];

  List<TaskItem> get tasks => List.unmodifiable(_tasks);

  // Notifications Seeded from Stitch Design
  final List<NotificationItem> _notifications = [
    NotificationItem(
      id: 'n1',
      title: 'Urgent: CS301 Due in 4 Hours!',
      message: 'Algorithm Analysis Report is due tonight at 11:59 PM. Don\'t forget to upload the benchmark dataset.',
      time: '15m ago',
      type: NotificationType.deadline,
    ),
    NotificationItem(
      id: 'n2',
      title: 'Exam Alert: IT204 Midterm Quiz',
      message: 'Midterm assessment is scheduled for tomorrow at 2:00 PM in Computer Lab 3B.',
      time: '1h ago',
      type: NotificationType.exam,
    ),
    NotificationItem(
      id: 'n3',
      title: 'Course Update: IT312 Prototype',
      message: 'Professor added new evaluation guidelines for the Stitch Flutter implementation rubrics.',
      time: '3h ago',
      type: NotificationType.update,
    ),
    NotificationItem(
      id: 'n4',
      title: 'Milestone Reminder',
      message: 'You have completed 78% of your weekly milestones! Keep up the great streak.',
      time: 'Yesterday',
      type: NotificationType.reminder,
    ),
    NotificationItem(
      id: 'n5',
      title: 'Grade Released: ENG102 Proposal',
      message: 'Your research proposal received an A (98%). Great work on literature citations.',
      time: '2 days ago',
      type: NotificationType.update,
      isRead: true,
    ),
  ];

  List<NotificationItem> get notifications => List.unmodifiable(_notifications);

  int get unreadNotificationsCount => _notifications.where((n) => !n.isRead).length;

  // Selected Filter States
  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  String _statusFilter = 'All'; // All, In Progress, Pending, Completed
  String get statusFilter => _statusFilter;

  DateTime _selectedCalendarDate = DateTime.now();
  DateTime get selectedCalendarDate => _selectedCalendarDate;

  // Computed metrics
  int get totalTasksCount => _tasks.length;
  int get inProgressCount => _tasks.where((t) => !t.isCompleted && t.status == TaskStatus.inProgress).length;
  int get pendingCount => _tasks.where((t) => !t.isCompleted && t.status == TaskStatus.pending).length;
  int get completedCount => _tasks.where((t) => t.isCompleted || t.status == TaskStatus.completed).length;

  double get weeklyVelocity {
    if (_tasks.isEmpty) return 0.0;
    int totalMilestones = 0;
    int completedMilestones = 0;
    for (final t in _tasks) {
      if (t.milestones.isEmpty) {
        totalMilestones += 1;
        if (t.isCompleted) completedMilestones += 1;
      } else {
        totalMilestones += t.milestones.length;
        completedMilestones += t.milestones.where((m) => m.isCompleted).length;
      }
    }
    return totalMilestones > 0 ? (completedMilestones / totalMilestones) : 0.0;
  }

  // Filtered Tasks list
  List<TaskItem> get filteredTasks {
    return _tasks.where((task) {
      // Query filter
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchesTitle = task.title.toLowerCase().contains(q);
        final matchesCourse = task.courseCode.toLowerCase().contains(q) || task.courseName.toLowerCase().contains(q);
        final matchesDesc = task.description.toLowerCase().contains(q);
        if (!matchesTitle && !matchesCourse && !matchesDesc) return false;
      }

      // Status filter
      if (_statusFilter == 'In Progress') {
        return !task.isCompleted && task.status == TaskStatus.inProgress;
      } else if (_statusFilter == 'Pending') {
        return !task.isCompleted && task.status == TaskStatus.pending;
      } else if (_statusFilter == 'Completed') {
        return task.isCompleted || task.status == TaskStatus.completed;
      }

      return true;
    }).toList();
  }

  // Tasks for specific calendar date
  List<TaskItem> tasksForDate(DateTime date) {
    return _tasks.where((t) {
      return t.dueDate.year == date.year &&
          t.dueDate.month == date.month &&
          t.dueDate.day == date.day;
    }).toList();
  }

  // Methods
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setStatusFilter(String filter) {
    _statusFilter = filter;
    notifyListeners();
  }

  void setSelectedCalendarDate(DateTime date) {
    _selectedCalendarDate = date;
    notifyListeners();
  }

  void toggleTaskCompletion(String taskId) {
    final idx = _tasks.indexWhere((t) => t.id == taskId);
    if (idx != -1) {
      final task = _tasks[idx];
      task.isCompleted = !task.isCompleted;
      task.status = task.isCompleted ? TaskStatus.completed : TaskStatus.inProgress;
      // Also mark all milestones complete if task is marked complete
      if (task.isCompleted) {
        for (final m in task.milestones) {
          m.isCompleted = true;
        }
      }
      notifyListeners();
    }
  }

  void toggleMilestone(String taskId, String milestoneId) {
    final tIdx = _tasks.indexWhere((t) => t.id == taskId);
    if (tIdx != -1) {
      final task = _tasks[tIdx];
      final mIdx = task.milestones.indexWhere((m) => m.id == milestoneId);
      if (mIdx != -1) {
        task.milestones[mIdx].isCompleted = !task.milestones[mIdx].isCompleted;
        // If all milestones completed, mark task completed
        final allDone = task.milestones.every((m) => m.isCompleted);
        if (allDone && task.milestones.isNotEmpty) {
          task.isCompleted = true;
          task.status = TaskStatus.completed;
        } else {
          task.isCompleted = false;
          task.status = TaskStatus.inProgress;
        }
        notifyListeners();
      }
    }
  }

  void addTask(TaskItem newTask) {
    _tasks.insert(0, newTask);
    notifyListeners();
  }

  void updateTask(TaskItem updatedTask) {
    final idx = _tasks.indexWhere((t) => t.id == updatedTask.id);
    if (idx != -1) {
      _tasks[idx] = updatedTask;
      notifyListeners();
    }
  }

  void deleteTask(String taskId) {
    _tasks.removeWhere((t) => t.id == taskId);
    notifyListeners();
  }

  void markAllNotificationsRead() {
    for (final n in _notifications) {
      n.isRead = true;
    }
    notifyListeners();
  }

  void clearNotifications() {
    _notifications.clear();
    notifyListeners();
  }

  void updateProfile({
    required String name,
    required String university,
    required bool deadlineReminders,
    required bool morningBriefing,
    required bool syllabusSync,
  }) {
    _profile.name = name;
    _profile.university = university;
    _profile.deadlineReminders = deadlineReminders;
    _profile.morningBriefing = morningBriefing;
    _profile.syllabusSync = syllabusSync;
    notifyListeners();
  }
}

