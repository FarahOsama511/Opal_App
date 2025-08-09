import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/resources/text_styles.dart';

class ExpandableCard extends StatelessWidget {
  final String name;
  final String phone;
  final String university;
  final String line;
  final bool isSupervisor;
  final bool isExpanded;
  final VoidCallback onToggle;

  const ExpandableCard({
    super.key,
    required this.name,
    required this.phone,
    this.university = '',
    this.line = '',
    required this.isSupervisor,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 3.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  name,
                  textAlign: TextAlign.right,
                  style: TextStyles.black14Bold.copyWith(fontSize: 14.sp),
                ),
              ),
              IconButton(
                icon: Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down_rounded,
                  color: Colors.black,
                  size: 24.sp,
                ),
                onPressed: onToggle,
              ),
            ],
          ),
          if (isExpanded)
            Padding(
              padding: EdgeInsets.only(top: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildInfoRow(phone, 'رقم الهاتف:'),
                  if (!isSupervisor)
                    _buildInfoRow(university, 'الجامعة:')
                  else
                    _buildInfoRow(line, 'الخط:'),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyles.black10Bold.copyWith(fontSize: 10.sp)),
          Text(title, style: TextStyles.black10Bold.copyWith(fontSize: 10.sp)),
        ],
      ),
    );
  }
}
