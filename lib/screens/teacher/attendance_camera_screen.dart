import 'package:flutter/material.dart';
import 'dart:async';
import '../../theme/app_theme.dart';

class AttendanceCameraScreen extends StatefulWidget {
  const AttendanceCameraScreen({super.key});

  @override
  State<AttendanceCameraScreen> createState() => _AttendanceCameraScreenState();
}

class _AttendanceCameraScreenState extends State<AttendanceCameraScreen> {
  bool _isScanning = true;
  List<Map<String, String>> _detectedStudents = [];

  @override
  void initState() {
    super.initState();
    _mockFaceDetection();
  }

  void _mockFaceDetection() {
    // Simulating delay for face detection
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isScanning = false;
          _detectedStudents = [
            {'img': 'https://via.placeholder.com/150', 'name': 'John Doe', 'id': 'CS-2023-045'},
            {'img': 'https://via.placeholder.com/150', 'name': 'Jane Smith', 'id': 'CS-2023-048'},
            {'img': 'https://via.placeholder.com/150', 'name': 'Mike Johnson', 'id': 'CS-2023-051'},
          ];
        });
      }
    });
  }

  void _saveAttendance() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Attendance saved to semester final list!'),
        backgroundColor: AppTheme.accentColor,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Camera backdrop
      appBar: AppBar(
        title: const Text('Live Attendance'),
        backgroundColor: Colors.black54,
        elevation: 0,
      ),
      body: Stack(
        children: [
          // Mock Camera Viewport
          Center(
            child: Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.primaryColor.withOpacity(0.5), width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  'https://images.unsplash.com/photo-1577896851231-70ef18881754?auto=format&fit=crop&q=80',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
          ),
          
          // Face detection overlay
          if (_isScanning)
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(color: AppTheme.primaryColor),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(20)),
                    child: const Text('Detecting Faces...', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            )
          else
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceColor.withOpacity(0.95),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.5), blurRadius: 10, offset: const Offset(0, -5))
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${_detectedStudents.length} Students Detected', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                        IconButton(
                          icon: const Icon(Icons.refresh, color: AppTheme.primaryColor),
                          onPressed: () {
                            setState(() {
                              _isScanning = true;
                              _detectedStudents = [];
                            });
                            _mockFaceDetection();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _detectedStudents.length,
                        itemBuilder: (context, index) {
                          final student = _detectedStudents[index];
                          return Container(
                            width: 100,
                            margin: const EdgeInsets.only(right: 12),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.backgroundColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage: NetworkImage(student['img']!),
                                ),
                                const SizedBox(height: 8),
                                Text(student['name']!, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white), overflow: TextOverflow.ellipsis),
                                Text(student['id']!, style: const TextStyle(fontSize: 10, color: Colors.white70)),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _saveAttendance,
                      icon: const Icon(Icons.check_circle),
                      label: const Text('Confirm & Save to Logs', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.accentColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
