import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/resources/text_styles.dart';
import '../../../user/Domain/entities/university_entity.dart';

class ExpandableCard extends StatefulWidget {
  final String name;
  final String? phone;
  final UniversityEntity? university;

  final String line;
  final bool isSupervisor;
  final bool isExpanded;
  final VoidCallback onToggle;
  final Function()? onLongPress;
  final Widget? deleteIcon;

  ExpandableCard({
    this.onLongPress,
    this.deleteIcon,
    super.key,
    required this.name,
    this.phone,
    this.university,
    this.line = '',
    required this.isSupervisor,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  State<ExpandableCard> createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<ExpandableCard> {
  @override
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
          InkWell(
            onLongPress: widget.onLongPress,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.name,
                    textAlign: TextAlign.right,
                    style: TextStyles.black14Bold.copyWith(fontSize: 14.sp),
                  ),
                ),
                if (widget.isExpanded && widget.deleteIcon != null)
                  widget.deleteIcon!,
                IconButton(
                  icon: Icon(
                    widget.isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down_rounded,
                    color: Colors.black,
                    size: 24.sp,
                  ),
                  onPressed: widget.onToggle,
                ),
              ],
            ),
          ),
          if (widget.isExpanded)
            Padding(
              padding: EdgeInsets.only(top: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildInfoRow(widget.phone ?? 'غير متوفر', 'رقم الهاتف:'),
                  if (!widget.isSupervisor)
                    _buildInfoRow(widget.university?.name ?? "", 'الجامعة:')
                  else
                    _buildInfoRow(
                      widget.line.isNotEmpty ? widget.line : 'غير متوفر',
                      'الخط:',
                    ),
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
          Text(label, style: TextStyles.black14Bold.copyWith(fontSize: 14.sp)),
          Text(title, style: TextStyles.black14Bold.copyWith(fontSize: 14.sp)),
        ],
      ),
    );
  }
}
