import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:opal_app/core/resources/color_manager.dart';
import 'package:opal_app/features/Admin/Domain/entities/tour.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/get_tour_id.dart/get_tour_id_cubit.dart';
import 'package:opal_app/features/Admin/presentaion/bloc/get_tour_id.dart/get_tour_id_state.dart';
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
  bool _inInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_inInit) {
      BlocProvider.of<GetTourIdCubit>(context).getTourById(widget.tourId);
      _inInit = false;
    }
  }

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
                  child: BlocBuilder<GetTourIdCubit, GetTourIdState>(
                    builder: (context, state) {
                      if (state is GetTourByIdLoading) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: ColorManager.primaryColor,
                          ),
                        );
                      } else if (state is TourByIdLoaded) {
                        final tour = state.tour;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _buildRow('الخط', tour.line.name!),
                            _buildRow(
                              tour.typeDisplay,
                              '${DateFormat('HH:mm').format(tour.leavesAt)} صباحاً',
                            ),
                            _buildRow(
                              'اسم المشرف',
                              tour.driverName ?? "غير معرف",
                            ),
                            _buildRow(
                              'تاريخ اليوم',
                              DateFormat('yyyy-MM-dd').format(tour.leavesAt),
                            ),
                          ],
                        );
                      } else {
                        return Center(
                          child: Text(
                            "حدث خطأ في جلب البيانات",
                            style: TextStyles.black14Bold.copyWith(
                              fontSize: 14.sp,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
                SizedBox(height: 20.h),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        backgroundColor: Colors.transparent,
                        child: EditTripBox(
                          onClose: () => Navigator.pop(context),
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
                BlocBuilder<UpdateAddDeleteTourCubit, UpdateAddDeleteTourState>(
                  builder: (context, state) {
                    if (state is UpdateAddDeleteTourLoading) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return OutlinedButton(
                      onPressed: () {
                        context.read<UpdateAddDeleteTourCubit>().deleteTour(
                          widget.tourId,
                        );
                        Navigator.pop(context);
                        BlocProvider.of<TourCubit>(context).getAllTours();
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
                      child: Text(
                        'حذف الرحلة',
                        style: TextStyles.red12Bold.copyWith(fontSize: 12.sp),
                      ),
                    );
                  },
                ),
                SizedBox(height: 12.h),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
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
