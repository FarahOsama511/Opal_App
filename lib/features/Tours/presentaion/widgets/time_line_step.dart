import 'package:flutter/material.dart';

class TimeLineStep extends StatelessWidget {
  final int hour;
  final int minute;
  final String period;
  final String? selectedLine;

  final ValueChanged<int> onHourChanged;
  final ValueChanged<int> onMinuteChanged;
  final ValueChanged<String> onPeriodChanged;
  final ValueChanged<String?> onLineChanged;

  const TimeLineStep({
    super.key,
    required this.hour,
    required this.minute,
    required this.period,
    required this.selectedLine,
    required this.onHourChanged,
    required this.onMinuteChanged,
    required this.onPeriodChanged,
    required this.onLineChanged,
  });

  Widget timeSelector(String label, int value, VoidCallback onIncrement, VoidCallback onDecrement) {
    return Column(
      children: [
        IconButton(icon: const Icon(Icons.keyboard_arrow_up), onPressed: onIncrement),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(value.toString().padLeft(2, '0'), style: const TextStyle(fontSize: 16)),
        ),
        IconButton(icon: const Icon(Icons.keyboard_arrow_down), onPressed: onDecrement),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('ميعاد الذهاب', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            timeSelector('الساعة', hour,
                    () => onHourChanged(hour == 12 ? 1 : hour + 1),
                    () => onHourChanged(hour == 1 ? 12 : hour - 1)),
            timeSelector('الدقيقة', minute,
                    () => onMinuteChanged((minute + 1) % 60),
                    () => onMinuteChanged(minute == 0 ? 59 : minute - 1)),
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.keyboard_arrow_up),
                  onPressed: () => onPeriodChanged(period == 'صباحًا' ? 'مساءً' : 'صباحًا'),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(period, style: const TextStyle(fontSize: 16)),
                ),
                IconButton(
                  icon: const Icon(Icons.keyboard_arrow_down),
                  onPressed: () => onPeriodChanged(period == 'صباحًا' ? 'مساءً' : 'صباحًا'),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade200,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          hint: const Text('اختر الخط'),
          value: selectedLine,
          onChanged: onLineChanged,
          items: const [
            DropdownMenuItem(value: '1', child: Text('خط رقم 1')),
            DropdownMenuItem(value: '2', child: Text('خط رقم 2')),
            DropdownMenuItem(value: '3', child: Text('خط رقم 3')),
          ],
        ),
      ],
    );
  }
}
