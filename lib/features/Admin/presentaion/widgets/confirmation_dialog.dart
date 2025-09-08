import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opal_app/core/resources/color_manager.dart';
import 'package:opal_app/core/resources/text_styles.dart';
import 'package:go_router/go_router.dart';

class ConfirmationDialog extends StatelessWidget {
  final VoidCallback onReturn;

  const ConfirmationDialog({super.key, required this.onReturn});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
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
              onReturn();
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
    );
  }
}
