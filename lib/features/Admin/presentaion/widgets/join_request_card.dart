import 'package:Opal/core/resources/color_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/resources/text_styles.dart';

class JoinRequestCard extends StatelessWidget {
  final String name;
  final String phone;
  final String university;
  final String? downTown;
  final bool isExpanded;
  final VoidCallback onToggle;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  JoinRequestCard({
    super.key,
    required this.name,
    required this.phone,
    required this.university,
    this.downTown,
    required this.isExpanded,
    required this.onToggle,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              name,
              textAlign: TextAlign.right,
              style: TextStyles.black14Bold.copyWith(fontSize: 16.sp),
            ),
            trailing: IconButton(
              icon: Icon(
                isExpanded
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                size: 24.sp,
              ),
              onPressed: onToggle,
            ),
          ),
          if (isExpanded)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildInfoRow('رقم الهاتف', phone),
                  _buildInfoRow('الجامعة', university),
                  if (downTown != null) _buildInfoRow('المدينة', downTown!),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onReject,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorManager.primaryColor,
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Text(
                            'رفض الطلب',
                            style: TextStyles.white12Bold.copyWith(
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onAccept,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Text(
                            'قبول الطلب',
                            style: TextStyles.white12Bold.copyWith(
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
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
