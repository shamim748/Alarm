import 'package:alarm_app/constants/color.dart';
import 'package:flutter/material.dart';

class CustomAlarmBox extends StatelessWidget {
  final DateTime dateTime;
  final bool isEnabled;
  final ValueChanged<bool> onToggle;

  const CustomAlarmBox({
    super.key,
    required this.dateTime,
    required this.isEnabled,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final timeText = TimeOfDay.fromDateTime(dateTime).format(context);
    final dateText =
        "${_getWeekday(dateTime.weekday)} ${dateTime.day.toString().padLeft(2, '0')} ${_getMonth(dateTime.month)} ${dateTime.year}";

    return Container(
      height: 84,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF3A3A3A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            timeText,
            style: const TextStyle(
              fontSize: 24,
              color: Colors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
          Row(
            children: [
              Text(
                dateText,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 10),
              Switch(
                value: isEnabled,
                onChanged: onToggle,
                activeColor: Colors.white,
                activeTrackColor: AppColor.purpleDark10,
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getWeekday(int weekday) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[weekday - 1];
  }

  String _getMonth(int month) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }
}
