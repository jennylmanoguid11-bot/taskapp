import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/notification_item.dart';
import '../../services/task_service.dart';
import '../../theme/app_theme.dart';

class NotificationsTab extends StatefulWidget {
  final TaskService taskService;

  const NotificationsTab({super.key, required this.taskService});

  @override
  State<NotificationsTab> createState() => _NotificationsTabState();
}

class _NotificationsTabState extends State<NotificationsTab> {
  String _activeFilter = 'All'; // All, Deadlines, Updates, Reminders

  @override
  Widget build(BuildContext context) {
    final taskService = widget.taskService;
    final notifications = taskService.notifications;

    final filtered = notifications.where((n) {
      if (_activeFilter == 'Deadlines') return n.type == NotificationType.deadline;
      if (_activeFilter == 'Updates') return n.type == NotificationType.update;
      if (_activeFilter == 'Reminders') return n.type == NotificationType.reminder;
      return true;
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Header Summary Strip (Stitch Spec)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.outline),
              boxShadow: AppTheme.cardShadow,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryContainer.withValues(alpha: 0.6),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.notifications_active, color: AppTheme.primary, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Push Alerts Active',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.onSurface,
                        ),
                      ),
                      Text(
                        '${taskService.unreadNotificationsCount} unread notices',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppTheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton.icon(
                  onPressed: () {
                    taskService.markAllNotificationsRead();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('All notifications marked as read.')),
                    );
                  },
                  icon: const Icon(Icons.done_all, size: 16),
                  label: Text(
                    'Mark Read',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    foregroundColor: AppTheme.primary,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // 2. Filter Pills Bar
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterPill('All', notifications.length),
                const SizedBox(width: 8),
                _buildFilterPill(
                  'Deadlines',
                  notifications.where((n) => n.type == NotificationType.deadline).length,
                ),
                const SizedBox(width: 8),
                _buildFilterPill(
                  'Updates',
                  notifications.where((n) => n.type == NotificationType.update).length,
                ),
                const SizedBox(width: 8),
                _buildFilterPill(
                  'Reminders',
                  notifications.where((n) => n.type == NotificationType.reminder).length,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 3. Notifications Feed
          if (filtered.isEmpty)
            Container(
              padding: const EdgeInsets.all(32),
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.outline),
              ),
              child: Column(
                children: [
                  const Icon(Icons.notifications_off_outlined, size: 40, color: AppTheme.onSurfaceVariant),
                  const SizedBox(height: 12),
                  Text(
                    'No notifications in this category',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            )
          else
            ...filtered.map((item) => _buildNotificationCard(item)),

          const SizedBox(height: 16),

          // 4. Push Notification Test & Trigger Card (Stitch Spec)
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.primaryContainer.withValues(alpha: 0.4),
                  AppTheme.surface,
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.primaryContainer),
            ),
            child: Row(
              children: [
                const Icon(Icons.cell_tower, color: AppTheme.primary, size: 28),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Test Push Notification',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.onSurface,
                        ),
                      ),
                      Text(
                        'Simulate an instant deadline alert toast.',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppTheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Row(
                          children: [
                            Icon(Icons.alarm, color: Colors.white, size: 18),
                            SizedBox(width: 10),
                            Expanded(child: Text('Reminder: Algorithm Analysis report due in 4 hours!')),
                          ],
                        ),
                        backgroundColor: AppTheme.primary,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  ),
                  child: Text(
                    'Test Alert',
                    style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildFilterPill(String title, int count) {
    final isSelected = _activeFilter == title;
    return GestureDetector(
      onTap: () => setState(() => _activeFilter = title),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary : AppTheme.surface,
          borderRadius: BorderRadius.circular(9999),
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.outline,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? Colors.white : AppTheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white.withValues(alpha: 0.25) : AppTheme.surfaceVariant,
                borderRadius: BorderRadius.circular(9999),
              ),
              child: Text(
                '$count',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : AppTheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItem item) {
    IconData icon;
    Color iconColor;
    Color iconBg;

    switch (item.type) {
      case NotificationType.deadline:
        icon = Icons.alarm;
        iconColor = AppTheme.highPriorityText;
        iconBg = AppTheme.highPriorityBg;
        break;
      case NotificationType.exam:
        icon = Icons.quiz_outlined;
        iconColor = AppTheme.secondary;
        iconBg = AppTheme.secondaryContainer;
        break;
      case NotificationType.update:
        icon = Icons.update;
        iconColor = AppTheme.primary;
        iconBg = AppTheme.primaryContainer;
        break;
      case NotificationType.reminder:
        icon = Icons.lightbulb_outline;
        iconColor = AppTheme.mediumPriorityText;
        iconBg = AppTheme.mediumPriorityBg;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: item.isRead ? AppTheme.surface : AppTheme.surfaceVariant.withValues(alpha: 0.35),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: item.isRead ? AppTheme.outline : AppTheme.primary.withValues(alpha: 0.3),
        ),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: item.isRead ? FontWeight.w600 : FontWeight.w700,
                          color: AppTheme.onSurface,
                        ),
                      ),
                    ),
                    Text(
                      item.time,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppTheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  item.message,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppTheme.onSurfaceVariant,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

