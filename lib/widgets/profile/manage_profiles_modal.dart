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
  String? _selectedGender;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text('Manage Profiles', style: TextStyle(fontSize: 24)),
          Expanded(
            child: ListView.builder(
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
                        icon: Icon(Icons.edit),
                        onPressed: () => _editProfile(context, profile),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteProfile(context, profile),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () => _addProfile(context),
            child: Text('Add Profile'),
          ),
        ],
      ),
    );
  }

  String formatTime(int hour, int minute) {
    String period = hour >= 12 ? 'PM' : 'AM';
    int displayHour = hour % 12;
    if (displayHour == 0) displayHour = 12;
    String minuteStr = minute.toString().padLeft(2, '0');
    return '$displayHour:$minuteStr $period';
  }

// Updated schedule summary method
  String _getScheduleSummary(Map<String, dynamic>? schedule) {
    if (schedule == null) return 'No schedule';
    final frequency = schedule['frequency'];
    final hour = schedule['hour'] as int;
    final minute = schedule['minute'] as int; // Assuming minute is available
    final timeStr = formatTime(hour, minute);

    if (frequency == 'daily') {
      return 'Daily at $timeStr';
    } else if (frequency == 'weekly') {
      final days = (schedule['days'] as List<dynamic>).join(', ');
      return 'Weekly on $days at $timeStr';
    } else {
      return 'Custom schedule';
    }
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
          final index =
              userProvider.profiles.indexWhere((p) => p['id'] == profileId);
          if (index != -1) {
            userProvider.profiles[index] = {
              ...userProvider.profiles[index],
              ...updatedProfile,
            };
            if (userProvider.currentProfile?['id'] == profileId) {
              userProvider.setCurrentProfile(userProvider.profiles[index]);
            } else {
              userProvider.notifyListeners();
            }
          }
        },
      ),
    );
  }

  void _deleteProfile(BuildContext context, Map<String, dynamic> profile) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Profile?'),
        content: Text('Are you sure you want to delete ${profile['name']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<UserProvider>(context, listen: false)
                  .deleteProfile(profile['id']);
              Navigator.pop(context);
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _addProfile(BuildContext context) {
    final _nameController = TextEditingController();
    Map<String, dynamic>? _newSchedule;
    String? selectedGender;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Add Profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Profile Name'),
              ),
              DropdownButton<String>(
                value: selectedGender,
                hint: Text('Select Gender'),
                items: ['Male', 'Female']
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: (v) => setState(() => selectedGender = v),
              ),
              ElevatedButton(
                onPressed: () async {
                  final schedule = await showDialog(
                    context: context,
                    builder: (context) => ScheduleEditorDialog(),
                  );
                  if (schedule != null) {
                    setState(() {
                      _newSchedule = schedule;
                    });
                  }
                },
                child: Text(
                    _newSchedule == null ? 'Set Schedule' : 'Schedule Set'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final name = _nameController.text.trim();
                if (name.isEmpty || selectedGender == null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Please enter name and select gender')));
                  return;
                }
                Provider.of<UserProvider>(context, listen: false).addProfile(
                  name,
                  gender: selectedGender,
                  schedule: _newSchedule,
                );
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
