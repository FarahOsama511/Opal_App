import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class EditTripBox extends StatefulWidget {
  final VoidCallback onClose;

  const EditTripBox({super.key, required this.onClose});

  @override
  State<EditTripBox> createState() => _EditTripBoxState();
}

class _EditTripBoxState extends State<EditTripBox> {
  int currentStep = 0;
  DateTime? selectedDate;
  int hour = 10;
  int minute = 0;
  String period = 'صباحًا';
  String? selectedSupervisor;
  String? selectedLine;

  DateTime focusedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    double boxWidth = MediaQuery.of(context).size.width * 0.85;
    double boxHeight = MediaQuery.of(context).size.height * 0.7;

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

    Widget stepContent;

    if (currentStep == 0) {
      stepContent = Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('تعديل ميعاد الرحلة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
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
    } else if (currentStep == 1) {
      stepContent = Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('تعديل وقت الذهاب', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              timeSelector('الساعة', hour, () => setState(() => hour = (hour + 1) % 13 == 0 ? 1 : (hour + 1) % 13), () => setState(() => hour = (hour - 1) <= 0 ? 12 : hour - 1)),
              timeSelector('الدقيقة', minute, () => setState(() => minute = (minute + 1) % 60), () => setState(() => minute = (minute - 1) < 0 ? 59 : minute - 1)),
              Column(
                children: [
                  IconButton(icon: const Icon(Icons.keyboard_arrow_up), onPressed: () => setState(() => period = period == 'صباحًا' ? 'مساءً' : 'صباحًا')),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(period, style: const TextStyle(fontSize: 16)),
                  ),
                  IconButton(icon: const Icon(Icons.keyboard_arrow_down), onPressed: () => setState(() => period = period == 'صباحًا' ? 'مساءً' : 'صباحًا')),
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
            onChanged: (value) => setState(() => selectedLine = value),
            items: const [
              DropdownMenuItem(value: '1', child: Text('خط رقم 1')),
              DropdownMenuItem(value: '2', child: Text('خط رقم 2')),
              DropdownMenuItem(value: '3', child: Text('خط رقم 3')),
            ],
          ),
        ],
      );
    } else if (currentStep == 2) {
      stepContent = Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const Text('اختيار المشرف', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade200,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            hint: const Text('اختر المشرف'),
            value: selectedSupervisor,
            onChanged: (value) => setState(() => selectedSupervisor = value),
            items: const [
              DropdownMenuItem(value: 'أحمد محمد', child: Text('أحمد محمد')),
              DropdownMenuItem(value: 'سارة علي', child: Text('سارة علي')),
            ],
          ),
        ],
      );
    } else {
      stepContent = Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('تأكيد بيانات الرحلة', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(16),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('الخط'), Text('خط رقم ${selectedLine ?? ''}')]),
                const SizedBox(height: 8),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('ميعاد الذهاب'), Text('$hour:${minute.toString().padLeft(2, '0')} $period')]),
                const SizedBox(height: 8),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('اسم المشرف'), Text(selectedSupervisor ?? '')]),
                const SizedBox(height: 8),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('تاريخ اليوم'), Text(selectedDate != null ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}' : '')]),
              ],
            ),
          ),
        ],
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
                          child: const Text('السابق'),
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
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text('تم التأكيد', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 20),
                                    const Icon(Icons.check_circle, color: Colors.green, size: 100),
                                    const SizedBox(height: 20),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        widget.onClose();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFE71A45),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                                        minimumSize: const Size.fromHeight(50),
                                      ),
                                      child: const Text('العودة الى الرئيسية'),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }
                        },
                        child: Text(currentStep < 3 ? 'التالي' : 'تأكيد'),
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
