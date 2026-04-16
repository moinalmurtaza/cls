import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class StudentDashboard extends StatelessWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
                      child: const Icon(Icons.person, size: 40, color: AppTheme.primaryColor),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('John Doe', style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 24)),
                          const SizedBox(height: 4),
                          const Text('ID: CS-2023-045', style: TextStyle(color: Colors.white70)),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.accentColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text('Active', style: TextStyle(color: AppTheme.accentColor, fontSize: 12)),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            
            // Stats Row
            Row(
              children: [
                Expanded(child: _buildStatCard(context, 'Attendance', '85%', Icons.check_circle_outline, AppTheme.accentColor)),
                const SizedBox(width: 16),
                Expanded(child: _buildStatCard(context, 'Total Classes', '40', Icons.class_outlined, Colors.orangeAccent)),
              ],
            ),
            const SizedBox(height: 32),

            // Actions
            Text('Quick Actions', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildActionTile(
              context,
              icon: Icons.edit_document,
              title: 'Update Information',
              subtitle: 'Request to change profile or face data',
              onTap: () {
                Navigator.pushNamed(context, '/student_update_info');
              },
            ),
            const SizedBox(height: 12),
            _buildActionTile(
              context,
              icon: Icons.history,
              title: 'Attendance History',
              subtitle: 'View detailed presence log',
              onTap: () {
                // Implement history view if needed
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Coming soon')));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(fontSize: 14, color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _buildActionTile(BuildContext context, {required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return ListTile(
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      tileColor: AppTheme.surfaceColor,
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppTheme.primaryColor),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: const TextStyle(color: Colors.white60, fontSize: 12)),
      trailing: const Icon(Icons.chevron_right, color: Colors.white54),
    );
  }
}
