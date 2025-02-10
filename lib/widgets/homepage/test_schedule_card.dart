import 'package:flutter/material.dart';

class TestScheduleCard extends StatefulWidget {
  const TestScheduleCard({super.key});

  @override
  State<TestScheduleCard> createState() => _TestScheduleCardState();
}

class _TestScheduleCardState extends State<TestScheduleCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      width: 180,
      height: 200,
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
      child: Stack(
        children: [
          Text(
            'Test Schedule',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Work Sans',
              letterSpacing: -1,
            ),
          ),
        ],
      ),
    );
  }
}
