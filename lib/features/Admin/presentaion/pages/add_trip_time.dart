import 'package:flutter/material.dart';
import '../widgets/calender_step.dart';
import '../widgets/summary_step.dart';
import '../widgets/supervisor_step.dart';
import '../widgets/time_line_step.dart';

class AddTripBox extends StatefulWidget {
  final VoidCallback onClose;
  const AddTripBox({super.key, required this.onClose});

  @override
  State<AddTripBox> createState() => _AddTripBoxState();
}

class _AddTripBoxState extends State<AddTripBox> {
  int currentStep = 0;
  DateTime? selectedDate;
  int hour = 10;
  int minute = 0;
  String period = 'صباحًا';
  String? selectedSupervisor;
  String? selectedLine;
  DateTime focusedDay = DateTime.now();

  void nextStep() {
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
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
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
  }

  void prevStep() {
    if (currentStep > 0) setState(() => currentStep--);
  }

  @override
  Widget build(BuildContext context) {
    double boxWidth = MediaQuery.of(context).size.width * 0.85;
    double boxHeight = MediaQuery.of(context).size.height * 0.7;

    Widget stepContent;
    switch (currentStep) {
      case 0:
        stepContent = CalendarStep(
          focusedDay: focusedDay,
          selectedDate: selectedDate,
          onDaySelected: (selected, focused) {
            setState(() {
              selectedDate = selected;
              focusedDay = focused;
            });
          },
        );
        break;
      case 1:
        stepContent = TimeLineStep(
          hour: hour,
          minute: minute,
          period: period,
          selectedLine: selectedLine,
          onHourChanged: (val) => setState(() => hour = val),
          onMinuteChanged: (val) => setState(() => minute = val),
          onPeriodChanged: (val) => setState(() => period = val),
          onLineChanged: (val) => setState(() => selectedLine = val),
        );
        break;
      case 2:
        stepContent = SupervisorStep(
          selectedSupervisor: selectedSupervisor,
          onSupervisorChanged: (val) =>
              setState(() => selectedSupervisor = val),
        );
        break;
      default:
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
                          onPressed: prevStep,
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
                        onPressed: nextStep,
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
