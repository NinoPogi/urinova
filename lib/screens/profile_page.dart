import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urinova/providers/profile_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 246, 238),
      body: Padding(
        padding: const EdgeInsets.only(top: 200, left: 25, right: 25),
        child: Center(
          child: Column(
            children: [
              const CircleAvatar(
                radius: 69,
                backgroundImage: AssetImage("assets/images/profile.png"),
              ),
              SizedBox(
                height: 60,
              ),
              Text(
                profileProvider.name,
                style: const TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Work Sans',
                  letterSpacing: -1,
                ),
              ),
              SizedBox(
                height: 60,
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 6),
                      spreadRadius: -7,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ProfileOption(
                        name: "User Info", onTap: () => print("User Info")),
                    Container(
                      width: 200,
                      height: 2,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                    ProfileOption(
                        name: "Settings", onTap: () => print("Settings")),
                    Container(
                      width: 200,
                      height: 2,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                    ProfileOption(
                        name: "Manage Profiles",
                        onTap: () => print("Manage Profiles")),
                    Container(
                      width: 200,
                      height: 2,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                    ProfileOption(
                        name: "Export Data", onTap: () => print("Export Data")),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileOption extends StatelessWidget {
  final String name;
  final VoidCallback onTap;

  const ProfileOption({super.key, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      child: GestureDetector(
        onTap: onTap,
        child: Text(
          name,
          style: const TextStyle(
              fontSize: 22,
              fontFamily: 'Work Sans',
              letterSpacing: -1,
              decoration: TextDecoration.lineThrough),
        ),
      ),
    );
  }
}
