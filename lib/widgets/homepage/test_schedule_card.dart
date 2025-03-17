import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urinova/providers/user_provider.dart';

class TestScheduleCard extends StatefulWidget {
  const TestScheduleCard({super.key});

  @override
  State<TestScheduleCard> createState() => _TestScheduleCardState();
}

class _TestScheduleCardState extends State<TestScheduleCard> {
  Future<void> _selectTime(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentProfile = userProvider.currentProfile;
    if (currentProfile == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      final now = DateTime.now();
      final schedule = DateTime(
        now.year,
        now.month,
        now.day,
        time.hour,
        time.minute,
      );
      await userProvider.setTestSchedule(currentProfile['id'], schedule);
    }
  }

  String _getTimeRemaining(DateTime schedule) {
    final now = DateTime.now();
    final difference = schedule.difference(now);
    if (difference.isNegative) {
      return 'Time passed';
    }
    return ' ETA: ${difference.inHours}h ${difference.inMinutes.remainder(60)}m';
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final currentProfile = userProvider.currentProfile;
    final schedule = currentProfile?['testSchedule'];

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          Spacer(),
          if (schedule != null) ...[
            // Text(
            //   'Next test at ${TimeOfDay.fromDateTime(schedule).format(context)}',
            //   style: TextStyle(fontSize: 16),
            // ),
            // SizedBox(height: 8),
            Text(
              _getTimeRemaining(schedule),
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ] else
            ElevatedButton(
              onPressed: () => _selectTime(context),
              child:
                  Text(schedule == null ? 'Set Schedule' : 'Change Schedule'),
            ),
        ],
      ),
    );
  }
}
