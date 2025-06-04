import 'package:flutter/material.dart';
import 'package:urinova/widgets/profile/schedule_editor_dialog.dart';

class ProfileEditorDialog extends StatefulWidget {
  final Map<String, dynamic> profile;
  final Function(Map<String, dynamic>) onSave;

  const ProfileEditorDialog(
      {super.key, required this.profile, required this.onSave});

  @override
  _ProfileEditorDialogState createState() => _ProfileEditorDialogState();
}

class _ProfileEditorDialogState extends State<ProfileEditorDialog> {
  late TextEditingController _nameController;
  String? _selectedGender;
  Map<String, dynamic>? _testSchedule;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile['name']);
    _selectedGender = widget.profile['gender'];
    _testSchedule = widget.profile['testSchedule'];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Profile'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Profile Name'),
          ),
          DropdownButton<String>(
            value: _selectedGender,
            hint: const Text('Select Gender'),
            items: ['Male', 'Female']
                .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                .toList(),
            onChanged: (v) => setState(() => _selectedGender = v),
          ),
          ElevatedButton(
            onPressed: () async {
              final schedule = await showDialog(
                context: context,
                builder: (context) =>
                    ScheduleEditorDialog(initialSchedule: _testSchedule),
              );
              if (schedule != null) setState(() => _testSchedule = schedule);
            },
            child:
                Text(_testSchedule == null ? 'Set Schedule' : 'Edit Schedule'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final name = _nameController.text.trim();
            if (name.isEmpty || _selectedGender == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Please enter name and select gender')),
              );
              return;
            }
            widget.onSave({
              'name': name,
              'gender': _selectedGender,
              'testSchedule': _testSchedule,
            });
            Navigator.pop(context);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
