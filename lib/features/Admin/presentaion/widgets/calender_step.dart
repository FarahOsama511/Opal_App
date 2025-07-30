import 'package:flutter/material.dart';
import 'package:opal_app/core/resources/color_manager.dart';
import 'package:opal_app/core/resources/text_styles.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarStep extends StatelessWidget {
  final DateTime focusedDay;
  final DateTime? selectedDate;
  final void Function(DateTime selectedDay, DateTime focusedDay) onDaySelected;
  const CalendarStep({
    super.key,
    required this.focusedDay,
    required this.selectedDate,
    required this.onDaySelected,
  });
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('إضافة ميعاد جديد', style: TextStyles.black20Bold),
        // SizedBox(height: 2),
        SizedBox(
          height: screenHeight * 0.4,
          child: Row(
            children: [
              Expanded(
                flex: 4,
                child: SingleChildScrollView(
                  child: TableCalendar(
                    firstDay: DateTime(2020, 1, 1),
                    lastDay: DateTime(2030, 12, 31),
                    focusedDay: focusedDay,
                    selectedDayPredicate: (day) => isSameDay(selectedDate, day),
                    onDaySelected: onDaySelected,
                    calendarFormat: CalendarFormat.month,
                    locale: 'ar',
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle: TextStyle(fontSize: 16),
                    ),
                    daysOfWeekStyle: DaysOfWeekStyle(
                      weekendStyle: TextStyles.black10Bold,
                      weekdayStyle: TextStyles.black10Bold,
                    ),
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: ColorManager.greyColor,
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: const BoxDecoration(
                        color: ColorManager.primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
