import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:opal_app/core/resources/text_styles.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/update_add_delete_tour/update_add_delete_tour_cubit.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/update_add_delete_tour/update_add_delete_tour_state.dart';
import '../../Data/models/tour_model.dart';
import '../../Domain/entities/line_entity.dart';
import '../../Domain/entities/tour.dart';
import '../widgets/calender_step.dart';
import '../widgets/confirmation_dialog.dart';
import '../widgets/start_end_time_step.dart';
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

  DateTime? startDate;
  DateTime? endDate;
  DateTime? selectedDate;
  int leavesAtHour = 10;
  int leavesAtMinute = 0;

  String leavesAtPeriod = 'صباحًا';
  int startHour = 7;
  int startMinute = 0;
  String startPeriod = 'صباحًا';

  int endHour = 12;
  int endMinute = 0;
  String endPeriod = 'مساءً';

  SuperVisorEntity? selectedSupervisor;
  LineEntity? selectedLine;
  String? typeOfTrip;

  DateTime focusedDay = DateTime.now();
  void submitTour() {
    if (startDate == null ||
        endDate == null ||
        selectedDate == null ||
        selectedSupervisor == null ||
        selectedLine == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("يرجى تعبئة جميع الحقول")));
      return;
    }

    final DateTime fullStartTime = DateTime(
      startDate!.year,
      startDate!.month,
      startDate!.day,
      startPeriod == 'صباحًا' ? startHour : startHour + 12,
      startMinute,
    );

    final DateTime fullEndTime = DateTime(
      endDate!.year,
      endDate!.month,
      endDate!.day,
      endPeriod == 'صباحًا' ? endHour : endHour + 12,
      endMinute,
    );

    if (fullEndTime.isBefore(fullStartTime)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("وقت الانتهاء يجب أن يكون بعد وقت البداية")),
      );
      return;
    }
    final DateTime fullLeavesAt = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      leavesAtPeriod == 'صباحًا' ? leavesAtHour : leavesAtHour + 12,
      leavesAtMinute,
    );

    final tour = TourModel(
      id: widget.tourId,
      supervisor: SuperVisorEntity(
        id: selectedSupervisor!.id,
        name: selectedSupervisor!.name,
      ),
      startTime: fullStartTime,
      endTime: fullEndTime,
      leavesAt: fullLeavesAt,
      type: typeOfTrip ?? "ذهاب",
      line: LineEntity(id: selectedLine!.id, name: selectedLine!.name),
    );

    context.read<UpdateAddDeleteTourCubit>().updateTour(tour, context);
  }

  void nextStep() {
    if (currentStep < 4) {
      setState(() => currentStep++);
    } else if (currentStep == 4) {
      submitTour();
    }
  }

  void prevStep() {
    if (currentStep > 0) setState(() => currentStep--);
  }

  @override
  void initState() {
    super.initState();

    final selectedTour = widget.tour;

    selectedSupervisor = selectedTour.supervisor;
    selectedLine = selectedTour.line;
    typeOfTrip = selectedTour.type;

    selectedDate = selectedTour.leavesAt;
    focusedDay = selectedTour.leavesAt;
    leavesAtHour = selectedTour.leavesAt.hour > 12
        ? selectedTour.leavesAt.hour - 12
        : selectedTour.leavesAt.hour;
    leavesAtMinute = selectedTour.leavesAt.minute;
    leavesAtPeriod = selectedTour.leavesAt.hour >= 12 ? 'مساءً' : 'صباحًا';

    startDate = selectedTour.startTime;
    startHour = selectedTour.startTime.hour > 12
        ? selectedTour.startTime.hour - 12
        : selectedTour.startTime.hour;
    startMinute = selectedTour.startTime.minute;
    startPeriod = selectedTour.startTime.hour >= 12 ? 'مساءً' : 'صباحًا';

    endDate = selectedTour.endTime;
    endHour = selectedTour.endTime.hour > 12
        ? selectedTour.endTime.hour - 12
        : selectedTour.endTime.hour;
    endMinute = selectedTour.endTime.minute;
    endPeriod = selectedTour.endTime.hour >= 12 ? 'مساءً' : 'صباحًا';
  }

  @override
  Widget build(BuildContext context) {
    double boxWidth = 0.85.sw;
    double boxHeight = 0.7.sh;

    Widget stepContent;
    switch (currentStep) {
      case 0:
        stepContent = CalendarStep(
          text: "تعديل ميعاد الرحلة",
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
          hour: leavesAtHour,
          minute: leavesAtMinute,
          period: leavesAtPeriod,
          selectedLine: selectedLine,
          onHourChanged: (val) => setState(() => leavesAtHour = val),
          onMinuteChanged: (val) => setState(() => leavesAtMinute = val),
          onPeriodChanged: (val) => setState(() => leavesAtPeriod = val),
          onTypeOfTripChanged: (val) => setState(() => typeOfTrip = val),
          onLineChanged: (value) {
            setState(() => selectedLine = value);
          },
        );

        break;
      case 2:
        stepContent = StartEndTimeStep(
          startDate: startDate,
          endDate: endDate,
          onStartDateChanged: (val) => setState(() => startDate = val),
          onEndDateChanged: (val) => setState(() => endDate = val),
        );
        break;
      case 3:
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
          hour: leavesAtHour,
          minute: leavesAtMinute,
          period: leavesAtPeriod,
          selectedSupervisor: selectedSupervisor,
          selectedDate: selectedDate,
        );
    }

    return BlocListener<UpdateAddDeleteTourCubit, UpdateAddDeleteTourState>(
      listener: (context, state) {
        if (state is TourUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message, style: TextStyles.white12Bold),
            ),
          );
          showDialog(
            context: context,
            builder: (context) => ConfirmationDialog(
              onReturn: () {
                context.pop();
                widget.onClose();
              },
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
            borderRadius: BorderRadius.circular(20.r),
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  StepHeader(onClose: widget.onClose),
                  Expanded(child: SingleChildScrollView(child: stepContent)),
                  SizedBox(height: 20.h),
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
