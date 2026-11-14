class StudentProfile {
  String name;
  String program;
  String yearLevel;
  String studentId;
  String university;
  String email;
  String gpa;
  int completedTasks;
  String onTimeRate;
  String studyStreak;
  bool deadlineReminders;
  bool morningBriefing;
  bool syllabusSync;

  StudentProfile({
    required this.name,
    required this.program,
    required this.yearLevel,
    required this.studentId,
    required this.university,
    required this.email,
    required this.gpa,
    required this.completedTasks,
    required this.onTimeRate,
    required this.studyStreak,
    this.deadlineReminders = true,
    this.morningBriefing = true,
    this.syllabusSync = false,
  });
}

