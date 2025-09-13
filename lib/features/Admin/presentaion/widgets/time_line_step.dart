import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/text_styles.dart';
import '../../Domain/entities/line_entity.dart';
import '../bloc/get_lines/get_all_lines_cubit.dart';
import '../bloc/get_lines/get_all_lines_state.dart';
import 'custom_widgets.dart';

class TimeLineStep extends StatefulWidget {
  final int hour;
  final int minute;
  final String period;
  final LineEntity? selectedLine;
  final String? typeOfTrip;
  final ValueChanged<int> onHourChanged;
  final ValueChanged<int> onMinuteChanged;
  final ValueChanged<String> onPeriodChanged;
  final ValueChanged<LineEntity?> onLineChanged;
  final ValueChanged<String?> onTypeOfTripChanged;

  const TimeLineStep({
    required this.onTypeOfTripChanged,
    required this.typeOfTrip,
    super.key,
    required this.hour,
    required this.minute,
    required this.period,
    required this.selectedLine,
    required this.onHourChanged,
    required this.onMinuteChanged,
    required this.onPeriodChanged,
    required this.onLineChanged,
  });

  @override
  State<TimeLineStep> createState() => _TimeLineStepState();
}

class _TimeLineStepState extends State<TimeLineStep> {
  Widget timeSelector(
    String label,
    int value,
    VoidCallback onIncrement,
    VoidCallback onDecrement,
  ) {
    return Column(
      children: [
        IconButton(
          icon: Icon(Icons.keyboard_arrow_up, size: 30.sp),
          onPressed: onIncrement,
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            value.toString().padLeft(2, '0'),
            style: TextStyle(fontSize: 16.sp),
          ),
        ),
        IconButton(
          icon: Icon(Icons.keyboard_arrow_down, size: 30.sp),
          onPressed: onDecrement,
        ),
      ],
    );
  }

  final Map<String, String> tripTypeMap = {
    'ميعاد الذهاب': 'go',
    'ميعاد العودة': 'return',
  };

  @override
  void initState() {
    super.initState();
    BlocProvider.of<LinesCubit>(context).getAllLiness();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CustomDropdown<String>(
          label: 'اختر نوع الرحلة',
          value: tripTypeMap.values.contains(widget.typeOfTrip)
              ? tripTypeMap.keys.firstWhere(
                  (key) => tripTypeMap[key] == widget.typeOfTrip,
                )
              : null,
          items: tripTypeMap.keys.toList(),
          onChanged: (displayValue) {
            final backendValue = tripTypeMap[displayValue];
            widget.onTypeOfTripChanged(backendValue);
          },
        ),
        SizedBox(height: 15.h),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              timeSelector(
                'الساعة',
                widget.hour,
                () => widget.onHourChanged(
                  widget.hour == 12 ? 1 : widget.hour + 1,
                ),
                () => widget.onHourChanged(
                  widget.hour == 1 ? 12 : widget.hour - 1,
                ),
              ),
              SizedBox(width: 15.w),
              timeSelector(
                'الدقيقة',
                widget.minute,
                () => widget.onMinuteChanged((widget.minute + 1) % 60),
                () => widget.onMinuteChanged(
                  widget.minute == 0 ? 59 : widget.minute - 1,
                ),
              ),
              SizedBox(width: 15.w),
              Column(
                children: [
                  IconButton(
                    icon: Icon(Icons.keyboard_arrow_up, size: 30.sp),
                    onPressed: () => widget.onPeriodChanged(
                      widget.period == 'صباحًا' ? 'مساءً' : 'صباحًا',
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      widget.period,
                      style: TextStyle(fontSize: 16.sp),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.keyboard_arrow_down, size: 30.sp),
                    onPressed: () => widget.onPeriodChanged(
                      widget.period == 'صباحًا' ? 'مساءً' : 'صباحًا',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 20.h),
        BlocBuilder<LinesCubit, GetAllLinesState>(
          builder: (context, state) {
            if (state is LinesLoading) {
              return const CircularProgressIndicator(
                color: ColorManager.primaryColor,
              );
            } else if (state is LinesLoaded) {
              final allLines = state.Liness;
              return CustomDropdown(
                label: 'اختر الخط الخاص بك',
                value: widget.selectedLine,
                items: allLines,
                onChanged: widget.onLineChanged,
                displayString: (u) => u.name!,
              );
            } else {
              return Text('فشل في تحميل الخطوط', style: TextStyles.black14Bold);
            }
          },
        ),
      ],
    );
  }
}
