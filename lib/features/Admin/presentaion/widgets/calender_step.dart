import 'package:flutter/material.dart';
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
    double boxHeight = MediaQuery.of(context).size.height * 0.7;
    double boxWidth = MediaQuery.of(context).size.width * 0.85;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('إضافة ميعاد جديد', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
        const SizedBox(height: 10),
        SizedBox(
          height: boxHeight * 0.65,
          child: Row(
            children: [
              SizedBox(
                width: boxWidth * 0.65,
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
                  ),
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(color: Colors.red.shade300, shape: BoxShape.circle),
                    selectedDecoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              SizedBox(
                width: boxWidth * 0.20,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Image.asset('assets/logo.png', height: 150, fit: BoxFit.contain),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
