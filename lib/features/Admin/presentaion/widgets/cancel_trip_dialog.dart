import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opal_app/core/resources/color_manager.dart';
import 'package:opal_app/features/user/presentaion/bloc/selection_tour/selection_tour_cubit.dart';

import '../../../../core/resources/text_styles.dart';

class CancelOREditTripDialog extends StatelessWidget {
  final String tourId;
  bool? isCancel;

  CancelOREditTripDialog({super.key, required this.tourId, this.isCancel});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      title: (isCancel!)
          ? Text(
        'هل أنت متأكد من إلغاء الرحلة؟',
        style: TextStyles.black20Bold.copyWith(fontSize: 20.sp),
        textAlign: TextAlign.center,
      )
          : Text(
        'هل أنت متأكد من تعديل الرحلة؟',
        style: TextStyles.black20Bold.copyWith(fontSize: 20.sp),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                context.read<SelectionTourCubit>().UnconfirmTour(tourId);
                Navigator.pushReplacementNamed(context, '/home');
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
                style: TextStyle(fontSize: 16.sp),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
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
                style: TextStyle(fontSize: 16.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
