import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/resources/text_styles.dart';
import '../../Domain/entities/line_entity.dart';
import '../../Domain/entities/tour.dart';

class SummaryStep extends StatelessWidget {
  final String? typeOfTrip;
  final LineEntity? selectedLine;
  final int hour;
  final int minute;
  final String period;
  final SuperVisorEntity? selectedSupervisor;
  final DateTime? selectedDate;

  SummaryStep({
    required this.typeOfTrip,
    super.key,
    required this.selectedLine,
    required this.hour,
    required this.minute,
    required this.period,
    required this.selectedSupervisor,
    required this.selectedDate,
  });

  final Map<String, String> tripTypeMap = {
    'go': 'ميعاد الذهاب',
    'return': 'ميعاد العودة',
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'بيانات الرحلة',
          style: TextStyles.black20Bold.copyWith(fontSize: 20.sp),
        ),
        SizedBox(height: 10.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          margin: EdgeInsets.only(bottom: 16.h),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(16.r),
            color: Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildRow('الخط', selectedLine?.name ?? ''),
              SizedBox(height: 8.h),
              _buildRow(
                tripTypeMap[typeOfTrip] ?? '',
                '$hour:${minute.toString().padLeft(2, '0')} $period',
              ),
              SizedBox(height: 8.h),
              _buildRow('اسم المشرف', selectedSupervisor?.name ?? ''),
              SizedBox(height: 8.h),
              _buildRow(
                'تاريخ الرحلة',
                selectedDate != null
                    ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                    : '',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            label,
            style: TextStyles.black14Bold.copyWith(fontSize: 14.sp),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: TextStyles.black14Bold.copyWith(fontSize: 14.sp),
            textAlign: TextAlign.right,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
