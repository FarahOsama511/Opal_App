import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/resources/text_styles.dart';

class ConfirmationSuccessScreen extends StatelessWidget {
  const ConfirmationSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      context.pop(true);
    });

    return Dialog(
      insetPadding: EdgeInsets.all(20.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Container(
        padding: EdgeInsets.all(20.w),
        constraints: BoxConstraints(maxWidth: 380.w, minHeight: 350.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              top: -200.h,
              bottom: -200.h,
              left: 0,
              right: -450.w,
              child: Opacity(
                opacity: 0.3,
                child: Image.asset('assets/logos.png', fit: BoxFit.cover),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 20.h),
                Text(
                  'تم التأكيد',
                  style: TextStyles.black20Bold.copyWith(fontSize: 20.sp),
                ),
                SizedBox(height: 20.h),
                Icon(Icons.check_circle, color: Colors.green, size: 130.h),
                SizedBox(height: 24.h),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
