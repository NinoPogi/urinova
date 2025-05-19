import 'package:flutter/material.dart';

class ScheduleEditorDialog extends StatefulWidget {
  final Map<String, dynamic>? initialSchedule;
  final Function(Map<String, dynamic>)? onSave;

  const ScheduleEditorDialog({super.key, this.initialSchedule, this.onSave});

  @override
  _ScheduleEditorDialogState createState() => _ScheduleEditorDialogState();
}

class _ScheduleEditorDialogState extends State<ScheduleEditorDialog> {
  String _frequency = 'daily';
  List<String> _days = [];
  TimeOfDay _time = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    if (widget.initialSchedule != null) {
      _frequency = widget.initialSchedule!['frequency'] ?? 'daily';
      _days = List<String>.from(widget.initialSchedule!['days'] ?? []);
      final timeStr = widget.initialSchedule!['time'];
      if (timeStr != null) {
        final parts = timeStr.split(':');
        _time =
            TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Set Schedule'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButton<String>(
            value: _frequency,
            items: ['daily', 'weekly'].map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _frequency = value!;
                if (_frequency != 'weekly') {
                  _days = [];
                }
              });
            },
          ),
          if (_frequency == 'weekly')
            Wrap(
              children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                  .map((day) => FilterChip(
                        label: Text(day),
                        selected: _days.contains(day),
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              _days.add(day);
                            } else {
                              _days.remove(day);
                            }
                          });
                        },
                      ))
                  .toList(),
            ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () async {
              final time = await showTimePicker(
                context: context,
                initialTime: _time,
              );
              if (time != null) {
                setState(() {
                  _time = time;
                });
              }
            },
            child: Text('Set Time: ${_time.format(context)}'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            final schedule = {
              'frequency': _frequency,
              if (_frequency == 'weekly') 'days': _days,
              'hour': _time.hour, // Integer (0-23)
              'minute': _time.minute, // Integer (0-59)
            };
            widget.onSave?.call(schedule);
            Navigator.pop(context, schedule);
          },
          child: Text('Save'),
        ),
      ],
    );
  }
}
