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
                  return ListTile(
                    title: Text(profile['name']),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () => userProvider.setCurrentProfile(profile),
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

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Add Profile'),
        content: TextField(
          controller: _nameController,
          decoration: InputDecoration(labelText: 'Profile Name'),
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
                Provider.of<UserProvider>(context, listen: false)
                    .addProfile(name);
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
