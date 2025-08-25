import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/resources/text_styles.dart';

class BusCard extends StatelessWidget {
  final bool isExpanded;
  final VoidCallback? onTap;
  final VoidCallback? onCancel;
  final VoidCallback? onNext;
  final String line;
  final String supervisorName;
  final String departureTime;
  final String date;
  final String? typeOfTrip;

  const BusCard({
    super.key,
    this.typeOfTrip,
    required this.isExpanded,
    this.onTap,
    this.onCancel,
    this.onNext,
    required this.line,
    required this.supervisorName,
    required this.departureTime,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: EdgeInsets.only(bottom: 15.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              bottom: -40.h,
              top: -40.h,
              right: 40.w,
              child: Opacity(
                opacity: 0.4,
                child: Image.asset(
                  'assets/logos.png',
                  width: 220.w,
                  height: 240.h,
                ),
              ),
            ),
            Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _RowInfo(label: 'الخط', value: line),
                  _RowInfo(label: 'اسم المشرف', value: supervisorName),
                  _RowInfo(label: typeOfTrip ?? 'نوع الرحلة', value: departureTime),
                  _RowInfo(label: 'تاريخ اليوم', value: date),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RowInfo extends StatelessWidget {
  final String label;
  final String value;
  const _RowInfo({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              value,
              style: TextStyles.black14Bold.copyWith(fontSize: 14.sp),
              textAlign: TextAlign.left,
            ),
          ),
          Flexible(
            child: Text(
              label,
              style: TextStyles.black14Bold.copyWith(fontSize: 14.sp),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
