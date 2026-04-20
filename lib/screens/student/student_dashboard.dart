import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import '../common/camera_capture_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../theme/app_theme.dart';

class StudentDashboard extends StatefulWidget {
  const StudentDashboard({super.key});

  @override
  State<StudentDashboard> createState() => _StudentDashboardState();
}

class _StudentDashboardState extends State<StudentDashboard> {
  String _name = 'Loading...';
  String _id = 'Loading...';
  String? _profileImageUrl;
  bool _isLoading = true;
  bool _isUploadingImage = false;


  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        DocumentSnapshot doc = await FirebaseFirestore.instance.collection('students').doc(currentUser.uid).get();
        if (doc.exists) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          setState(() {
            _name = data['name'] ?? 'Unknown Student';
            _id = data['id'] ?? 'No Reg No';
            _profileImageUrl = data['face_data'];
            _isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          _name = 'Error Loading';
          _id = '';
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleLogout() async {
    await FirebaseAuth.instance.signOut();
  }

  Future<void> _pickAndPreviewImage() async {
    final XFile? image = await Navigator.push<XFile>(
      context,
      MaterialPageRoute(builder: (context) => const CameraCaptureScreen()),
    );

    if (image == null) return;
    if (!mounted) return;

    await _uploadImageToStorage(image);
  }

  Future<void> _uploadImageToStorage(XFile file) async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    setState(() {
      _isUploadingImage = true;
    });

    try {
      final storageRef = FirebaseStorage.instance.ref().child('profile_images/${currentUser.uid}.jpg');
      
      // Upload task
      final bytes = await file.readAsBytes();
      final uploadTask = storageRef.putData(bytes, SettableMetadata(contentType: 'image/jpeg'));
      
      final snapshot = await uploadTask.whenComplete(() => null);
      final downloadUrl = await snapshot.ref.getDownloadURL();

      // Update Firestore
      await FirebaseFirestore.instance.collection('students').doc(currentUser.uid).update({
        'face_data': downloadUrl,
      });

      setState(() {
        _profileImageUrl = downloadUrl;
        _isUploadingImage = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile image updated successfully!'), backgroundColor: AppTheme.accentColor));
      }
    } catch (e) {
      setState(() {
        _isUploadingImage = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to upload image: $e'), backgroundColor: Colors.redAccent));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
          )
        ],
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator()) 
          : SingleChildScrollView(
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
                          GestureDetector(
                            onTap: _isUploadingImage ? null : _pickAndPreviewImage,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 40,
                                  backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
                                  backgroundImage: _profileImageUrl != null ? NetworkImage(_profileImageUrl!) : null,
                                  child: _profileImageUrl == null
                                      ? const Icon(Icons.person, size: 40, color: AppTheme.primaryColor)
                                      : null,
                                ),
                                if (_isUploadingImage)
                                  Container(
                                    decoration: const BoxDecoration(color: Colors.black54, shape: BoxShape.circle),
                                    width: 80,
                                    height: 80,
                                    child: const Center(
                                      child: SizedBox(width: 30, height: 30, child: CircularProgressIndicator(strokeWidth: 3, color: AppTheme.accentColor)),
                                    ),
                                  ),
                                if (!_isUploadingImage && _profileImageUrl != null)
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(color: AppTheme.accentColor, shape: BoxShape.circle),
                                      child: const Icon(Icons.camera_alt, size: 14, color: Colors.white),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_name, style: Theme.of(context).textTheme.displayMedium?.copyWith(fontSize: 24)),
                                const SizedBox(height: 4),
                                Text('ID: $_id', style: const TextStyle(color: Colors.white70)),
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
                    icon: Icons.camera_alt_outlined,
                    title: 'Update Profile Picture',
                    subtitle: 'Capture and update your face data',
                    onTap: _pickAndPreviewImage,
                  ),
                  const SizedBox(height: 12),
                  _buildActionTile(
                    context,
                    icon: Icons.edit_document,
                    title: 'Update Information',
                    subtitle: 'Request to change profile data',
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
