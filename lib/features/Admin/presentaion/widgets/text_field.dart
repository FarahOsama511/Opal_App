import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opal_app/core/resources/text_styles.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final String validatorMessage;
  final String? errorText;

  const CustomTextField({
    super.key,
    required this.hint,
    required this.controller,
    required this.validatorMessage,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
      child: TextFormField(
        controller: controller,
        textAlign: TextAlign.right,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyles.black16Regular,
          contentPadding: EdgeInsets.symmetric(
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
        ),
        validator: (value) =>
        value == null || value.isEmpty ? validatorMessage : null,
      ),
    );
  }
}
