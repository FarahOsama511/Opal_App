import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/update_add_delete_tour/update_add_delete_tour_cubit.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/update_add_delete_tour/update_add_delete_tour_state.dart';
import 'package:opal_app/features/user/Domain/entities/user_entity.dart';
import '../../../../core/resources/text_styles.dart';
import '../../Data/models/tour_model.dart';
import '../../Domain/entities/tour.dart';
import '../widgets/calender_step.dart';
import '../widgets/summary_step.dart';
import '../widgets/supervisor_step.dart';
import '../widgets/time_line_step.dart';
import '../widgets/trip_steps.dart';

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
  UserEntity? selectedSupervisor;
  LineEntity? selectedLine;
  DateTime focusedDay = DateTime.now();
  void submitTour() {
    if (selectedDate == null ||
        selectedSupervisor == null ||
        selectedLine == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("يرجى تعبئة جميع الحقول")));
      return;
    }

    final DateTime fullDateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      period == 'صباحًا' ? hour : hour + 12,
      minute,
    );

    final tour = TourModel(
      //  superVisorName: selectedSupervisor?.name ?? "",
      type: 'go',
      driverName: selectedSupervisor?.name ?? "",
      leavesAt: fullDateTime,
      line: LineEntity(id: selectedLine!.id),
    );

    context.read<UpdateAddDeleteTourCubit>().addTour(tour);
  }

  void nextStep() {
    if (currentStep < 3) {
      setState(() => currentStep++);
    } else if (currentStep == 3) {
      submitTour();
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
          onLineChanged: (value) {
            setState(() => selectedLine = value);
          },
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

    return BlocListener<UpdateAddDeleteTourCubit, UpdateAddDeleteTourState>(
      listener: (context, state) {
        if (state is TourAdded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message, style: TextStyles.white12Bold),
            ),
          );
          print("STATE IS:${state}");
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
        } else if (state is UpdateAddDeleteTourError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      child: Center(
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
      ),
    );
  }
}
