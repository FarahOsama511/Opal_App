import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' as intl;
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/text_styles.dart';
import '../../Data/models/tour_model.dart';
import '../widgets/cancel_trip_dialog.dart';

class TripDetailsScreen extends StatelessWidget {
  final TourModel tour;
  TripDetailsScreen({super.key, required this.tour});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ColorManager.secondColor,
        body: SafeArea(
          child: Stack(
            children: [
              Positioned(
                left: 210.w,
                top: -100.h,
                child: Opacity(
                  opacity: 0.2,
                  child: Image.asset(
                    'assets/logos.png',
                    width: 300.w,
                    height: 300.h,
                  ),
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'رحلة آمنة\nصحبتك السلامة!',
                            textAlign: TextAlign.right,
                            style: TextStyles.black20Bold.copyWith(
                              fontSize: 20.sp,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: ColorManager.blackColor,
                            size: 24.sp,
                          ),
                          onPressed: () {
                            context.pop();
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h),

                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: ColorManager.primaryColor,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(32.r),
                        ),
                      ),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 20.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(height: 40.h),
                            _InfoCard(tour: tour),
                            SizedBox(height: 20.h),
                            _ActionButtons(tourId: tour.id!),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatefulWidget {
  final TourModel tour;
  const _InfoCard({required this.tour});

  @override
  State<_InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<_InfoCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.black, width: 1.w),
      ),
      width: double.infinity,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            _InfoRow(
              title: 'اسم المشرف',
              value: widget.tour.driverName ?? "غير معرف",
            ),
            _InfoRow(title: 'الخط', value: widget.tour.line.name ?? ''),
            _InfoRow(
              title: 'ميعاد الذهاب',
              value:
                  '${intl.DateFormat('HH:mm').format(widget.tour.leavesAt)} صباحاً',
            ),
            _InfoRow(
              title: 'تاريخ اليوم',
              value: intl.DateFormat('yyyy-MM-dd').format(widget.tour.leavesAt),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String title;
  final String value;
  const _InfoRow({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyles.black14Bold.copyWith(fontSize: 14.sp)),
          Text(value, style: TextStyles.black14Bold.copyWith(fontSize: 14.sp)),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final String tourId;
  const _ActionButtons({required this.tourId});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _MainButton(
          label: 'تغيير الرحلة',
          backgroundColor: ColorManager.secondColor,
          textColor: ColorManager.primaryColor,
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) =>
                  CancelOREditTripDialog(tourId: tourId, isCancel: false),
            );
          },
        ),
        SizedBox(height: 12.h),
        _MainButton(
          label: 'إلغاء الرحلة',
          backgroundColor: ColorManager.greyColor,
          textColor: ColorManager.secondColor,
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) =>
                  CancelOREditTripDialog(tourId: tourId, isCancel: true),
            );
          },
        ),
      ],
    );
  }
}

class _MainButton extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onPressed;

  const _MainButton({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 46.h,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
          elevation: 0,
          side: BorderSide(
            color: textColor,
            width: backgroundColor == Colors.white ? 1.5.w : 0,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
