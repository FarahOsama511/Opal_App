import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    // اختيار التاريخ
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initial ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return;

    // اختيار الوقت
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: initial != null
          ? TimeOfDay(hour: initial.hour, minute: initial.minute)
          : const TimeOfDay(hour: 9, minute: 0),
    );

    if (pickedTime == null) return;

    // دمج التاريخ والوقت
    final DateTime fullDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    onPicked(fullDateTime);
  }

  String formatTime(DateTime dateTime) {
    final hour = dateTime.hour == 0
        ? 12
        : dateTime.hour > 12
        ? dateTime.hour - 12
        : dateTime.hour;
    final period = dateTime.hour >= 12 ? 'مساءً' : 'صباحًا';
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return "$hour:$minute $period";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("تحديد وقت بداية ونهاية الحجز",
            style: TextStyles.black20Bold.copyWith(fontSize: 20.sp)),
        SizedBox(height: 20.h),

        // اختيار وقت البداية
        ListTile(
          leading: Icon(Icons.play_circle_fill, color: Colors.green, size: 28.sp),
          title: Text(
            startDate != null
                ? "بداية: ${startDate!.day}/${startDate!.month}/${startDate!.year} - ${formatTime(startDate!)}"
                : "اختر وقت البداية",
            style: TextStyles.black14Bold.copyWith(fontSize: 14.sp),
          ),
          trailing: Icon(Icons.calendar_today, size: 24.sp),
          onTap: () => _pickDateTime(context, startDate, onStartDateChanged),
        ),

        Divider(height: 1.h, thickness: 1.h),

        // اختيار وقت النهاية
        ListTile(
          leading: Icon(Icons.stop_circle, color: Colors.red, size: 28.sp),
          title: Text(
            endDate != null
                ? "نهاية: ${endDate!.day}/${endDate!.month}/${endDate!.year} - ${formatTime(endDate!)}"
                : "اختر وقت النهاية",
            style: TextStyles.black14Bold.copyWith(fontSize: 14.sp),
          ),
          trailing: Icon(Icons.calendar_today, size: 24.sp),
          onTap: () => _pickDateTime(context, endDate, onEndDateChanged),
        ),
      ],
    );
  }
}
