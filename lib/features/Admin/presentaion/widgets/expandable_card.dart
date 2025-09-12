import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/resources/text_styles.dart';
import '../../../user/Domain/entities/university_entity.dart';

class ExpandableCard extends StatefulWidget {
  final String name;
  final String? phone;
  final UniversityEntity? university; // للطالب
  final List<UniversityEntity>? universities; // للمشرف
  final String line;
  final bool isSupervisor;
  final bool isExpanded;
  final VoidCallback onToggle;
  final Function()? onLongPress;
  final Widget? deleteIcon;

  ExpandableCard({
    this.universities,
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
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
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
        mainAxisSize: MainAxisSize.min,
        children: [
          // ====== الهيدر ======
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
                    size: 22.sp,
                  ),
                  onPressed: widget.onToggle,
                ),
              ],
            ),
          ),

          // ====== التفاصيل ======
          if (widget.isExpanded)
            Padding(
              padding: EdgeInsets.only(top: 6.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildInfoRow(widget.phone ?? 'غير متوفر', 'رقم الهاتف:'),

                  // للطالب
                  if (!widget.isSupervisor) ...[
                    _buildInfoRow(
                      widget.university?.name ?? 'غير متوفر',
                      'الجامعة:',
                    ),
                  ]
                  // للمشرف
                  else ...[
                    _buildInfoRow(
                      widget.line.isNotEmpty ? widget.line : 'غير متوفر',
                      'الخط:',
                    ),

                    Text(
                      "الجامعات:",
                      style: TextStyles.black14Bold.copyWith(fontSize: 13.sp),
                    ),
                    if (widget.universities != null &&
                        widget.universities!.isNotEmpty)
                      ...widget.universities!.map(
                        (uni) => Text(
                          "- ${uni.name}",
                          style: TextStyles.black14Bold,
                        ),
                      ),
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
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyles.black14Bold.copyWith(fontSize: 14.sp)),
          Text(value, style: TextStyles.black14Bold.copyWith(fontSize: 14.sp)),
        ],
      ),
    );
  }
}
