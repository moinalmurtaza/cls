import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/student/student_dashboard.dart';
import 'screens/student/update_info_screen.dart';
import 'screens/teacher/teacher_dashboard.dart';
import 'screens/teacher/attendance_camera_screen.dart';
import 'screens/teacher/verify_updates_screen.dart';

void main() {
  runApp(const SmartAttendanceApp());
}

class SmartAttendanceApp extends StatelessWidget {
  const SmartAttendanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Attendance',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/student_dashboard': (context) => const StudentDashboard(),
        '/student_update_info': (context) => const UpdateInfoScreen(),
        '/teacher_dashboard': (context) => const TeacherDashboard(),
        '/teacher_camera': (context) => const AttendanceCameraScreen(),
        '/teacher_verify': (context) => const VerifyUpdatesScreen(),
      },
    );
  }
}
