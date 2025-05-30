import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../providers/user_provider.dart';
import 'schedule_editor_dialog.dart';

class ProfileEditorDialog extends StatefulWidget {
  final Map<String, dynamic> profile;
  final Function(Map<String, dynamic>) onSave;
  const ProfileEditorDialog({required this.profile, required this.onSave});
  @override
  _ProfileEditorDialogState createState() => _ProfileEditorDialogState();
}

class _ProfileEditorDialogState extends State<ProfileEditorDialog> {
  late TextEditingController _nameController;
  String? _selectedGender;
  Map<String, dynamic>? _schedule;
  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile['name']);
    _selectedGender = widget.profile['gender'];
    _schedule = widget.profile['testSchedule'];
  }

  Future<void> _clearTests() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear Tests?'),
        content:
            Text('Are you sure you want to clear all tests for this profile?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final userId = userProvider.user!.uid;
      final profileId = widget.profile['id'];
      final testsRef = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('profiles')
          .doc(profileId)
          .collection('tests');
      final snapshot = await testsRef.get();
      for (var doc in snapshot.docs) {
        await doc.reference.delete();
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Tests cleared')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Profile'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            DropdownButton<String>(
              value: _selectedGender,
              hint: Text('Select Gender'),
              items: ['Male', 'Female']
                  .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                  .toList(),
              onChanged: (v) => setState(() => _selectedGender = v),
            ),
            ElevatedButton(
              onPressed: () async {
                final newSchedule = await showDialog(
                  context: context,
                  builder: (context) =>
                      ScheduleEditorDialog(initialSchedule: _schedule),
                );
                if (newSchedule != null) {
                  setState(() {
                    _schedule = newSchedule;
                  });
                }
              },
              child: Text(_schedule == null ? 'Set Schedule' : 'Edit Schedule'),
            ),
            ElevatedButton(
              onPressed: _clearTests,
              child: Text('Clear Tests'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final name = _nameController.text.trim();
            if (name.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Name cannot be empty')));
              return;
            }
            final updatedProfile = {
              'name': name,
              'gender': _selectedGender,
              'testSchedule': _schedule,
            };
            widget.onSave(updatedProfile);
            Navigator.pop(context);
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
