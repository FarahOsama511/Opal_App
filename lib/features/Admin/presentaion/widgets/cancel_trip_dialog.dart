import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: (isCancel!)
          ? Text(
              'هل أنت متأكد من إلغاء الرحلة؟',
              style: TextStyles.black20Bold,
              textAlign: TextAlign.center,
            )
          : Text(
              'هل أنت متأكد من تعديل الرحلة؟',
              style: TextStyles.black20Bold,
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
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('نعم، أنا متأكد'),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorManager.greyColor,
                foregroundColor: ColorManager.blackColor,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('إلغاء'),
            ),
          ),
        ],
      ),
    );
  }
}
