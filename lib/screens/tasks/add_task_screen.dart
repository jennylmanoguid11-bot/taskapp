import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../models/task.dart';
import '../../services/task_service.dart';
import '../../theme/app_theme.dart';

class AddTaskScreen extends StatefulWidget {
  final TaskService taskService;

  const AddTaskScreen({super.key, required this.taskService});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _milestoneCtrl = TextEditingController();

  String _courseCode = 'CS301';
  final Map<String, String> _courses = {
    'CS301': 'Design & Analysis of Algorithms',
    'IT204': 'Database Management Systems',
    'IT312': 'Human Computer Interaction',
    'CS205': 'Data Communications and Networking',
    'ENG102': 'Technical Writing and Research',
  };

  TaskCategory _category = TaskCategory.assignment;
  TaskPriority _priority = TaskPriority.medium;
  DateTime _dueDate = DateTime.now().add(const Duration(days: 2));
  TimeOfDay _dueTime = const TimeOfDay(hour: 23, minute: 59);

  final List<TaskMilestone> _milestones = [];
  final List<TaskAttachment> _attachments = [];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _milestoneCtrl.dispose();
    super.dispose();
  }

  void _addMilestone() {
    final text = _milestoneCtrl.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _milestones.add(TaskMilestone(
          id: 'm_${DateTime.now().millisecondsSinceEpoch}',
          title: text,
          isCompleted: false,
        ));
        _milestoneCtrl.clear();
      });
    }
  }

  void _simulateAddAttachment() {
    setState(() {
      _attachments.add(TaskAttachment(
        name: 'Assignment_Doc_${_attachments.length + 1}.pdf',
        size: '1.4 MB',
        type: 'pdf',
      ));
    });
  }

  void _saveTask() {
    if (_formKey.currentState!.validate()) {
      final formattedTime = _dueTime.format(context);
      final newTask = TaskItem(
        id: 'task_${DateTime.now().millisecondsSinceEpoch}',
        title: _titleCtrl.text.trim(),
        courseCode: _courseCode,
        courseName: _courses[_courseCode] ?? '',
        category: _category,
        dueDate: _dueDate,
        dueTime: formattedTime,
        priority: _priority,
        status: TaskStatus.inProgress,
        description: _descCtrl.text.trim(),
        milestones: _milestones,
        attachments: _attachments,
      );

      widget.taskService.addTask(newTask);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Task "${newTask.title}" created successfully!'),
          backgroundColor: AppTheme.completedText,
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add Task',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.plusJakartaSans(
                fontWeight: FontWeight.w600,
                color: AppTheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // 1. Task Title
            Text(
              'Task Title',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppTheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _titleCtrl,
              validator: (val) => val == null || val.trim().isEmpty ? 'Please enter a task title' : null,
              decoration: const InputDecoration(
                hintText: 'e.g., CS301 Algorithm Analysis Report',
              ),
            ),
            const SizedBox(height: 20),

            // 2. Course / Subject Selection
            Text(
              'Course / Subject',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppTheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.outline),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _courseCode,
                  isExpanded: true,
                  icon: const Icon(Icons.expand_more, color: AppTheme.onSurfaceVariant),
                  items: _courses.entries.map((e) {
                    return DropdownMenuItem(
                      value: e.key,
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppTheme.primaryContainer.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              e.key,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.primaryDark,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              e.value,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _courseCode = val);
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 3. Category Selector Badges
            Text(
              'Category',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppTheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildCategoryPill(TaskCategory.assignment, 'Assignment', Icons.assignment_outlined),
                _buildCategoryPill(TaskCategory.project, 'Project', Icons.terminal),
                _buildCategoryPill(TaskCategory.quiz, 'Quiz / Exam', Icons.quiz_outlined),
                _buildCategoryPill(TaskCategory.other, 'Other', Icons.bookmark_outline),
              ],
            ),
            const SizedBox(height: 20),

            // 4. Due Date & Time Picker Group
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Due Date',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _dueDate,
                            firstDate: DateTime.now().subtract(const Duration(days: 30)),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          );
                          if (picked != null) setState(() => _dueDate = picked);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          decoration: BoxDecoration(
                            color: AppTheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppTheme.outline),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today, size: 18, color: AppTheme.primary),
                              const SizedBox(width: 8),
                              Text(
                                DateFormat('MMM dd, yyyy').format(_dueDate),
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Due Time',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      InkWell(
                        onTap: () async {
                          final picked = await showTimePicker(
                            context: context,
                            initialTime: _dueTime,
                          );
                          if (picked != null) setState(() => _dueTime = picked);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                          decoration: BoxDecoration(
                            color: AppTheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppTheme.outline),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.access_time, size: 18, color: AppTheme.primary),
                              const SizedBox(width: 8),
                              Text(
                                _dueTime.format(context),
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 5. Priority Level Selector
            Text(
              'Priority Level',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppTheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildPriorityButton(TaskPriority.high, 'High', AppTheme.highPriorityBg, AppTheme.highPriorityText),
                const SizedBox(width: 10),
                _buildPriorityButton(TaskPriority.medium, 'Medium', AppTheme.mediumPriorityBg, AppTheme.mediumPriorityText),
                const SizedBox(width: 10),
                _buildPriorityButton(TaskPriority.low, 'Low', AppTheme.lowPriorityBg, AppTheme.lowPriorityText),
              ],
            ),
            const SizedBox(height: 20),

            // 6. Description / Brief
            Text(
              'Description & Guidelines',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppTheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Enter assignment brief, rubric points, or notes...',
              ),
            ),
            const SizedBox(height: 20),

            // 7. Subtasks / Milestones Checklist
            Text(
              'Milestones / Subtasks',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppTheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _milestoneCtrl,
                    onSubmitted: (_) => _addMilestone(),
                    decoration: const InputDecoration(
                      hintText: 'Add subtask milestone...',
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addMilestone,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
            if (_milestones.isNotEmpty) ...[
              const SizedBox(height: 10),
              ..._milestones.asMap().entries.map((entry) {
                final idx = entry.key;
                final m = entry.value;
                return Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceVariant.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.outline),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle_outline, size: 16, color: AppTheme.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          m.title,
                          style: GoogleFonts.inter(fontSize: 13),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, size: 16, color: AppTheme.onSurfaceVariant),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed: () {
                          setState(() => _milestones.removeAt(idx));
                        },
                      ),
                    ],
                  ),
                );
              }),
            ],
            const SizedBox(height: 20),

            // 8. Attachments Section (Dropzone)
            Text(
              'Attachments',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppTheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: _simulateAddAttachment,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceVariant.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppTheme.primary.withValues(alpha: 0.4),
                    style: BorderStyle.solid,
                    width: 1.5,
                  ),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.cloud_upload_outlined, size: 32, color: AppTheme.primary),
                    const SizedBox(height: 6),
                    Text(
                      'Tap to upload rubric, PDF, or dataset files',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.primary,
                      ),
                    ),
                    Text(
                      'Supports PDF, DOCX, CSV up to 25MB',
                      style: GoogleFonts.inter(fontSize: 11, color: AppTheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ),
            if (_attachments.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _attachments.map((att) {
                  return Chip(
                    backgroundColor: AppTheme.surfaceVariant,
                    avatar: const Icon(Icons.attach_file, size: 16),
                    label: Text('${att.name} (${att.size})'),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () {
                      setState(() => _attachments.remove(att));
                    },
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 32),

            // 9. Primary Action Button
            ElevatedButton(
              onPressed: _saveTask,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text(
                'Create Task',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryPill(TaskCategory cat, String label, IconData icon) {
    final isSelected = _category == cat;
    return GestureDetector(
      onTap: () => setState(() => _category = cat),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryContainer : AppTheme.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppTheme.primary : AppTheme.outline,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? AppTheme.primary : AppTheme.onSurfaceVariant,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppTheme.primary : AppTheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityButton(TaskPriority p, String label, Color bg, Color textColor) {
    final isSelected = _priority == p;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _priority = p),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? bg : AppTheme.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? textColor : AppTheme.outline,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? textColor : AppTheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

