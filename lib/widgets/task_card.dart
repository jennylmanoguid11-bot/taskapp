import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/task.dart';
import '../theme/app_theme.dart';
import 'circular_checkbox.dart';

class TaskCard extends StatelessWidget {
  final TaskItem task;
  final VoidCallback onTap;
  final ValueChanged<bool?> onToggleComplete;
  final VoidCallback? onDelete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    required this.onToggleComplete,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDone = task.isCompleted;

    // Priority Styling
    Color priorityBg;
    Color priorityText;
    Color priorityBorder;
    switch (task.priority) {
      case TaskPriority.high:
        priorityBg = AppTheme.highPriorityBg;
        priorityText = AppTheme.highPriorityText;
        priorityBorder = AppTheme.highPriorityBorder;
        break;
      case TaskPriority.medium:
        priorityBg = AppTheme.mediumPriorityBg;
        priorityText = AppTheme.mediumPriorityText;
        priorityBorder = AppTheme.mediumPriorityBorder;
        break;
      case TaskPriority.low:
        priorityBg = AppTheme.lowPriorityBg;
        priorityText = AppTheme.lowPriorityText;
        priorityBorder = AppTheme.lowPriorityBorder;
        break;
    }

    // Category Color
    Color catBg;
    Color catText;
    switch (task.category) {
      case TaskCategory.assignment:
        catBg = const Color(0xFFEFF6FF);
        catText = const Color(0xFF2563EB);
        break;
      case TaskCategory.quiz:
      case TaskCategory.exam:
        catBg = const Color(0xFFFAF5FF);
        catText = const Color(0xFF9333EA);
        break;
      case TaskCategory.project:
        catBg = const Color(0xFFF0FDF4);
        catText = const Color(0xFF16A34A);
        break;
      case TaskCategory.other:
        catBg = const Color(0xFFF8FAFC);
        catText = const Color(0xFF64748B);
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDone ? AppTheme.outline.withValues(alpha: 0.6) : AppTheme.outline,
          width: 1,
        ),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Meta Row: Course Badge + Priority + Overflow Menu
                Row(
                  children: [
                    // Course Pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryContainer.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        task.courseCode,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primaryDark,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Category Pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: catBg,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        task.categoryLabel,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: catText,
                        ),
                      ),
                    ),
                    const Spacer(),

                    // Priority Pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: priorityBg,
                        borderRadius: BorderRadius.circular(9999),
                        border: Border.all(color: priorityBorder, width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: priorityText,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            task.priorityLabel.replaceAll(' Priority', ''),
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: priorityText,
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (onDelete != null) ...[
                      const SizedBox(width: 4),
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_vert, size: 18, color: AppTheme.onSurfaceVariant),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onSelected: (val) {
                          if (val == 'delete') onDelete!();
                        },
                        itemBuilder: (ctx) => [
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete_outline, size: 18, color: Colors.red),
                                SizedBox(width: 8),
                                Text('Delete Task', style: TextStyle(color: Colors.red)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 12),

                // Main Title + Checkbox
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: CircularCheckbox(
                        isChecked: isDone,
                        onChanged: onToggleComplete,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            task.title,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: isDone ? AppTheme.onSurfaceVariant.withValues(alpha: 0.6) : AppTheme.onSurface,
                              decoration: isDone ? TextDecoration.lineThrough : null,
                              decorationColor: AppTheme.onSurfaceVariant,
                            ),
                          ),
                          if (task.description.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              task.description,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: AppTheme.onSurfaceVariant,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Subtask Progress Bar (if milestones exist)
                if (task.milestones.isNotEmpty) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: task.progress,
                      minHeight: 5,
                      backgroundColor: AppTheme.surfaceVariant,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        task.progress == 1.0 ? AppTheme.completedText : AppTheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],

                // Bottom Meta: Due Date + Attachments + Milestones Count
                Row(
                  children: [
                    Icon(Icons.schedule, size: 14, color: isDone ? AppTheme.onSurfaceVariant : AppTheme.primary),
                    const SizedBox(width: 4),
                    Text(
                      '${task.dueDate.month}/${task.dueDate.day} • ${task.dueTime}',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isDone ? AppTheme.onSurfaceVariant : AppTheme.onSurface,
                      ),
                    ),
                    const Spacer(),

                    // Attachments indicator
                    if (task.attachments.isNotEmpty) ...[
                      Icon(Icons.attach_file, size: 14, color: AppTheme.onSurfaceVariant),
                      const SizedBox(width: 2),
                      Text(
                        '${task.attachments.length}',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],

                    // Milestones Indicator
                    if (task.milestones.isNotEmpty) ...[
                      Icon(Icons.check_circle_outline, size: 14, color: AppTheme.onSurfaceVariant),
                      const SizedBox(width: 2),
                      Text(
                        '${task.milestones.where((m) => m.isCompleted).length}/${task.milestones.length}',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

