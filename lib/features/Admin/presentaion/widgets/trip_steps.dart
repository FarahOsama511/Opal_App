import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opal_app/core/resources/color_manager.dart';
import '../../../../core/resources/text_styles.dart';
import '../bloc/update_add_delete_tour/update_add_delete_tour_cubit.dart';
import '../bloc/update_add_delete_tour/update_add_delete_tour_state.dart';

class StepHeader extends StatelessWidget {
  final VoidCallback onClose;
  const StepHeader({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: IconButton(
        icon: Icon(Icons.close, size: 24.sp),
        onPressed: onClose,
      ),
    );
  }
}

class StepButtons extends StatelessWidget {
  final int currentStep;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const StepButtons({
    super.key,
    required this.currentStep,
    required this.onNext,
    required this.onPrevious,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (currentStep > 0)
          Expanded(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.greyColor,
                minimumSize: Size.fromHeight(50.h),
              ),
              onPressed: onPrevious,
              child: Text(
                'السابق',
                style: TextStyles.white14Bold.copyWith(fontSize: 14.sp),
              ),
            ),
          ),
        if (currentStep > 0) SizedBox(width: 10.w),

        /// 👇 هنا نربط مع Cubit
        Expanded(
          child:
              BlocBuilder<UpdateAddDeleteTourCubit, UpdateAddDeleteTourState>(
                builder: (context, state) {
                  if (state is UpdateAddDeleteTourLoading && currentStep == 4) {
                    // لودينج مكان زرار التأكيد فقط
                    return Container(
                      height: 50.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: ColorManager.primaryColor,
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      child: const CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    );
                  }

                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.primaryColor,
                      minimumSize: Size.fromHeight(50.h),
                    ),
                    onPressed: onNext,
                    child: Text(
                      currentStep < 4 ? 'التالي' : 'تأكيد',
                      style: TextStyles.white14Bold.copyWith(fontSize: 14.sp),
                    ),
                  );
                },
              ),
        ),
      ],
    );
  }
}
