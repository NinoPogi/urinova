import 'package:flutter/material.dart';

class HeaderPart extends StatefulWidget {
  final String name;
  final double fontSize;

  const HeaderPart({super.key, required this.name, this.fontSize = 24});

  @override
  State<HeaderPart> createState() => _HeaderPartState();
}

class _HeaderPartState extends State<HeaderPart> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        children: [
          Text(
            widget.name,
            style: TextStyle(
              fontSize: widget.fontSize,
              fontWeight: FontWeight.bold,
              fontFamily: 'Work Sans',
              letterSpacing: -1,
            ),
          ),
          Spacer(),
          CircleAvatar(
            radius: 28,
            backgroundImage: AssetImage("assets/images/profile.png"),
          )
        ],
      ),
    );
  }
}
