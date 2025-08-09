import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class JoinRequestCard extends StatelessWidget {
  final String name;
  final String phone;
  final String university;
  String? faculty;
  final bool isExpanded;
  final VoidCallback onToggle;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  JoinRequestCard({
    super.key,
    required this.name,
    required this.phone,
    required this.university,
    this.faculty,
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
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16.sp,
              ),
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
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 8.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildInfoRow('رقم الهاتف', phone),
                  _buildInfoRow('الجامعة', university),
                  // _buildInfoRow('الكلية', faculty),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: onReject,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                          ),
                          child: Text(
                            'رفض الطلب',
                            style: TextStyle(fontSize: 14.sp),
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
                          ),
                          child: Text(
                            'قبول الطلب',
                            style: TextStyle(fontSize: 14.sp),
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
          Text(
            value,
            style: TextStyle(color: Colors.black87, fontSize: 14.sp),
          ),
          Text(
            label,
            style: TextStyle(color: Colors.grey, fontSize: 14.sp),
          ),
        ],
      ),
    );
  }
}
