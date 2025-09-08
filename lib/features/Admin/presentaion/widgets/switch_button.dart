import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/text_styles.dart';

class CustomSwitchButtons extends StatelessWidget {
  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final EdgeInsetsGeometry? padding;
  final double? minHeight;
  final Color? selectedColor;
  final Color? unselectedColor;
  final TextStyle? selectedTextStyle;
  final TextStyle? unselectedTextStyle;

  const CustomSwitchButtons({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onTap,
    this.padding,
    this.minHeight,
    this.selectedColor,
    this.unselectedColor,
    this.selectedTextStyle,
    this.unselectedTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: List.generate(labels.length, (index) {
          final isSelected = index == selectedIndex;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: index != labels.length - 1 ? 12.w : 0),
              child: ElevatedButton(
                onPressed: () => onTap(index),
                style: ElevatedButton.styleFrom(
                  backgroundColor: isSelected
                      ? selectedColor ?? ColorManager.primaryColor
                      : unselectedColor ?? Colors.grey.shade300,
                  minimumSize: Size.fromHeight(minHeight ?? 38.h),
                ),
                child: Text(
                  labels[index],
                  style: isSelected
                      ? selectedTextStyle ?? TextStyles.white14Bold
                      : unselectedTextStyle ?? TextStyles.black14Bold,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
