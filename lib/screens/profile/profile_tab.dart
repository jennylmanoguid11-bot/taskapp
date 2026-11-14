import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/task_service.dart';
import '../../theme/app_theme.dart';
import '../auth/login_screen.dart';

class ProfileTab extends StatefulWidget {
  final TaskService taskService;

  const ProfileTab({super.key, required this.taskService});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  late TextEditingController _nameCtrl;
  late TextEditingController _universityCtrl;
  late bool _deadlineReminders;
  late bool _morningBriefing;
  late bool _syllabusSync;

  @override
  void initState() {
    super.initState();
    final p = widget.taskService.profile;
    _nameCtrl = TextEditingController(text: p.name);
    _universityCtrl = TextEditingController(text: p.university);
    _deadlineReminders = p.deadlineReminders;
    _morningBriefing = p.morningBriefing;
    _syllabusSync = p.syllabusSync;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _universityCtrl.dispose();
    super.dispose();
  }

  void _saveProfile() {
    widget.taskService.updateProfile(
      name: _nameCtrl.text.trim(),
      university: _universityCtrl.text.trim(),
      deadlineReminders: _deadlineReminders,
      morningBriefing: _morningBriefing,
      syllabusSync: _syllabusSync,
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile details updated successfully!'),
        backgroundColor: AppTheme.completedText,
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Log Out of TaskTrack?',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'You will be signed out from this device. All cached task data will remain synced to your university student account.',
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => LoginScreen(taskService: widget.taskService)),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = widget.taskService.profile;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Student Hero Profile Card (Stitch Spec)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.outline),
              boxShadow: AppTheme.cardShadow,
            ),
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 46,
                      backgroundColor: AppTheme.primaryContainer,
                      child: Text(
                        'JM',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: AppTheme.primaryDark,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: AppTheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.photo_camera, size: 14, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  profile.name,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${profile.program} • ${profile.yearLevel}',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppTheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 14),

                // Student ID Bar with copy button
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceVariant.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.badge_outlined, size: 16, color: AppTheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        'ID: ${profile.studentId}',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.onSurface,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: profile.studentId));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Student ID copied to clipboard!')),
                          );
                        },
                        child: const Icon(Icons.copy, size: 14, color: AppTheme.primary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 2. Academic Performance & Stats Bento (Stitch Spec)
          Text(
            'Academic Performance',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.onSurface,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildStatCard('Completed', '${profile.completedTasks}', Icons.task_alt, AppTheme.completedText),
              const SizedBox(width: 10),
              _buildStatCard('GPA', profile.gpa, Icons.grade_outlined, AppTheme.primary),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildStatCard('Study Streak', profile.studyStreak, Icons.local_fire_department, AppTheme.secondary),
              const SizedBox(width: 10),
              _buildStatCard('On-Time Rate', profile.onTimeRate, Icons.speed, AppTheme.tertiary),
            ],
          ),
          const SizedBox(height: 20),

          // 3. Editable Profile & University Info
          Text(
            'Institutional Details',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.onSurface,
            ),
          ),
          const SizedBox(height: 10),
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
                Text(
                  'Full Name',
                  style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(hintText: 'Student Name'),
                ),
                const SizedBox(height: 14),

                Text(
                  'University / Campus',
                  style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: _universityCtrl,
                  decoration: const InputDecoration(hintText: 'University Name'),
                ),
                const SizedBox(height: 14),

                Text(
                  'Student Email (Institutional Locked)',
                  style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceVariant.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.outline),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.lock_outline, size: 16, color: AppTheme.onSurfaceVariant),
                      const SizedBox(width: 10),
                      Text(
                        profile.email,
                        style: GoogleFonts.inter(
                          fontSize: 13,
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

          // 4. Notification & Sync Preferences
          Text(
            'Study & Notification Preferences',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.onSurface,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.outline),
              boxShadow: AppTheme.cardShadow,
            ),
            child: Material(
              color: AppTheme.surface,
              borderRadius: BorderRadius.circular(16),
              child: Column(
                children: [
                  SwitchListTile(
                    value: _deadlineReminders,
                    activeThumbColor: AppTheme.primary,
                    title: Text(
                      'Deadline Alerts',
                      style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      'Receive push alerts 4 hours before milestone dues',
                      style: GoogleFonts.inter(fontSize: 12),
                    ),
                    onChanged: (val) => setState(() => _deadlineReminders = val),
                  ),
                  const Divider(height: 1, color: AppTheme.outline),
                  SwitchListTile(
                    value: _morningBriefing,
                    activeThumbColor: AppTheme.primary,
                    title: Text(
                      'Morning Study Briefing',
                      style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      'Daily overview summary alert at 8:00 AM',
                      style: GoogleFonts.inter(fontSize: 12),
                    ),
                    onChanged: (val) => setState(() => _morningBriefing = val),
                  ),
                  const Divider(height: 1, color: AppTheme.outline),
                  SwitchListTile(
                    value: _syllabusSync,
                    activeThumbColor: AppTheme.primary,
                    title: Text(
                      'University Portal Syllabus Sync',
                      style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      'Sync automatically with Moodle / Canvas portal',
                      style: GoogleFonts.inter(fontSize: 12),
                    ),
                    onChanged: (val) => setState(() => _syllabusSync = val),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 5. Save Changes Button
          ElevatedButton(
            onPressed: _saveProfile,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              minimumSize: const Size(double.infinity, 48),
            ),
            child: Text(
              'Save Profile Changes',
              style: GoogleFonts.plusJakartaSans(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 12),

          // 6. Log Out Button
          OutlinedButton.icon(
            onPressed: _showLogoutDialog,
            icon: const Icon(Icons.logout, size: 18, color: Colors.red),
            label: Text(
              'Log Out of TaskTrack',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.red,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.red),
              padding: const EdgeInsets.symmetric(vertical: 14),
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.outline),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.onSurfaceVariant,
                  ),
                ),
                Icon(icon, size: 18, color: color),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppTheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
