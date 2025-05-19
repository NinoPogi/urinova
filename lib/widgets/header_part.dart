import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urinova/providers/user_provider.dart';

class HeaderPart extends StatefulWidget {
  final String name;
  final double fontSize;
  final VoidCallback onNavigateToProfile;

  const HeaderPart({
    super.key,
    required this.name,
    this.fontSize = 24,
    required this.onNavigateToProfile,
  });

  @override
  State<HeaderPart> createState() => _HeaderPartState();
}

class _HeaderPartState extends State<HeaderPart> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final profiles = userProvider.profiles;
    final currentProfile = userProvider.currentProfile;

    // Fallback in case no current profile is set (unlikely due to app logic)
    if (currentProfile == null) {
      return const SizedBox.shrink();
    }

    Widget avatarWidget;
    if (profiles.length == 1) {
      avatarWidget = _buildSingleProfileAvatar(currentProfile);
    } else {
      avatarWidget = _buildStackedAvatars(profiles, currentProfile);
    }

    return SizedBox(
      height: 60,
      child: Row(
        children: [
          Text(
            widget.name
                .replaceFirst('Hello,', 'Hello, ${currentProfile['name']}'),
            style: TextStyle(
              fontSize: widget.fontSize,
              fontWeight: FontWeight.bold,
              fontFamily: 'Work Sans',
              letterSpacing: -1,
            ),
          ),
          const Spacer(),
          avatarWidget,
        ],
      ),
    );
  }

  Widget _buildSingleProfileAvatar(Map<String, dynamic> profile) {
    return GestureDetector(
      onTap: widget.onNavigateToProfile,
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
      onTap: widget.onNavigateToProfile,
      child: SizedBox(
        width: 40.0 + otherProfiles.length * 15.0,
        height: 40,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            for (int i = 0; i < otherProfiles.length; i++)
              Positioned(
                left: i * 15.0,
                child: _buildProfileAvatar(
                    otherProfiles[i]['name'], otherProfiles[i]['gender'], false,
                    size: 30),
              ),
            Positioned(
              right: 0,
              child: _buildProfileAvatar(
                  currentProfile['name'], currentProfile['gender'], true,
                  size: 40),
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
    if (gender == 'Male') {
      return Colors.blue;
    } else if (gender == 'Female') {
      return Colors.pink;
    } else {
      return Colors.grey; // Fallback color if gender is unspecified
    }
  }
}
