import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:opal_app/core/resources/color_manager.dart';
import 'package:opal_app/features/Admin/Domain/entities/tour.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/update_add_delete_tour/update_add_delete_tour_cubit.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/update_add_delete_tour/update_add_delete_tour_state.dart';
import '../../../../core/resources/text_styles.dart';
import '../bloc/get_tour_bloc/tour_cubit.dart';
import '../pages/edit_trip_time.dart';

class TripDetailsDialog extends StatefulWidget {
  final String tourId;
  final Tour selectedtour;
  const TripDetailsDialog({required this.tourId, required this.selectedtour});

  @override
  State<TripDetailsDialog> createState() => _TripDetailsDialogState();
}

class _TripDetailsDialogState extends State<TripDetailsDialog> {
  // bool _inInit = true;

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   if (_inInit) {
  //     BlocProvider.of<GetTourIdCubit>(context).getTourById(widget.tourId);
  //     _inInit = false;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(16.w),
      child: Stack(
        children: [
          Positioned(
            left: 2.w,
            top: 2.h,
            child: Image.asset('assets/logos.png'),
          ),
          Container(
            width: size.width * 0.85,
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Text(
                    'بيانات الرحلة',
                    style: TextStyles.black20Bold.copyWith(fontSize: 20.sp),
                  ),
                ),
                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2.w),
                    borderRadius: BorderRadius.circular(12.r),
                    color: ColorManager.secondColor,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildRow(
                        'الخط',
                        widget.selectedtour.line.name ?? "غير معرف",
                      ),
                      _buildRow(
                        widget.selectedtour.typeDisplay,
                        '${DateFormat('HH:mm').format(widget.selectedtour.leavesAt)} صباحاً',
                      ),
                      _buildRow(
                        'اسم المشرف',
                        widget.selectedtour.supervisor.name ?? "غير معرف",
                      ),
                      _buildRow(
                        'تاريخ اليوم',
                        DateFormat(
                          'yyyy-MM-dd',
                        ).format(widget.selectedtour.leavesAt),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                ElevatedButton(
                  onPressed: () {
                    context.pop();
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        backgroundColor: Colors.transparent,
                        child: EditTripBox(
                          onClose: () => context.pop(),
                          tour: widget.selectedtour,
                          tourId: widget.tourId,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE71A45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    minimumSize: Size.fromHeight(50.h),
                  ),
                  child: Text(
                    'تعديل الرحلة',
                    style: TextStyles.white12Bold.copyWith(fontSize: 12.sp),
                  ),
                ),
                SizedBox(height: 12.h),
                BlocConsumer<
                  UpdateAddDeleteTourCubit,
                  UpdateAddDeleteTourState
                >(
                  listener: (context, state) {
                    if (state is TourDeleted) {
                      // لو الحذف نجح
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'تم حذف الرحلة بنجاح',
                            style: TextStyles.white12Bold,
                          ),
                        ),
                      );
                      BlocProvider.of<TourCubit>(context).getAllTours();

                      context.pop();
                    } else if (state is UpdateAddDeleteTourError) {
                      // لو حصل خطأ في الحذف
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            state.message,
                            style: TextStyles.white12Bold,
                          ),
                        ),
                      );
                    }
                  },
                  builder: (context, state) {
                    // الزرار موجود طول الوقت
                    return OutlinedButton(
                      onPressed: () {
                        context.read<UpdateAddDeleteTourCubit>().deleteTour(
                          widget.tourId,
                          context,
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: ColorManager.primaryColor,
                        side: BorderSide(
                          color: ColorManager.primaryColor,
                          width: 1.w,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                        minimumSize: Size.fromHeight(50.h),
                      ),
                      child: state is UpdateAddDeleteTourLoading
                          ? const CircularProgressIndicator(
                              color: ColorManager.primaryColor,
                            )
                          : Text(
                              'حذف الرحلة',
                              style: TextStyles.red12Bold.copyWith(
                                fontSize: 12.sp,
                              ),
                            ),
                    );
                  },
                ),

                SizedBox(height: 12.h),
                ElevatedButton(
                  onPressed: () {
                    context.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                    minimumSize: Size.fromHeight(50.h),
                  ),
                  child: Text(
                    'إغلاق',
                    style: TextStyles.white12Bold.copyWith(fontSize: 12.sp),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
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
