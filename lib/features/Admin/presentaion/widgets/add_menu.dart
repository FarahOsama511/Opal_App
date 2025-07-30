import 'package:flutter/material.dart';
import 'package:opal_app/core/resources/color_manager.dart';

import '../../../../core/resources/text_styles.dart';

class AddMenu extends StatelessWidget {
  final VoidCallback onAddTrip;

  const AddMenu({super.key, required this.onAddTrip});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 80,
      right: 16,
      left: 16,
      child: Material(
        elevation: 6,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildAddOption(context, 'إضافة مسؤول جديد', '/addAdmin'),
              _buildAddOption(context, 'إضافة مشرف جديد', '/addSupervisor'),
              TextButton(
                onPressed: onAddTrip,
                style: TextButton.styleFrom(
                  foregroundColor: ColorManager.blackColor,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text('إضافة ميعاد جديد', style: TextStyles.black10Bold),
              ),
              _buildAddOption(context, 'إضافة خط جديد', '/addLine'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddOption(BuildContext context, String title, String route) {
    return TextButton(
      onPressed: () => Navigator.pushNamed(context, route),
      style: TextButton.styleFrom(
        foregroundColor: ColorManager.blackColor,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Text(title, style: TextStyles.black10Bold),
    );
  }
}
