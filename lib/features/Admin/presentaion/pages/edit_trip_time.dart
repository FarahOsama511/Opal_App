import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:opal_app/core/resources/text_styles.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/update_add_delete_tour/update_add_delete_tour_cubit.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/update_add_delete_tour/update_add_delete_tour_state.dart';
import 'package:opal_app/features/user/Domain/entities/user_entity.dart';
import '../../Data/models/tour_model.dart';
import '../../Domain/entities/tour.dart';
import '../bloc/get_tour_bloc/tour_cubit.dart';
import '../widgets/calender_step.dart';
import '../widgets/summary_step.dart';
import '../widgets/supervisor_step.dart';
import '../widgets/time_line_step.dart';
import '../widgets/trip_steps.dart';

class EditTripBox extends StatefulWidget {
  final VoidCallback onClose;
  final Tour tour;
  final String tourId;
  EditTripBox({
    super.key,
    required this.onClose,
    required this.tour,
    required this.tourId,
  });
  @override
  State<EditTripBox> createState() => _EditTripTimeState();
}

class _EditTripTimeState extends State<EditTripBox> {
  int currentStep = 0;
  DateTime? selectedDate;
  int hour = 10;
  int minute = 0;
  String period = 'صباحًا';
  String? driverName;
  UserEntity? selectedSupervisor;
  LineEntity? selectedLine;
  DateTime focusedDay = DateTime.now();
  String? typeOfTrip;
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
      id: widget.tourId,
      type: typeOfTrip ?? "ذهاب",
      driverName: selectedSupervisor?.name ?? "",
      leavesAt: fullDateTime,
      line: LineEntity(id: selectedLine!.id),
    );

    context.read<UpdateAddDeleteTourCubit>().updateTour(tour);
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
  void initState() {
    print("✅ Tour ID: ${widget.tour.id}");
    super.initState();

    final selectedTour = widget.tour;
    //driverName = selectedTour.driverName;
    selectedDate = selectedTour.leavesAt;
    focusedDay = selectedTour.leavesAt;
    selectedLine = selectedTour.line;

    typeOfTrip = selectedTour.type;
    hour = selectedTour.leavesAt.hour > 12
        ? selectedTour.leavesAt.hour - 12
        : selectedTour.leavesAt.hour;
    minute = selectedTour.leavesAt.minute;
    period = selectedTour.leavesAt.hour >= 12 ? 'مساءً' : 'صباحًا';
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
          typeOfTrip: typeOfTrip,
          hour: hour,
          minute: minute,
          period: period,
          selectedLine: selectedLine,
          onHourChanged: (val) => setState(() => hour = val),
          onMinuteChanged: (val) => setState(() => minute = val),
          onPeriodChanged: (val) => setState(() => period = val),
          onTypeOfTripChanged: (val) => setState(() => typeOfTrip = val),
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
          typeOfTrip: typeOfTrip,
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
        print("=============================${state}====================");
        if (state is TourUpdated) {
          print("Tour Updated Successfully");
          context.read<TourCubit>().getAllTours();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message, style: TextStyles.white12Bold),
            ),
          );
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
                      Navigator.of(context).pop();
                      widget.onClose();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE71A45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: Text(
                      'العودة الى الرئيسية',
                      style: TextStyles.white14Bold,
                    ),
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
