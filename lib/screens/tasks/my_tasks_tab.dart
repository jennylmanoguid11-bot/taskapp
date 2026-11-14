import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/task_service.dart';
import '../../theme/app_theme.dart';
import '../../widgets/filter_chip_item.dart';
import '../../widgets/task_card.dart';
import 'task_details_screen.dart';

class MyTasksTab extends StatefulWidget {
  final TaskService taskService;

  const MyTasksTab({
    super.key,
    required this.taskService,
  });

  @override
  State<MyTasksTab> createState() => _MyTasksTabState();
}

class _MyTasksTabState extends State<MyTasksTab> {
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchCtrl.text = widget.taskService.searchQuery;
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final taskService = widget.taskService;
    final filtered = taskService.filteredTasks;

    return Column(
      children: [
        // Top Sticky Controls Container
        Container(
          color: AppTheme.surface,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Column(
            children: [
              // Search Bar with instant clear and mic icon
              Container(
                decoration: BoxDecoration(
                  color: AppTheme.surfaceVariant.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.outline),
                ),
                child: TextField(
                  controller: _searchCtrl,
                  onChanged: (val) {
                    setState(() {
                      taskService.setSearchQuery(val);
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Search tasks, courses, tags...',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppTheme.onSurfaceVariant.withValues(alpha: 0.7),
                    ),
                    prefixIcon: const Icon(Icons.search, color: AppTheme.onSurfaceVariant, size: 20),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_searchCtrl.text.isNotEmpty)
                          IconButton(
                            icon: const Icon(Icons.clear, size: 18, color: AppTheme.onSurfaceVariant),
                            onPressed: () {
                              _searchCtrl.clear();
                              taskService.setSearchQuery('');
                              setState(() {});
                            },
                          ),
                        IconButton(
                          icon: const Icon(Icons.mic_none, size: 20, color: AppTheme.primary),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Voice search activated... (Listening)'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    filled: false,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Filter & Segmentation Pills Carousel (All, In Progress, Pending, Completed)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    FilterChipItem(
                      label: 'All',
                      count: taskService.totalTasksCount,
                      isSelected: taskService.statusFilter == 'All',
                      onTap: () => taskService.setStatusFilter('All'),
                    ),
                    const SizedBox(width: 8),
                    FilterChipItem(
                      label: 'In Progress',
                      count: taskService.inProgressCount,
                      isSelected: taskService.statusFilter == 'In Progress',
                      onTap: () => taskService.setStatusFilter('In Progress'),
                    ),
                    const SizedBox(width: 8),
                    FilterChipItem(
                      label: 'Pending',
                      count: taskService.pendingCount,
                      isSelected: taskService.statusFilter == 'Pending',
                      onTap: () => taskService.setStatusFilter('Pending'),
                    ),
                    const SizedBox(width: 8),
                    FilterChipItem(
                      label: 'Completed',
                      count: taskService.completedCount,
                      isSelected: taskService.statusFilter == 'Completed',
                      onTap: () => taskService.setStatusFilter('Completed'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const Divider(height: 1, color: AppTheme.outline),

        // Tasks List Feed
        Expanded(
          child: filtered.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryContainer.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.assignment_outlined, size: 48, color: AppTheme.primary),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No tasks found',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _searchCtrl.text.isNotEmpty
                              ? 'Try adjusting your search query or clear the filter.'
                              : 'No tasks currently under this status filter.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: AppTheme.onSurfaceVariant,
                          ),
                        ),
                        if (_searchCtrl.text.isNotEmpty || taskService.statusFilter != 'All') ...[
                          const SizedBox(height: 16),
                          OutlinedButton(
                            onPressed: () {
                              _searchCtrl.clear();
                              taskService.setSearchQuery('');
                              taskService.setStatusFilter('All');
                            },
                            child: const Text('Reset All Filters'),
                          ),
                        ],
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  itemCount: filtered.length,
                  itemBuilder: (ctx, idx) {
                    final task = filtered[idx];
                    return TaskCard(
                      task: task,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => TaskDetailsScreen(
                              taskId: task.id,
                              taskService: taskService,
                            ),
                          ),
                        );
                      },
                      onToggleComplete: (val) => taskService.toggleTaskCompletion(task.id),
                      onDelete: () => taskService.deleteTask(task.id),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

