import 'package:flutter/material.dart';
import '../widgets/cancel_trip_dialog.dart';

class TripDetailsScreen extends StatelessWidget {
  const TripDetailsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFE71A45),
        body: Stack(
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
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    textDirection: TextDirection.ltr,
                    children: [
                      Icon(Icons.arrow_back_ios, color: Colors.black),
                      SizedBox(width: 10),
                      Expanded(
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: Text(
                            'رحلة آمنة\nصحبتك السلامة مهاب!',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
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
                        const _InfoCard(),
                        const SizedBox(height: 20),
                        _ActionButtons(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard();
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
      child: const Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          children: [
            _InfoRow(title: 'اسم الطالب', value: 'مهاب محمد فوزي'),
            _InfoRow(title: 'اسم المشرف', value: 'أحمد محمد أحمد'),
            _InfoRow(title: 'الخط', value: 'خط رقم 1'),
            _InfoRow(title: 'ميعاد الذهاب', value: '7:00 صباحاً'),
            _InfoRow(title: 'ميعاد العودة', value: '3:00 مساءً'),
            _InfoRow(title: 'تاريخ اليوم', value: '22/6/2025'),
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
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _MainButton(
          label: 'تواصل مع المشرف',
          backgroundColor: const Color(0xFFE71A45),
          textColor: Colors.white,
          onPressed: () {},
        ),
        const SizedBox(height: 12),
        _MainButton(
          label: 'تغيير الميعاد',
          backgroundColor: Colors.white,
          textColor: const Color(0xFFE71A45),
          onPressed: () {},
        ),
        const SizedBox(height: 12),
        _MainButton(
          label: 'إلغاء الرحلة',
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => const CancelTripDialog(),
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
