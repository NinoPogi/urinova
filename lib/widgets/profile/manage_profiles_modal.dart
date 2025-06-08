import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urinova/providers/user_provider.dart';
import 'package:urinova/widgets/profile/schedule_editor_dialog.dart';
import 'profile_editor_dialog.dart';

class ManageProfilesModal extends StatefulWidget {
  @override
  _ManageProfilesModalState createState() => _ManageProfilesModalState();
}

class _ManageProfilesModalState extends State<ManageProfilesModal> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Manage Profiles', style: TextStyle(fontSize: 24)),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: userProvider.profiles.length,
            itemBuilder: (context, index) {
              final profile = userProvider.profiles[index];
              return ListTile(
                title: Text(profile['name']),
                subtitle: Text(_getScheduleSummary(profile['testSchedule'])),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _editProfile(context, profile),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteProfile(context, profile),
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _addProfile(context),
              child: const Text('Add Profile'),
            ),
          ),
        ],
      ),
    );
  }

  String _getScheduleSummary(Map<String, dynamic>? schedule) {
    if (schedule == null) return 'No schedule';
    final frequency = schedule['frequency'];
    final hour = schedule['hour'];
    final minute = schedule['minute'];
    final time = TimeOfDay(hour: hour, minute: minute).format(context);
    if (frequency == 'daily') return 'Daily at $time';
    if (frequency == 'weekly')
      return 'Weekly on ${(schedule['days'] as List).join(', ')} at $time';
    return 'Custom schedule';
  }

  void _editProfile(BuildContext context, Map<String, dynamic> profile) {
    showDialog(
      context: context,
      builder: (context) => ProfileEditorDialog(
        profile: profile,
        onSave: (updatedProfile) async {
          final userProvider =
              Provider.of<UserProvider>(context, listen: false);
          final userId = userProvider.user!.uid;
          final profileId = profile['id'];
          await FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .collection('profiles')
              .doc(profileId)
              .update(updatedProfile);
          userProvider.profiles[
              userProvider.profiles.indexWhere((p) => p['id'] == profileId)] = {
            ...profile,
            ...updatedProfile,
          };
          userProvider.notifyListeners();
        },
      ),
    );
  }

  void _deleteProfile(BuildContext context, Map<String, dynamic> profile) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Profile?'),
        content: Text('Are you sure you want to delete ${profile['name']}?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Provider.of<UserProvider>(context, listen: false)
                  .deleteProfile(profile['id']);
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _addProfile(BuildContext context) {
    final _nameController = TextEditingController();
    String? _selectedGender;
    Map<String, dynamic>? _newSchedule;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              DropdownButton<String>(
                value: _selectedGender,
                hint: const Text('Gender'),
                items: ['Male', 'Female'].map((String value) {
                  return DropdownMenuItem<String>(
                      value: value, child: Text(value));
                }).toList(),
                onChanged: (value) => setState(() => _selectedGender = value),
              ),
              ElevatedButton(
                onPressed: () async {
                  final schedule = await showDialog(
                    context: context,
                    builder: (context) => const ScheduleEditorDialog(),
                  );
                  if (schedule != null) setState(() => _newSchedule = schedule);
                },
                child: Text(
                    _newSchedule == null ? 'Set Schedule' : 'Edit Schedule'),
              ),
            ],
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel')),
            TextButton(
              onPressed: () {
                if (_nameController.text.isEmpty || _selectedGender == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Name and gender are required')),
                  );
                  return;
                }
                Provider.of<UserProvider>(context, listen: false).addProfile(
                  _nameController.text,
                  gender: _selectedGender,
                  schedule: _newSchedule,
                );
                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
