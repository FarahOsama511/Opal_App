import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/text_styles.dart';
import '../../../Admin/Domain/entities/tour.dart';
import '../../../user/presentaion/bloc/selection_tour/selection_tour_cubit.dart';
import '../../../user/presentaion/bloc/selection_tour/selection_tour_state.dart';

class ConfirmDetailsScreen extends StatefulWidget {
  final Tour tour;
  const ConfirmDetailsScreen({super.key, required this.tour});

  @override
  State<ConfirmDetailsScreen> createState() => _ConfirmDetailsScreenState();
}

class _ConfirmDetailsScreenState extends State<ConfirmDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(16.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: ColorManager.secondColor,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: BlocListener<SelectionTourCubit, SelectionTourState>(
          listener: (context, state) {
            if (state is SelectionTourError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message, style: TextStyles.white12Bold),
                  backgroundColor: ColorManager.greyColor,
                ),
              );
            }
          },
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text(
                    'بيانات الذهاب و العودة',
                    style: TextStyles.black14Bold.copyWith(fontSize: 16.sp),
                  ),
                ),
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                    border: Border.all(color: ColorManager.blackColor),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _RowInfo(label: 'الخط', value: widget.tour.line.name!),
                      _RowInfo(
                        label: ' ${widget.tour.typeDisplay}',
                        value:
                            '${DateFormat('HH:mm').format(widget.tour.leavesAt)} صباحاً',
                      ),
                      _RowInfo(
                        label: 'اسم المشرف',
                        value: widget.tour.driverName ?? "غير معرف",
                      ),
                      _RowInfo(
                        label: 'تاريخ الرحلة',
                        value:
                            '${DateFormat('yyyy-MM-dd').format(widget.tour.leavesAt)}',
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: () async {
                      await context.read<SelectionTourCubit>().selectionTour(
                        widget.tour.id!,
                      );
                      final state = context.read<SelectionTourCubit>().state;
                      if (state is SelectionTourSuccess) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: ColorManager.greyColor,
                            content: Text(
                              "تم الحجز بنجاح",
                              style: TextStyles.white12Bold,
                            ),
                          ),
                        );
                        context.pop(true);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'تأكيد',
                      style: TextStyles.white14Bold.copyWith(fontSize: 14.sp),
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: () {
                      context.pop(false);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'السابق',
                      style: TextStyles.white14Bold.copyWith(fontSize: 14.sp),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
          Text(value, style: TextStyles.black14Bold.copyWith(fontSize: 14.sp)),
          Text(label, style: TextStyles.black14Bold.copyWith(fontSize: 14.sp)),
        ],
      ),
    );
  }
}
