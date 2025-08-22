import 'package:flutter/material.dart';

import '../../../../core/resources/text_styles.dart';

class StartEndTimeStep extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;

  final void Function(DateTime) onStartDateChanged;
  final void Function(DateTime) onEndDateChanged;

  const StartEndTimeStep({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
  });

  Future<void> _pickDateTime(
    BuildContext context,
    DateTime? initial,
    void Function(DateTime) onPicked,
  ) async {
    // اختار التاريخ
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initial ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return;

    // اختار الوقت
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initial != null
          ? TimeOfDay(hour: initial.hour, minute: initial.minute)
          : const TimeOfDay(hour: 9, minute: 0),
    );

    if (pickedTime == null) return;

    // اجمع التاريخ والوقت
    final DateTime fullDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    onPicked(fullDateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("تحديد وقت بداية ونهاية الحجز", style: TextStyles.black20Bold),
        const SizedBox(height: 20),

        // اختيار وقت البداية
        ListTile(
          leading: const Icon(Icons.play_circle_fill, color: Colors.green),
          title: Text(
            startDate != null
                ? "بداية: ${startDate!.day}/${startDate!.month}/${startDate!.year} - ${startDate!.hour}:${startDate!.minute.toString().padLeft(2, '0')}"
                : "اختر وقت البداية",
          ),
          trailing: const Icon(Icons.calendar_today),
          onTap: () => _pickDateTime(context, startDate, onStartDateChanged),
        ),

        const Divider(),

        // اختيار وقت النهاية
        ListTile(
          leading: const Icon(Icons.stop_circle, color: Colors.red),
          title: Text(
            endDate != null
                ? "نهاية: ${endDate!.day}/${endDate!.month}/${endDate!.year} - ${endDate!.hour}:${endDate!.minute.toString().padLeft(2, '0')}"
                : "اختر وقت النهاية",
          ),
          trailing: const Icon(Icons.calendar_today),
          onTap: () => _pickDateTime(context, endDate, onEndDateChanged),
        ),
      ],
    );
  }
}
