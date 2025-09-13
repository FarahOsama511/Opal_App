import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/text_styles.dart';
import '../../../user/presentaion/bloc/selection_tour/selection_tour_cubit.dart';

class CancelOREditTripDialog extends StatelessWidget {
  final String tourId;
  final bool? isCancel;

  const CancelOREditTripDialog({
    super.key,
    required this.tourId,
    this.isCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      title: Text(
        isCancel!
            ? 'هل أنت متأكد من إلغاء الرحلة؟'
            : 'هل أنت متأكد من تعديل الرحلة؟',
        style: TextStyles.black20Bold.copyWith(fontSize: 20.sp),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                await context.read<SelectionTourCubit>().UnconfirmTour(tourId);
                context.go('/home');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.primaryColor,
                foregroundColor: ColorManager.secondColor,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                'نعم، أنا متأكد',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.greyColor,
                foregroundColor: ColorManager.blackColor,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: Text(
                'إلغاء',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
