import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../urinova.dart';
import '../providers/profile_provider.dart';

class FirstTimeSetupPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('First Time Setup'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to Urinova!'),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Enter your name',
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isFirstTime', false);
                Provider.of<ProfileProvider>(context, listen: false)
                    .setName(_nameController.text);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const Main()),
                );
              },
              child: const Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }
}
