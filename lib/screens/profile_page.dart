import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urinova/providers/biomarker_provider.dart';
import 'package:urinova/providers/user_provider.dart';
import 'package:urinova/screens/auth_page.dart';
import 'package:urinova/widgets/profile/manage_profiles_modal.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _showManageProfilesModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => ManageProfilesModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final biomarkerProvider = Provider.of<BiomarkerProvider>(context);
    final currentProfile = userProvider.currentProfile;
    final profiles = userProvider.profiles;

    if (currentProfile == null) {
      return const SizedBox.shrink();
    }

    Widget avatarWidget = profiles.length == 1
        ? _buildSingleProfileAvatar(currentProfile)
        : _buildStackedAvatars(profiles, currentProfile);

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 161, 210, 206),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(25, 32, 25, 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(child: avatarWidget),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: profiles.length,
                  itemBuilder: (context, index) {
                    final profile = profiles[index];
                    final isSelected = profile == currentProfile;
                    return Container(
                      color: isSelected ? Colors.blue.withOpacity(0.1) : null,
                      child: ListTile(
                        leading: isSelected
                            ? Icon(Icons.check, color: Colors.blue)
                            : null,
                        title: Text(profile['name']),
                        trailing:
                            biomarkerProvider.loadingProfileId == profile['id']
                                ? CircularProgressIndicator()
                                : Icon(Icons.arrow_forward),
                        onTap: () {
                          userProvider.setCurrentProfile(profile);
                          biomarkerProvider.loadHistoryForProfile(
                              userProvider.user!.uid, profile['id']);
                        },
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () => _showManageProfilesModal(context),
                child: const Text('Manage Profiles'),
              ),
              const SizedBox(height: 10),
              // ElevatedButton(
              //   onPressed: _exportData,
              //   child: const Text('Export Data'),
              // ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  await userProvider.logout();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => AuthPage()),
                    (route) => false,
                  );
                },
                child: const Text('Logout'),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSingleProfileAvatar(Map<String, dynamic> profile) {
    return GestureDetector(
      child: Container(
        width: 56,
        height: 56,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.blue,
        ),
        child: Center(
          child: Text(
            profile['name'][0].toUpperCase(),
            style: const TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
      ),
    );
  }

  Widget _buildStackedAvatars(List<Map<String, dynamic>> profiles,
      Map<String, dynamic> currentProfile) {
    final otherProfiles = profiles.where((p) => p != currentProfile).toList();
    return GestureDetector(
      child: SizedBox(
        width: 40.0 + otherProfiles.length * 15.0,
        height: 70,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            for (int i = 0; i < otherProfiles.length; i++)
              Positioned(
                left: i * 15.0,
                child: _buildProfileAvatar(
                    otherProfiles[i]['name'], otherProfiles[i]['gender'], false,
                    size: 60),
              ),
            Positioned(
              right: 0,
              child: _buildProfileAvatar(
                  currentProfile['name'], currentProfile['gender'], true,
                  size: 70),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileAvatar(String? name, String? gender, bool isActive,
      {required double size}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? _getAvatarColor(gender) : Colors.grey,
        border: isActive ? Border.all(color: Colors.white, width: 2) : null,
      ),
      child: Center(
        child: Text(
          name?[0].toUpperCase() ?? "Profile",
          style: TextStyle(color: Colors.white, fontSize: size / 2),
        ),
      ),
    );
  }

  Color _getAvatarColor(String? gender) {
    if (gender == 'Male') return Colors.blue;
    if (gender == 'Female') return Colors.pink;
    return Colors.grey;
  }
}
