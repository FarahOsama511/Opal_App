import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart' as intl;
import 'package:opal_app/core/resources/color_manager.dart';
import '../../../../core/resources/text_styles.dart';
import '../../../user/presentaion/bloc/auth_cubit.dart';
import '../bloc/get_tour_bloc/tour_cubit.dart';
import '../bloc/get_tour_bloc/tour_state.dart';
import '../widgets/cancel_trip_dialog.dart';

class TripDetailsScreen extends StatelessWidget {
  String tourId;
  TripDetailsScreen({super.key, required this.tourId});
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ColorManager.primaryColor,
        body: SafeArea(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, right: 10),
                  child: Opacity(
                    opacity: 0.25,
                    child: Image.asset(
                      'assets/logo.png',
                      width: 120,
                      height: 120,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      textDirection: TextDirection.ltr,
                      children: [
                        Icon(
                          Icons.arrow_back_ios,
                          color: ColorManager.blackColor,
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Directionality(
                            textDirection: TextDirection.rtl,
                            child: Text(
                              'رحلة آمنة\nصحبتك السلامة${context.read<AuthCubit>().user!.user.name}!',
                              textAlign: TextAlign.start,
                              style: TextStyles.black20Bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 20,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          _InfoCard(tourId: tourId),
                          const SizedBox(height: 20),
                          _ActionButtons(tourId: tourId),
                        ],
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
  final String tourId;
  _InfoCard({required this.tourId});

  @override
  State<_InfoCard> createState() => _InfoCardState();
}

class _InfoCardState extends State<_InfoCard> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<TourCubit>(context).getTourById(widget.tourId);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: ColorManager.secondColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black, width: 1),
      ),
      width: double.infinity,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: BlocBuilder<TourCubit, TourState>(
          builder: (context, state) {
            if (state is TourLoading) {
              return Center(
                child: CircularProgressIndicator(
                  color: ColorManager.primaryColor,
                ),
              );
            } else if (state is TourByIdLoaded) {
              final tour = state.tour;
              return Column(
                children: [
                  _InfoRow(title: 'اسم الطالب', value: ''),
                  _InfoRow(title: 'اسم المشرف', value: tour.driverName),
                  _InfoRow(title: 'الخط', value: tour.line.name!),
                  _InfoRow(
                    title: 'ميعاد الذهاب',
                    value:
                        '${intl.DateFormat('HH:mm').format(tour.leavesAt)} صباحاً',
                  ),
                  // _InfoRow(title: 'ميعاد العودة', value: '3:00 مساءً'),
                  _InfoRow(
                    title: 'تاريخ اليوم',
                    value:
                        '${intl.DateFormat('yyyy-MM-dd').format(tour.leavesAt)}',
                  ),
                ],
              );
            } else {
              return Center(
                child: Text(
                  "حدث خطأ في جلب البيانات",
                  style: TextStyles.red10Bold,
                ),
              );
            }
          },
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
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(color: Colors.black)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  String tourId;
  _ActionButtons({required this.tourId});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),
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
        const SizedBox(height: 12),
        _MainButton(
          label: 'إلغاء الرحلة',
          backgroundColor: Colors.grey,
          textColor: Colors.white,
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
      height: 46,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          elevation: 0,
          side: BorderSide(
            color: textColor,
            width: backgroundColor == Colors.white ? 1.5 : 0,
          ),
        ),
        child: Text(label, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
