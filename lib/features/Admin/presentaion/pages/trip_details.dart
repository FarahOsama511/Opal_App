import 'package:flutter/material.dart';
import 'package:intl/intl.dart' as intl;
import 'package:opal_app/features/user/presentaion/pages/user_home_screen.dart';
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
                left: 210,
                top: -100,
                child: Opacity(
                  opacity: 0.2,
                  child: Image.asset(
                    'assets/logos.png',
                    width: 300,
                    height: 300,
                  ),
                ),
              ),

              // محتوى الصفحة
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            'رحلة آمنة\nصحبتك السلامة!',
                            textAlign: TextAlign.right,
                            style: TextStyles.black20Bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: ColorManager.blackColor,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // الكارت والمعلومات
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: ColorManager.primaryColor,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(32),
                        ),
                      ),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const SizedBox(height: 40),
                            _InfoCard(tour: tour),
                            const SizedBox(height: 20),
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black, width: 1),
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
  final String tourId;
  const _ActionButtons({required this.tourId});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _MainButton(
          label: 'تغيير الرحلة',
          backgroundColor: Colors.white,
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
