import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:urinova/providers/user_provider.dart';

class TestScheduleCard extends StatefulWidget {
  const TestScheduleCard({super.key});

  @override
  State<TestScheduleCard> createState() => _TestScheduleCardState();
}

class _TestScheduleCardState extends State<TestScheduleCard> {
  DateTime? getNextScheduleTime(Map<String, dynamic>? schedule) {
    if (schedule == null) return null;

    final frequency = schedule['frequency'];
    final hour = schedule['hour'] as int;
    final minute = schedule['minute'] as int;

    final now = DateTime.now();
    DateTime nextTime = DateTime(now.year, now.month, now.day, hour, minute);

    // For daily schedules: if time has passed today, move to tomorrow
    if (frequency == 'daily') {
      if (nextTime.isBefore(now)) {
        nextTime = nextTime.add(const Duration(days: 1));
      }
      return nextTime;
    } else if (frequency == 'weekly') {
      final days = schedule['days'] as List<dynamic>;
      if (days.isEmpty) return null;
      final dayMap = {
        'Mon': 1,
        'Tue': 2,
        'Wed': 3,
        'Thu': 4,
        'Fri': 5,
        'Sat': 6,
        'Sun': 7,
      };
      final targetWeekdays = days.map((d) => dayMap[d]!).toList();
      int daysToAdd = 0;
      for (int i = 0; i < 7; i++) {
        final candidate = now.add(Duration(days: i));
        if (targetWeekdays.contains(candidate.weekday)) {
          daysToAdd = i;
          break;
        }
      }
      nextTime = DateTime(
        now.year,
        now.month,
        now.day + daysToAdd,
        hour,
        minute,
      );
      if (nextTime.isBefore(now)) {
        nextTime = nextTime.add(Duration(days: 7));
      }
    } else {
      return null;
    }
    return nextTime;
  }

  String _getTimeRemaining(DateTime? nextTime) {
    if (nextTime == null) return 'No schedule set';
    final now = DateTime.now();
    final difference = nextTime.difference(now);
    if (difference.isNegative) {
      return 'Scheduled time passed';
    }
    final hours = difference.inHours;
    final minutes = difference.inMinutes.remainder(60);
    return 'Next test in $hours h $minutes m';
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final currentProfile = userProvider.currentProfile;
    final schedule = currentProfile?['testSchedule'];
    final nextTime = getNextScheduleTime(schedule);

    return Container(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
      width: MediaQuery.of(context).size.width * 0.4,
      height: MediaQuery.of(context).size.height * 0.20,
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
          Text(
            _getTimeRemaining(nextTime),
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
