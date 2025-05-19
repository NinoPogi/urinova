import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urinova/providers/user_provider.dart';
import 'package:urinova/widgets/profile/schedule_editor_dialog.dart';

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
                  subtitle: Text(_getScheduleSummary(profile['schedule'])),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => _editSchedule(context, profile),
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

  String _getScheduleSummary(Map<String, dynamic>? schedule) {
    if (schedule == null) return 'No schedule';
    final frequency = schedule['frequency'];
    final time = schedule['time'];
    if (frequency == 'daily') {
      return 'Daily at $time';
    } else if (frequency == 'weekly') {
      final days = (schedule['days'] as List<dynamic>).join(', ');
      return 'Weekly on $days at $time';
    } else {
      return 'Custom schedule';
    }
  }

  void _editSchedule(BuildContext context, Map<String, dynamic> profile) {
    showDialog(
      context: context,
      builder: (context) => ScheduleEditorDialog(
        initialSchedule: profile['schedule'],
        onSave: (newSchedule) {
          Provider.of<UserProvider>(context, listen: false)
              .setTestSchedule(profile['id'], newSchedule);
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
    String? _selectedGender;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Profile Name'),
            ),
            SizedBox(height: 16),
            DropdownButton<String>(
              value: _selectedGender,
              hint: Text('Select Gender'),
              items: ['Male', 'Female'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedGender = value;
                });
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final schedule = await showDialog(
                  context: context,
                  builder: (context) => ScheduleEditorDialog(),
                );
                if (schedule != null) {
                  _newSchedule = schedule;
                }
              },
              child:
                  Text(_newSchedule == null ? 'Set Schedule' : 'Schedule Set'),
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
              final name = _nameController.text;
              if (name.isNotEmpty && _selectedGender != null) {
                Provider.of<UserProvider>(context, listen: false).addProfile(
                    name,
                    gender: _selectedGender,
                    schedule: _newSchedule);
                Navigator.pop(context);
              }
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }
}
