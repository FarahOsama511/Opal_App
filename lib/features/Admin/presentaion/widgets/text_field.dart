import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opal_app/core/resources/text_styles.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final String? errorText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextAlign textAlign;
  final EdgeInsetsGeometry? contentPadding;

  const CustomTextField({
    super.key,
    required this.hint,
    required this.controller,
    this.validator,
    this.errorText,
    this.obscureText = false,
    this.keyboardType,
    this.textAlign = TextAlign.right,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 10.h,
        horizontal: 10.w,
      ),
      child: TextFormField(
        controller: controller,
        textAlign: textAlign,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyles.black16Regular.copyWith(fontSize: 16.sp),
          contentPadding: contentPadding ??
              EdgeInsets.symmetric(
                horizontal: 10.w,
                vertical: 15.h,
              ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(color: Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(color: Colors.black),
          ),
          errorText: errorText,
          errorStyle: TextStyle(color: Colors.red, fontSize: 12.sp),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: const BorderSide(color: Colors.red),
          ),
        ),
        validator: validator,
      ),
    );
  }
}
