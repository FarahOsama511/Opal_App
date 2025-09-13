import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/text_styles.dart';

class CalendarStep extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime? selectedDate;
  final String text;
  final void Function(DateTime selectedDay, DateTime focusedDay) onDaySelected;

  const CalendarStep({
    super.key,
    required this.text,
    required this.focusedDay,
    required this.selectedDate,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(text, style: TextStyles.black20Bold.copyWith(fontSize: 20.sp)),
        SizedBox(height: 10.h),
        SizedBox(
          height: 0.5.sh,
          child: TableCalendar(
            firstDay: DateTime(2020, 1, 1),
            lastDay: DateTime(2030, 12, 31),
            focusedDay: focusedDay,
            selectedDayPredicate: (day) => isSameDay(selectedDate, day),
            onDaySelected: onDaySelected,
            calendarFormat: CalendarFormat.month,
            locale: 'ar',
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekendStyle: TextStyles.black10Bold.copyWith(fontSize: 12.sp),
              weekdayStyle: TextStyles.black10Bold.copyWith(fontSize: 12.sp),
            ),
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: ColorManager.greyColor,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: ColorManager.primaryColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
