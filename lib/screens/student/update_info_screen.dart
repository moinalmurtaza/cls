import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../theme/app_theme.dart';

class UpdateInfoScreen extends StatefulWidget {
  const UpdateInfoScreen({super.key});

  @override
  State<UpdateInfoScreen> createState() => _UpdateInfoScreenState();
}

class _UpdateInfoScreenState extends State<UpdateInfoScreen> {
  bool _requestPending = false;
  final ImagePicker _picker = ImagePicker();
  bool _isFaceCaptured = false;

  Future<void> _captureFace() async {
    try {
      // Try camera first
      XFile? image;
      try {
        image = await _picker.pickImage(
          source: ImageSource.camera,
          preferredCameraDevice: CameraDevice.front,
        );
      } catch (e) {
        // Fallback to gallery
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
              content: Text('New face data captured successfully.'),
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

  void _submitRequest() {
    setState(() {
      _requestPending = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Update request submitted. Pending teacher approval.'),
        backgroundColor: AppTheme.primaryColor,
      ),
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Information'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orangeAccent.withOpacity(0.1),
                border: Border.all(color: Colors.orangeAccent),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.orangeAccent),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Any updates to your profile or face data must be verified and approved by a teacher.',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const TextField(
              decoration: InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person_outline)),
            ),
            const SizedBox(height: 16),
            const TextField(
              decoration: InputDecoration(labelText: 'Contact Number', prefixIcon: Icon(Icons.phone_outlined)),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.surfaceColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Text('Update Face Data', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppTheme.backgroundColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppTheme.primaryColor, width: 2),
                        ),
                        child: const Icon(Icons.person, size: 40, color: AppTheme.primaryColor),
                      ),
                      const Icon(Icons.arrow_forward, color: Colors.white54),
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppTheme.backgroundColor,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: _isFaceCaptured ? AppTheme.accentColor : Colors.white24,
                            width: _isFaceCaptured ? 2 : 1,
                          ),
                        ),
                        child: Icon(
                          _isFaceCaptured ? Icons.check_circle : Icons.camera_alt, 
                          color: _isFaceCaptured ? AppTheme.accentColor : Colors.white54,
                          size: _isFaceCaptured ? 40 : 24,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: _captureFace,
                    icon: Icon(_isFaceCaptured ? Icons.replay : Icons.camera_alt),
                    label: Text(_isFaceCaptured ? 'Retake New Face Data' : 'Capture New Face Data'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _isFaceCaptured ? AppTheme.accentColor : AppTheme.primaryColor,
                      side: BorderSide(color: _isFaceCaptured ? AppTheme.accentColor : AppTheme.primaryColor),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _requestPending ? null : _submitRequest,
              child: _requestPending
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                  : const Text('Submit Request for Approval', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
