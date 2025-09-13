import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/text_styles.dart';

class AddMenu extends StatelessWidget {
  final VoidCallback onAddTrip;

  const AddMenu({super.key, required this.onAddTrip});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 80.h,
      right: 16.w,
      left: 16.w,
      child: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildAddOption(context, 'إضافة مسؤول جديد', '/addAdmin'),
              _buildAddOption(context, 'إضافة مشرف جديد', '/addSupervisor'),
              TextButton(
                onPressed: onAddTrip,
                style: TextButton.styleFrom(
                  foregroundColor: ColorManager.blackColor,
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                ),
                child: Text(
                  'إضافة ميعاد جديد',
                  style: TextStyles.black10Bold.copyWith(fontSize: 12.sp),
                ),
              ),
              _buildAddOption(context, 'إضافة خط جديد', '/addLine'),
              _buildAddOption(context, 'إضافة جامعة جديدة', '/addUniversity'),
              _buildAddOption(context, 'إضافة مدينة جديدة', '/addDownTown'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddOption(BuildContext context, String title, String route) {
    return TextButton(
      onPressed: () => context.push(route),
      style: TextButton.styleFrom(
        foregroundColor: ColorManager.blackColor,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.symmetric(vertical: 12.h),
      ),
      child: Text(
        title,
        style: TextStyles.black10Bold.copyWith(fontSize: 12.sp),
      ),
    );
  }
}
