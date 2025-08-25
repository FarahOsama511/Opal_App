import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opal_app/core/resources/color_manager.dart';

import '../../../../core/resources/text_styles.dart';

/// دائرة اللوجو الحمراء
class LogoCircle extends StatelessWidget {
  const LogoCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(20.r),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: ColorManager.primaryColor,
        ),
        child: Image.asset('assets/logo.png', width: 80.w, fit: BoxFit.contain),
      ),
    );
  }
}

/// زر أساسى
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color backgroundColor;
  final double? height;

  const PrimaryButton({
    required this.backgroundColor,
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height ?? 50.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: EdgeInsets.symmetric(vertical: 8.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.r),
          ),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const CircularProgressIndicator(
          color: ColorManager.primaryColor,
        )
            : Text(text, style: TextStyles.white14Bold),
      ),
    );
  }
}

class CustomDropdown<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<T> items;
  final ValueChanged<T?> onChanged;
  final String Function(T)? displayString;

  const CustomDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.displayString,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField<T>(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: ColorManager.blackColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: ColorManager.blackColor),
            ),
            filled: false,
          ),
          isExpanded: true,
          value: value,
          hint: Text(label, style: TextStyles.grey14Regular),
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(
                displayString != null ? displayString!(item) : item.toString(),
                style: TextStyles.black14Bold,
              ),
            );
          }).toList(),
          onChanged: onChanged,
          validator: (val) => val == null ? 'يرجى اختيار $label' : null,
        ),
      ),
    );
  }
}
