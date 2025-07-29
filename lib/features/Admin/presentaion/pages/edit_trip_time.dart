import 'package:flutter/material.dart';
import 'package:opal_app/features/Admin/Domain/entities/tour.dart';
import 'package:opal_app/features/user/Domain/entities/user_entity.dart';
import '../widgets/calender_step.dart';
import '../widgets/summary_step.dart';
import '../widgets/supervisor_step.dart';
import '../widgets/time_line_step.dart';
import '../widgets/trip_steps.dart';

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
  UserEntity? selectedSupervisor;
  LineEntity? selectedLine;
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
          onDaySelected: (selectedDay, focusedDayNew) {
            setState(() {
              selectedDate = selectedDay;
              focusedDay = focusedDayNew;
            });
          },
        );
        break;
      case 1:
        stepContent = TimeLineStep(
          hour: hour,
          minute: minute,
          period: period,
          selectedLine: selectedLine!,
          onHourChanged: (newHour) => setState(() => hour = newHour),
          onMinuteChanged: (newMinute) => setState(() => minute = newMinute),
          onPeriodChanged: (newPeriod) => setState(() => period = newPeriod),
          onLineChanged: (newLine) => setState(() => selectedLine = newLine),
        );
        break;
      case 2:
        stepContent = SupervisorStep(
          selectedSupervisor: selectedSupervisor,
          onSupervisorChanged: (value) =>
              setState(() => selectedSupervisor = value),
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
                StepHeader(onClose: widget.onClose),
                Expanded(child: SingleChildScrollView(child: stepContent)),
                const SizedBox(height: 20),
                StepButtons(
                  currentStep: currentStep,
                  onNext: nextStep,
                  onPrevious: prevStep,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
