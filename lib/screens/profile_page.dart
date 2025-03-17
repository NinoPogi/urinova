import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urinova/providers/user_provider.dart';
import 'package:urinova/screens/auth_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 246, 238),
      body: Padding(
        padding: const EdgeInsets.only(top: 100, left: 25, right: 25),
        child: Column(
          children: [
            if (userProvider.currentProfile != null)
              Text(
                'Current Profile: ${userProvider.currentProfile!['name']}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: userProvider.profiles.length,
                itemBuilder: (context, index) {
                  final profile = userProvider.profiles[index];
                  return Dismissible(
                    key: Key(profile['id']),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.only(right: 20),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                    confirmDismiss: (direction) async {
                      return await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Delete Profile?'),
                          content: Text(
                              'Are you sure you want to delete ${profile['name']}?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(false),
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(true),
                              child: Text('Delete',
                                  style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                    },
                    onDismissed: (direction) {
                      userProvider.deleteProfile(profile['id']);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('${profile['name']} deleted')),
                      );
                    },
                    child: ListTile(
                      title: Text(profile['name']),
                      trailing: Icon(Icons.arrow_forward),
                      onTap: () => userProvider.setCurrentProfile(profile),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () => _showAddProfileDialog(context),
              child: Text('Add Profile'),
            ),
            ElevatedButton(
              onPressed: () async {
                await userProvider.logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => AuthPage()),
                  (route) => false,
                );
              },
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}

void _showAddProfileDialog(BuildContext context) {
  final _nameController = TextEditingController();
  DateTime? _selectedSchedule;

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Add Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Profile Name'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                final time = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (time != null) {
                  final now = DateTime.now();
                  _selectedSchedule = DateTime(
                    now.year,
                    now.month,
                    now.day,
                    time.hour,
                    time.minute,
                  );
                }
              },
              child: Text(_selectedSchedule == null
                  ? 'Set Test Schedule'
                  : 'Scheduled at ${TimeOfDay.fromDateTime(_selectedSchedule!).format(context)}'),
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
              if (name.isNotEmpty) {
                final userProvider =
                    Provider.of<UserProvider>(context, listen: false);
                userProvider.addProfile(name, schedule: _selectedSchedule);
                Navigator.pop(context);
              }
            },
            child: Text('Add'),
          ),
        ],
      );
    },
  );
}
