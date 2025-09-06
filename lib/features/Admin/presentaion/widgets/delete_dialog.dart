import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:opal_app/core/resources/color_manager.dart';
import 'package:opal_app/features/Admin/presentaion/widgets/custom_widgets.dart';
import '../../../../core/resources/text_styles.dart';

Widget DeleteDialog({
  required BuildContext context,
  required String title,
  required String content,
  required VoidCallback onConfirm,
}) {
  return AlertDialog(
    title: Center(
      child: Text(
        title,
        style: TextStyles.black20Bold.copyWith(fontSize: 20.sp),
        textAlign: TextAlign.center,
      ),
    ),
    content: Text(
      content,
      style: TextStyles.grey16Regular.copyWith(fontSize: 16.sp),
      textAlign: TextAlign.center,
    ),
    actions: [
      PrimaryButton(
        backgroundColor: ColorManager.primaryColor,
        onPressed: onConfirm,
        text: "حذف",
        height: 46.h,
      ),
      SizedBox(height: 8.h),
      PrimaryButton(
        backgroundColor: ColorManager.greyColor,
        onPressed: () => context.pop(),
        text: "إلغاء",
        height: 46.h,
      ),
    ],
  );
}
