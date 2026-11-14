import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../models/task.dart';
import '../../services/task_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/circular_checkbox.dart';

class TaskDetailsScreen extends StatefulWidget {
  final String taskId;
  final TaskService taskService;

  const TaskDetailsScreen({
    super.key,
    required this.taskId,
    required this.taskService,
  });

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final taskService = widget.taskService;
    final taskIndex = taskService.tasks.indexWhere((t) => t.id == widget.taskId);

    if (taskIndex == -1) {
      return Scaffold(
        appBar: AppBar(title: const Text('Task Details')),
        body: const Center(child: Text('Task not found')),
      );
    }

    final task = taskService.tasks[taskIndex];
    final progressPercent = (task.progress * 100).toInt();

    // Priority Styling
    Color priorityBg;
    Color priorityText;
    switch (task.priority) {
      case TaskPriority.high:
        priorityBg = AppTheme.highPriorityBg;
        priorityText = AppTheme.highPriorityText;
        break;
      case TaskPriority.medium:
        priorityBg = AppTheme.mediumPriorityBg;
        priorityText = AppTheme.mediumPriorityText;
        break;
      case TaskPriority.low:
        priorityBg = AppTheme.lowPriorityBg;
        priorityText = AppTheme.lowPriorityText;
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Task Details',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Task link copied to clipboard!')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () => _confirmDelete(context, task),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // 1. Course Badge & Status Metadata Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppTheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  task.courseCode,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.primaryDark,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: priorityBg,
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Text(
                  task.priorityLabel,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: priorityText,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 2. Task Title & Course Name
          Text(
            task.title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppTheme.onSurface,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            task.courseName,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppTheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 18),

          // 3. Hero Due Date & Time Sensitive Alert Box (Stitch Design Spec)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: task.priority == TaskPriority.high && !task.isCompleted
                    ? [const Color(0xFFFEF2F2), const Color(0xFFFFF1F2)]
                    : [AppTheme.surfaceVariant.withValues(alpha: 0.6), AppTheme.surface],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: task.priority == TaskPriority.high && !task.isCompleted
                    ? AppTheme.highPriorityBorder
                    : AppTheme.outline,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: task.priority == TaskPriority.high && !task.isCompleted
                        ? AppTheme.highPriorityBg
                        : AppTheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.alarm,
                    size: 22,
                    color: task.priority == TaskPriority.high && !task.isCompleted
                        ? AppTheme.highPriorityText
                        : AppTheme.primary,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.isCompleted
                            ? 'Task Completed 🎉'
                            : 'Due ${DateFormat('EEEE, MMM d').format(task.dueDate)} • ${task.dueTime}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: task.isCompleted ? AppTheme.completedText : AppTheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        task.isCompleted
                            ? 'All milestones reached on time.'
                            : 'Submitted via University Academic Portal.',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppTheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // 4. Description Area
          Text(
            'Assignment Brief & Objectives',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppTheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.outline),
            ),
            child: Text(
              task.description.isNotEmpty
                  ? task.description
                  : 'No detailed instructions provided for this task.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.onSurface,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 5. Subtasks / Milestones Checklist
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Milestones Checklist',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.onSurface,
                ),
              ),
              Text(
                '$progressPercent% Completed',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: task.progress,
              minHeight: 8,
              backgroundColor: AppTheme.surfaceVariant,
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
            ),
          ),
          const SizedBox(height: 12),

          // Milestones List
          if (task.milestones.isEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.outline),
              ),
              child: Text(
                'No subtasks created for this task yet.',
                style: GoogleFonts.inter(fontSize: 13, color: AppTheme.onSurfaceVariant),
              ),
            )
          else
            ...task.milestones.map((m) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: m.isCompleted ? AppTheme.outline.withValues(alpha: 0.6) : AppTheme.outline,
                  ),
                ),
                child: Row(
                  children: [
                    CircularCheckbox(
                      isChecked: m.isCompleted,
                      onChanged: (val) {
                        setState(() {
                          taskService.toggleMilestone(task.id, m.id);
                        });
                      },
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        m.title,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: m.isCompleted ? FontWeight.w400 : FontWeight.w500,
                          decoration: m.isCompleted ? TextDecoration.lineThrough : null,
                          color: m.isCompleted ? AppTheme.onSurfaceVariant : AppTheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),

          const SizedBox(height: 24),

          // 6. Attachments Section
          Text(
            'Course Attachments & Resources',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppTheme.onSurface,
            ),
          ),
          const SizedBox(height: 10),
          if (task.attachments.isEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.outline),
              ),
              child: Text(
                'No files attached.',
                style: GoogleFonts.inter(fontSize: 13, color: AppTheme.onSurfaceVariant),
              ),
            )
          else
            ...task.attachments.map((att) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.outline),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryContainer.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.picture_as_pdf, color: AppTheme.primary, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            att.name,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.onSurface,
                            ),
                          ),
                          Text(
                            att.size,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppTheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.download_rounded, color: AppTheme.primary),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Downloading ${att.name}...'),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            }),

          const SizedBox(height: 32),

          // 7. Action Buttons
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                taskService.toggleTaskCompletion(task.id);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    task.isCompleted ? 'Marked task as completed!' : 'Re-opened task.',
                  ),
                  backgroundColor: task.isCompleted ? AppTheme.completedText : AppTheme.primary,
                ),
              );
            },
            icon: Icon(task.isCompleted ? Icons.replay : Icons.check_circle_outline),
            label: Text(
              task.isCompleted ? 'Re-open Task' : 'Mark as Completed',
              style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: task.isCompleted ? AppTheme.secondary : AppTheme.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, TaskItem task) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Delete Task?',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Are you sure you want to delete "${task.title}"? This action cannot be undone.',
          style: GoogleFonts.inter(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              widget.taskService.deleteTask(task.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

