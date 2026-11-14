import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/task_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/metric_bento_card.dart';
import '../../widgets/task_card.dart';
import '../tasks/task_details_screen.dart';

class DashboardTab extends StatelessWidget {
  final TaskService taskService;
  final VoidCallback onNavigateToTasks;
  final VoidCallback onNavigateToCalendar;

  const DashboardTab({
    super.key,
    required this.taskService,
    required this.onNavigateToTasks,
    required this.onNavigateToCalendar,
  });

  @override
  Widget build(BuildContext context) {
    final profile = taskService.profile;
    final velocityPercent = (taskService.weeklyVelocity * 100).toInt();
    final upcomingTasks = taskService.tasks.where((t) => !t.isCompleted).take(3).toList();
    final recentTasks = taskService.tasks.take(2).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Welcome & Profile Header Banner (Stitch Gradient Spec)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  AppTheme.primary,
                  AppTheme.primaryDark,
                  AppTheme.secondary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primary.withValues(alpha: 0.35),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Stack(
              children: [
                // Atmospheric blur shapes
                Positioned(
                  right: -20,
                  top: -20,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.12),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          child: Text(
                            '${profile.program} • ${profile.yearLevel}',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.school, size: 16, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Good morning, Jennyl! 👋',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'You\'re $velocityPercent% through this week\'s milestones. Keep the momentum going!',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.9),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 2. Weekly Velocity Progress Card
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.outline),
              boxShadow: AppTheme.cardShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryContainer.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.trending_up, size: 18, color: AppTheme.primary),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Weekly Milestone Velocity',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.onSurface,
                              ),
                            ),
                            Text(
                              'Sprint Goal Progress',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppTheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      '$velocityPercent%',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: taskService.weeklyVelocity,
                    minHeight: 10,
                    backgroundColor: AppTheme.surfaceVariant,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primary),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '14 of 18 Milestones Achieved',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      '4 Pending',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.pendingText,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 3. Bento Metrics Grid (4 Cards: Total, In Progress, Pending, Completed)
          Row(
            children: [
              MetricBentoCard(
                title: 'Total Tasks',
                value: '${taskService.totalTasksCount}',
                icon: Icons.assignment_outlined,
                iconColor: AppTheme.primary,
                iconBgColor: AppTheme.primaryContainer.withValues(alpha: 0.6),
                onTap: onNavigateToTasks,
              ),
              const SizedBox(width: 12),
              MetricBentoCard(
                title: 'In Progress',
                value: '${taskService.inProgressCount}',
                icon: Icons.timelapse,
                iconColor: AppTheme.secondary,
                iconBgColor: AppTheme.secondaryContainer.withValues(alpha: 0.6),
                onTap: () {
                  taskService.setStatusFilter('In Progress');
                  onNavigateToTasks();
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              MetricBentoCard(
                title: 'Pending',
                value: '${taskService.pendingCount}',
                icon: Icons.hourglass_top,
                iconColor: AppTheme.mediumPriorityText,
                iconBgColor: AppTheme.mediumPriorityBg,
                onTap: () {
                  taskService.setStatusFilter('Pending');
                  onNavigateToTasks();
                },
              ),
              const SizedBox(width: 12),
              MetricBentoCard(
                title: 'Completed',
                value: '${taskService.completedCount}',
                icon: Icons.check_circle_outline,
                iconColor: AppTheme.completedText,
                iconBgColor: AppTheme.completedBg,
                onTap: () {
                  taskService.setStatusFilter('Completed');
                  onNavigateToTasks();
                },
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 4. Upcoming Deadlines Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    'Upcoming Deadlines',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.onSurface,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.highPriorityBg,
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Text(
                      '${upcomingTasks.length}',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.highPriorityText,
                      ),
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                onPressed: onNavigateToTasks,
                style: TextButton.styleFrom(
                  foregroundColor: AppTheme.primary,
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                ),
                label: const Icon(Icons.chevron_right, size: 18),
                icon: Text(
                  'View All',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Deadline Cards List
          ...upcomingTasks.map((t) => TaskCard(
                task: t,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => TaskDetailsScreen(
                        taskId: t.id,
                        taskService: taskService,
                      ),
                    ),
                  );
                },
                onToggleComplete: (val) => taskService.toggleTaskCompletion(t.id),
                onDelete: () => taskService.deleteTask(t.id),
              )),

          const SizedBox(height: 16),

          // 5. Focus Mode Recommendation Card (Stitch Spec)
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.tertiaryContainer.withValues(alpha: 0.5),
                  AppTheme.surface,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.outline),
              boxShadow: AppTheme.cardShadow,
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.tertiary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.timer_outlined, color: AppTheme.tertiary, size: 24),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Focus Mode Recommended',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Start a 25m Pomodoro study sprint for CS301 Algorithm Analysis.',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppTheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Pomodoro 25-minute timer started! Good luck studying.'),
                        backgroundColor: AppTheme.primary,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.tertiary,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Start',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 6. Recently Added Section
          Text(
            'Recently Added',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              color: AppTheme.onSurface,
            ),
          ),
          const SizedBox(height: 10),
          ...recentTasks.map((t) => TaskCard(
                task: t,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => TaskDetailsScreen(
                        taskId: t.id,
                        taskService: taskService,
                      ),
                    ),
                  );
                },
                onToggleComplete: (val) => taskService.toggleTaskCompletion(t.id),
                onDelete: () => taskService.deleteTask(t.id),
              )),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
