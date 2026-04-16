import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class VerifyUpdatesScreen extends StatefulWidget {
  const VerifyUpdatesScreen({super.key});

  @override
  State<VerifyUpdatesScreen> createState() => _VerifyUpdatesScreenState();
}

class _VerifyUpdatesScreenState extends State<VerifyUpdatesScreen> {
  // Mock data representing pending update requests
  final List<Map<String, dynamic>> _pendingRequests = [
    {
      'id': 'REQ001',
      'studentName': 'Alice Brown',
      'rollNo': 'CS-2023-012',
      'type': 'Face Data Update',
      'timestamp': '2 hours ago',
    },
    {
      'id': 'REQ002',
      'studentName': 'Bob Smith',
      'rollNo': 'CS-2023-015',
      'type': 'Contact Info Update',
      'timestamp': '5 hours ago',
    },
    {
      'id': 'REQ003',
      'studentName': 'Charlie Davis',
      'rollNo': 'CS-2023-022',
      'type': 'Initial Registration',
      'timestamp': '1 day ago',
    },
  ];

  void _handleAction(int index, bool approved) {
    String actionStr = approved ? 'approved' : 'rejected';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Request $actionStr successfully.'),
        backgroundColor: approved ? AppTheme.accentColor : Colors.redAccent,
      ),
    );

    setState(() {
      _pendingRequests.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Updates'),
      ),
      body: _pendingRequests.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline, size: 80, color: Colors.white24),
                  SizedBox(height: 16),
                  Text('All caught up!', style: TextStyle(fontSize: 20, color: Colors.white70)),
                  SizedBox(height: 8),
                  Text('There are no pending update requests.', style: TextStyle(color: Colors.white54)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _pendingRequests.length,
              itemBuilder: (context, index) {
                final req = _pendingRequests[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(req['type'], style: const TextStyle(color: AppTheme.primaryColor, fontSize: 12, fontWeight: FontWeight.bold)),
                            ),
                            Text(req['timestamp'], style: const TextStyle(color: Colors.white54, fontSize: 12)),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white12,
                              child: Text(req['studentName'][0]),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(req['studentName'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                                  Text('Roll No: ${req['rollNo']}', style: const TextStyle(color: Colors.white70)),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const Divider(color: Colors.white12),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => _handleAction(index, false),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.redAccent,
                                  side: const BorderSide(color: Colors.redAccent),
                                ),
                                child: const Text('Reject'),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => _handleAction(index, true),
                                style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accentColor),
                                child: const Text('Approve'),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
