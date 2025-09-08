import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/resources/text_styles.dart';

class SettingsExpandableCard extends StatelessWidget {
  final String name;
  final bool isSupervisor;
  final bool isExpanded;
  final VoidCallback onToggle;
  final String? location;
  final int? usersCount;
  final String? notes;
  final Widget? deleteIcon;

  const SettingsExpandableCard({
    required this.deleteIcon,
    super.key,
    required this.name,
    required this.isSupervisor,
    required this.isExpanded,
    required this.onToggle,
    this.location,
    this.usersCount,
    this.notes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
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
          InkWell(
            onTap: onToggle,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    name,
                    textAlign: TextAlign.right,
                    style: TextStyles.black14Bold.copyWith(fontSize: 14.sp),
                  ),
                ),
                if (isExpanded && deleteIcon != null) deleteIcon!,
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
          ),
          if (isExpanded)
            Padding(
              padding: EdgeInsets.only(top: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (!isSupervisor) ...[
                    _buildInfoRow(location ?? 'غير متوفر', 'الموقع:'),
                    _buildInfoRow((usersCount ?? 0).toString(), 'عدد الطلبة:'),
                  ] else
                    ...[
                      _buildInfoRow(notes ?? 'غير متوفر', 'الملاحظات:'),
                    ],
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String value, String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyles.black14Bold.copyWith(fontSize: 14.sp),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyles.black14Bold.copyWith(fontSize: 14.sp),
            softWrap: true,
            maxLines: null,
            overflow: TextOverflow.visible,
            textAlign: TextAlign.right,
          ),
        ],
      ),
    );
  }
}
