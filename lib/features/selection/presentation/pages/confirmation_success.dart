import 'package:flutter/material.dart';

import '../../../../core/resources/text_styles.dart';

class ConfirmationSuccessScreen extends StatelessWidget {
  const ConfirmationSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // تغلق الشاشة بعد ثانيتين
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context, true); // تغلق شاشة النجاح
    });

    return Dialog(
      insetPadding: const EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(20),
        constraints: const BoxConstraints(maxWidth: 380, minHeight: 350),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              top: -200,
              bottom: -200,
              left: 0,
              right: -450,
              child: Opacity(
                opacity: 0.3,
                child: Image.asset('assets/logos.png', fit: BoxFit.cover),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),
                Text('تم التأكيد', style: TextStyles.black20Bold),
                const SizedBox(height: 20),
                const Icon(Icons.check_circle, color: Colors.green, size: 130),
                const SizedBox(height: 24),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
