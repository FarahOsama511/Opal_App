import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/text_styles.dart';

class SearchField extends StatelessWidget {
  final String hintText;
  final ValueChanged<String> onChanged;
  final EdgeInsetsGeometry? padding;
  final IconData prefixIcon;
  final Color fillColor;
  final Color iconColor;

  const SearchField({
    Key? key,
    required this.hintText,
    required this.onChanged,
    this.padding,
    this.prefixIcon = Icons.search,
    this.fillColor = Colors.white,
    this.iconColor = ColorManager.secondColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.all(16.w),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
            vertical: 12.h,
            horizontal: 16.w,
          ),
          hintText: hintText,
          hintStyle: TextStyles.grey14Regular.copyWith(fontSize: 14.sp),
          prefixIcon: Icon(prefixIcon, color: iconColor, size: 24.sp),
          filled: true,
          fillColor: fillColor,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: iconColor, width: 1.5.w),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide(color: ColorManager.greyColor, width: 1.w),
          ),
        ),
      ),
    );
  }
}
