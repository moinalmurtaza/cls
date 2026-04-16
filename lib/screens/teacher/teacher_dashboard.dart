import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class TeacherDashboard extends StatelessWidget {
  const TeacherDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Welcome, Prof. Smith',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            const Text('Manage your classes and student records', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 32),
            
            // Start Attendance Large Button Action
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/teacher_camera'),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.primaryColor, Color(0xFF5149D2)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryColor.withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Column(
                  children: [
                    Icon(Icons.camera_alt, size: 60, color: Colors.white),
                    SizedBox(height: 16),
                    Text('Start Attendance', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                    SizedBox(height: 8),
                    Text('Scan faces to mark attendance', style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            const Text('Administrative Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: CircleAvatar(
                  backgroundColor: Colors.orangeAccent.withOpacity(0.2),
                  child: const Icon(Icons.verified_user_outlined, color: Colors.orangeAccent),
                ),
                title: const Text('Verify Student Updates', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('3 pending approval requests', style: TextStyle(fontSize: 12)),
                trailing: const Icon(Icons.chevron_right, color: Colors.white54),
                onTap: () => Navigator.pushNamed(context, '/teacher_verify'),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: CircleAvatar(
                  backgroundColor: AppTheme.accentColor.withOpacity(0.2),
                  child: const Icon(Icons.list_alt, color: AppTheme.accentColor),
                ),
                title: const Text('Semester Final Logs', style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: const Text('View exported attendance data', style: TextStyle(fontSize: 12)),
                trailing: const Icon(Icons.chevron_right, color: Colors.white54),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Coming soon')));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
