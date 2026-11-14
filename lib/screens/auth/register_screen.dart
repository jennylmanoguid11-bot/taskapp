import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/task_service.dart';
import '../../theme/app_theme.dart';
import '../home_shell.dart';

class RegisterScreen extends StatefulWidget {
  final TaskService taskService;

  const RegisterScreen({super.key, required this.taskService});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameCtrl = TextEditingController();
  final _idCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _agreeTerms = true;
  String _program = 'BS Computer Science';

  @override
  void dispose() {
    _nameCtrl.dispose();
    _idCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _register() {
    if (!_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please accept the Academic Privacy Terms to continue.')),
      );
      return;
    }

    if (_nameCtrl.text.isNotEmpty) {
      widget.taskService.profile.name = _nameCtrl.text.trim();
    }
    if (_idCtrl.text.isNotEmpty) {
      widget.taskService.profile.studentId = _idCtrl.text.trim();
    }
    widget.taskService.profile.program = _program;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => HomeShell(taskService: widget.taskService)),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Register Account',
          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Create Your Account 🎓',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.onSurface,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Join TaskTrack to organize your semester courses, milestones, and deadlines.',
                style: GoogleFonts.inter(fontSize: 13, color: AppTheme.onSurfaceVariant),
              ),
              const SizedBox(height: 24),

              Text('Full Name', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              TextField(
                controller: _nameCtrl,
                decoration: const InputDecoration(hintText: 'e.g., Ma. Jennyl Manoguid'),
              ),
              const SizedBox(height: 16),

              Text('Student ID Number', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              TextField(
                controller: _idCtrl,
                decoration: const InputDecoration(hintText: 'e.g., 2023-08492'),
              ),
              const SizedBox(height: 16),

              Text('Academic Program', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: _program,
                decoration: const InputDecoration(),
                items: [
                  'BS Computer Science',
                  'BS Information Technology',
                  'BS Computer Engineering',
                  'BS Information Systems',
                ].map((p) => DropdownMenuItem(value: p, child: Text(p, style: GoogleFonts.inter(fontSize: 13)))).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _program = val);
                },
              ),
              const SizedBox(height: 16),

              Text('University Email', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              TextField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: 'student@university.edu'),
              ),
              const SizedBox(height: 16),

              Text('Password', style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordCtrl,
                obscureText: true,
                decoration: const InputDecoration(hintText: '••••••••'),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Checkbox(
                    value: _agreeTerms,
                    activeColor: AppTheme.primary,
                    onChanged: (val) => setState(() => _agreeTerms = val ?? false),
                  ),
                  Expanded(
                    child: Text(
                      'I agree to the University Academic Privacy Policy & Terms of Service.',
                      style: GoogleFonts.inter(fontSize: 12, color: AppTheme.onSurfaceVariant),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _register,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Create Account',
                      style: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward, size: 18),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already registered?', style: GoogleFonts.inter(fontSize: 13, color: AppTheme.onSurfaceVariant)),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        'Log In',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
