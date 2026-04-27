import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../common/camera_capture_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../theme/app_theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _studentFormKey = GlobalKey<FormState>();
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  bool _isPasswordVisible = false;
  bool _isFaceCaptured = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _idController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (_tabController.index == 0) {
      if (!_studentFormKey.currentState!.validate()) return;

      if (!_isFaceCaptured) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please capture your face data first.'),
            backgroundColor: Colors.redAccent,
          ),
        );
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        String uid = userCredential.user!.uid;

        await FirebaseFirestore.instance.collection('students').doc(uid).set({
          'id': _idController.text.trim(), // Student roll number
          'name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'created_at': FieldValue.serverTimestamp(),
          // In real app, store face data URL here
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registration successful! Logging in...'),
              backgroundColor: AppTheme.accentColor,
            ),
          );
          Navigator.pop(context); // Go back or let AuthWrapper take over
        }
      } on FirebaseAuthException catch (e) {
        debugPrint('FirebaseAuthException: ${e.code} - ${e.message}');
        String message = 'Authentication error occurred.';
        if (e.code == 'weak-password') {
          message = 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          message = 'The account already exists for that email.';
        } else if (e.code == 'invalid-email') {
          message = 'The email address is badly formatted.';
        } else if (e.message != null) {
          message = e.message!;
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message), backgroundColor: Colors.red),
          );
        }
      } on FirebaseException catch (e) {
        // This catches Firestore errors like missing permissions/rules!
        debugPrint('FirebaseException [${e.plugin}]: ${e.code} - ${e.message}');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Database Error: ${e.message}'), backgroundColor: Colors.red),
          );
        }
      } catch (e, stackTrace) {
        // This catches any other unexpected Dart/Flutter error
        debugPrint('Unexpected Error: $e');
        debugPrint('Stacktrace: $stackTrace');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('An unexpected error occurred: $e'), backgroundColor: Colors.red),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    } else {
      // Teacher registration (currently skipped or mocked)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Teacher registration not fully implemented yet.')),
      );
    }
  }

  Future<void> _captureFace() async {
    final XFile? result = await Navigator.push<XFile>(
      context,
      MaterialPageRoute(builder: (context) => const CameraCaptureScreen()),
    );
    
    if (result != null) {
      setState(() {
        _isFaceCaptured = true;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Face data captured successfully.'),
            backgroundColor: AppTheme.accentColor,
          ),
        );
      }
    }
  }

  Widget _buildStudentForm() {
    return Form(
      key: _studentFormKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person_outline)),
            validator: (value) => value == null || value.trim().isEmpty ? 'Enter your name' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _idController,
            decoration: const InputDecoration(labelText: 'Student ID / Roll Number', prefixIcon: Icon(Icons.badge_outlined)),
            validator: (value) => value == null || value.trim().isEmpty ? 'Enter your ID' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(labelText: 'Email Address', prefixIcon: Icon(Icons.email_outlined)),
            keyboardType: TextInputType.emailAddress,
            validator: (value) => value == null || !value.contains('@') ? 'Enter a valid email' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock_outline),
              suffixIcon: IconButton(
                icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.white70),
                onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
              ),
            ),
            obscureText: !_isPasswordVisible,
            validator: (value) => value == null || value.length < 6 ? 'Password must be at least 6 characters' : null,
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              border: Border.all(
                color: _isFaceCaptured ? AppTheme.accentColor : AppTheme.primaryColor.withOpacity(0.5), 
                width: 1
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Icon(
                  _isFaceCaptured ? Icons.check_circle : Icons.face_retouching_natural, 
                  size: 40, 
                  color: _isFaceCaptured ? AppTheme.accentColor : AppTheme.primaryColor
                ),
                const SizedBox(height: 8),
                const Text('Face Data Setup', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(
                  _isFaceCaptured ? 'Face captured successfully' : 'Required for attendance', 
                  style: TextStyle(
                    fontSize: 12, 
                    color: _isFaceCaptured ? AppTheme.accentColor : Colors.white70
                  )
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: _captureFace,
                  icon: Icon(_isFaceCaptured ? Icons.replay : Icons.camera_alt),
                  label: Text(_isFaceCaptured ? 'Retake Face' : 'Capture Face'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _isFaceCaptured ? AppTheme.accentColor : AppTheme.primaryColor,
                    side: BorderSide(color: _isFaceCaptured ? AppTheme.accentColor : AppTheme.primaryColor),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: _isLoading 
                ? const Center(child: CircularProgressIndicator()) 
                : ElevatedButton(
                    onPressed: _handleRegister,
                    child: const Text('Register as Student', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeacherForm() {
    return Column(
      children: [
        const TextField(
          decoration: InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person_outline)),
        ),
        const SizedBox(height: 16),
        const TextField(
          decoration: InputDecoration(labelText: 'Email Address', prefixIcon: Icon(Icons.email_outlined)),
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 16),
        TextField(
          decoration: InputDecoration(
            labelText: 'Password',
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(_isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.white70),
              onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
            ),
          ),
          obscureText: !_isPasswordVisible,
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Teacher registration not implemented here.')));
            },
            child: const Text('Register as Teacher', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Account'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: TabBar(
                  controller: _tabController,
                  dividerColor: Colors.transparent,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: AppTheme.primaryColor,
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  tabs: const [
                    Tab(text: 'Student'),
                    Tab(text: 'Teacher'),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                    child: _buildStudentForm(),
                  ),
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                    child: _buildTeacherForm(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
