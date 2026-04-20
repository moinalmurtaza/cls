import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/teacher_login_screen.dart';
import 'screens/auth/register_screen.dart';
import 'screens/student/student_dashboard.dart';
import 'screens/student/update_info_screen.dart';
import 'screens/teacher/teacher_dashboard.dart';
import 'screens/teacher/attendance_camera_screen.dart';
import 'screens/teacher/verify_updates_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        '/auth_wrapper': (context) => const AuthWrapper(),
        '/login': (context) => const LoginScreen(),
        '/teacher_login': (context) => const TeacherLoginScreen(),
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

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          User? user = snapshot.data;
          if (user == null) {
            return const LoginScreen();
          }
          return const StudentDashboard();
        }
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
