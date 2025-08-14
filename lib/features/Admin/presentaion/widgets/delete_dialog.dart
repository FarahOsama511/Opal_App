import 'package:flutter/material.dart';
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
    title: Center(child: Text(title, style: TextStyles.black20Bold)),
    content: Text(content, style: TextStyles.grey16Regular),
    actions: [
      PrimaryButton(
        backgroundColor: ColorManager.primaryColor,
        onPressed: onConfirm,
        text: "حذف",
      ),
      const SizedBox(height: 8),
      PrimaryButton(
        backgroundColor: ColorManager.greyColor,

        onPressed: () => Navigator.of(context).pop(),
        text: "إلغاء",
      ),
    ],
  );
}
