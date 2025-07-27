import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../widgets/time_line_step.dart';
import '../widgets/supervisor_step.dart';
import '../widgets/summary_step.dart';

class EditTripBox extends StatefulWidget {
  final VoidCallback onClose;
  const EditTripBox({super.key, required this.onClose});

  @override
  State<EditTripBox> createState() => _EditTripBoxState();
}

class _EditTripBoxState extends State<EditTripBox> {
  int currentStep = 0;
  DateTime? selectedDate;
  DateTime focusedDay = DateTime.now();
  int hour = 10;
  int minute = 0;
  String period = 'صباحًا';
  String? selectedSupervisor;
  String? selectedLine;

  @override
  Widget build(BuildContext context) {
    double boxWidth = MediaQuery.of(context).size.width * 0.85;
    double boxHeight = MediaQuery.of(context).size.height * 0.7;

    Widget stepContent;
    if (currentStep == 0) {
      stepContent = Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'تعديل ميعاد الرحلة',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: boxHeight * 0.65,
            child: Row(
              children: [
                Flexible(
                  flex: 7,
                  child: TableCalendar(
                    firstDay: DateTime(2020, 1, 1),
                    lastDay: DateTime(2030, 12, 31),
                    focusedDay: focusedDay,
                    selectedDayPredicate: (day) => isSameDay(selectedDate, day),
                    onDaySelected: (selectedDay, focusedDayNew) {
                      setState(() {
                        selectedDate = selectedDay;
                        focusedDay = focusedDayNew;
                      });
                    },
                    calendarFormat: CalendarFormat.month,
                    locale: 'ar',
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                    ),
                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: Colors.red.shade300,
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Flexible(
                  flex: 3,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Image.asset(
                      'assets/logo.png',
                      height: 150,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    } else if (currentStep == 1) {
      stepContent = TimeLineStep(
        hour: hour,
        minute: minute,
        period: period,
        selectedLine: selectedLine,
        onHourChanged: (newHour) => setState(() => hour = newHour),
        onMinuteChanged: (newMinute) => setState(() => minute = newMinute),
        onPeriodChanged: (newPeriod) => setState(() => period = newPeriod),
        onLineChanged: (newLine) => setState(() => selectedLine = newLine),
      );
    } else if (currentStep == 2) {
      stepContent = SupervisorStep(
        selectedSupervisor: selectedSupervisor,
        onSupervisorChanged: (value) =>
            setState(() => selectedSupervisor = value),
      );
    } else {
      stepContent = SummaryStep(
        selectedLine: selectedLine,
        hour: hour,
        minute: minute,
        period: period,
        selectedSupervisor: selectedSupervisor,
        selectedDate: selectedDate,
      );
    }
    return Center(
      child: SizedBox(
        width: boxWidth,
        height: boxHeight,
        child: Material(
          elevation: 8,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: widget.onClose,
                  ),
                ),
                Expanded(child: SingleChildScrollView(child: stepContent)),
                const SizedBox(height: 20),
                Row(
                  children: [
                    if (currentStep > 0)
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey,
                            minimumSize: const Size.fromHeight(50),
                          ),
                          onPressed: () => setState(() => currentStep--),
                          child: const FittedBox(child: Text('السابق')),
                        ),
                      ),
                    if (currentStep > 0) const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFE71A45),
                          minimumSize: const Size.fromHeight(50),
                        ),
                        onPressed: () {
                          if (currentStep < 3) {
                            setState(() => currentStep++);
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'تم التأكيد',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: 100,
                                    ),
                                    const SizedBox(height: 20),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        widget.onClose();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(
                                          0xFFE71A45,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            30,
                                          ),
                                        ),
                                        minimumSize: const Size.fromHeight(50),
                                      ),
                                      child: const Text('العودة الى الرئيسية'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                        child: FittedBox(
                          child: Text(currentStep < 3 ? 'التالي' : 'تأكيد'),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
