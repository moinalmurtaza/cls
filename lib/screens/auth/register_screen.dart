import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../theme/app_theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isPasswordVisible = false;
  final ImagePicker _picker = ImagePicker();
  bool _isFaceCaptured = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (_tabController.index == 0 && !_isFaceCaptured) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please capture your face data first.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    // Navigate back to login with a mock success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Registration successful! Please login.'),
        backgroundColor: AppTheme.accentColor,
      ),
    );
    Navigator.pop(context);
  }

  Future<void> _captureFace() async {
    try {
      // First try to open the camera
      XFile? image;
      try {
        image = await _picker.pickImage(
          source: ImageSource.camera,
          preferredCameraDevice: CameraDevice.front,
        );
      } catch (e) {
        // Fallback to gallery (file picker) if camera is not supported (e.g. on Windows desktop)
        image = await _picker.pickImage(
          source: ImageSource.gallery,
        );
      }
      
      if (image != null) {
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
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Action failed: $e'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  Widget _buildStudentForm() {
    return Column(
      children: [
        const TextField(
          decoration: InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person_outline)),
        ),
        const SizedBox(height: 16),
        const TextField(
          decoration: InputDecoration(labelText: 'Student ID / Roll Number', prefixIcon: Icon(Icons.badge_outlined)),
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
        const SizedBox(height: 24),
        // Mock Face Data Upload
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
          child: ElevatedButton(
            onPressed: _handleRegister,
            child: const Text('Register as Student', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
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
            onPressed: _handleRegister,
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
                padding: const EdgeInsets.all(4), // Add inner padding
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor,
                  borderRadius: BorderRadius.circular(30), // Fully rounded pill shape
                ),
                child: TabBar(
                  controller: _tabController,
                  dividerColor: Colors.transparent, // Remove imperfect bottom line
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(30), // Fully rounded pill shape
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
