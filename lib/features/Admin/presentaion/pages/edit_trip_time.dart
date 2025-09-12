import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:opal_app/core/resources/color_manager.dart';
import 'package:opal_app/core/resources/text_styles.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/update_add_delete_tour/update_add_delete_tour_cubit.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/update_add_delete_tour/update_add_delete_tour_state.dart';
import '../../Data/models/tour_model.dart';
import '../../Domain/entities/line_entity.dart';
import '../../Domain/entities/tour.dart';
import '../widgets/calender_step.dart';
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
        selectedSupervisor == null ||
        selectedLine == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("يرجى تعبئة جميع الحقول")));
      return;
    }

    final now = DateTime.now();

    // بناء startTime و endTime في يوم اليوم
    final fullStartTime = DateTime(
      now.year,
      now.month,
      now.day,
      startDate!.hour,
      startDate!.minute,
    );

    DateTime fullEndTime = DateTime(
      now.year,
      now.month,
      now.day,
      endDate!.hour,
      endDate!.minute,
    );

    // لو النهاية قبل البداية → نزود يوم
    if (fullEndTime.isBefore(fullStartTime)) {
      fullEndTime = fullEndTime.add(const Duration(days: 1));
    }

    // نحسب leavesAt
    DateTime fullLeavesAt = DateTime(
      now.year,
      now.month,
      now.day,
      leavesAtPeriod == 'صباحًا' ? leavesAtHour % 12 : (leavesAtHour % 12) + 12,
      leavesAtMinute,
    );

    // لو وقت الرحلة أقل أو يساوي endTime → نزود يوم عشان يركب صح
    if (fullLeavesAt.isBefore(fullEndTime) ||
        fullLeavesAt.isAtSameMomentAs(fullEndTime)) {
      fullLeavesAt = fullLeavesAt.add(const Duration(days: 1));
    }

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
            builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'تم التأكيد',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20.h),
                  Icon(Icons.check_circle, color: Colors.green, size: 100.sp),
                  SizedBox(height: 20.h),
                  ElevatedButton(
                    onPressed: () {
                      context.pop();
                      widget.onClose();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      minimumSize: Size(double.infinity, 50.h),
                    ),
                    child: Text(
                      'العودة الى الرئيسية',
                      style: TextStyles.white14Bold.copyWith(fontSize: 14.sp),
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
