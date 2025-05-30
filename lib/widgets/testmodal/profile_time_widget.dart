import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urinova/providers/user_provider.dart';

Widget buildProfileAndTestTimeCard(BuildContext context) {
  final userProvider =
      Provider.of<UserProvider>(context); // Assuming UserProvider exists
  final currentProfile = userProvider.currentProfile;
  final now = DateTime.now();
  final formattedTime =
      "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} ${now.day}/${now.month}/${now.year}";

  return Container(
    padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
    decoration: BoxDecoration(
      color: Color.fromARGB(255, 255, 246, 238), //
      borderRadius: BorderRadius.circular(22),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Profile: ${currentProfile?['name'] ?? 'Unknown'}",
          style: TextStyle(
            fontSize: 22, // Larger text
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 8),
        Text(
          "Test Time: $formattedTime",
          style: TextStyle(
            fontSize: 22, // Larger text
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ),
  );
}

ElevatedButton exampleButton(BuildContext context) {
  return ElevatedButton(
    onPressed: () {
      // Button action here
    },
    style: ElevatedButton.styleFrom(
      backgroundColor:
          Theme.of(context).colorScheme.primary, // App's primary color
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
    ),
    child: Text(
      'Action',
      style: TextStyle(
        fontSize: 18,
        color: Colors.white,
      ),
    ),
  );
}
