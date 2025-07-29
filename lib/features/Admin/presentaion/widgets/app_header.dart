import 'package:flutter/material.dart';

import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/text_styles.dart';

class AppHeader extends StatelessWidget {
  final VoidCallback onLogout;
  final bool showAddButton;
  final VoidCallback? onAddPressed;
  final Widget?
  trailingWidget; // لو عايز تضيف حاجة على الطرف التاني زي اللوجو أو أيقونات
  final Widget? leadingWidget; // لو عايز تحط أيقونات شمال بدل زر الخروج مثلاً
  final String? title;
  final Widget? titleWidget; // بدل النص لو حابب تبعت ويدجت
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;

  const AppHeader({
    super.key,
    required this.onLogout,
    this.showAddButton = false,
    this.onAddPressed,
    this.trailingWidget,
    this.leadingWidget,
    this.title,
    this.titleWidget,
    this.mainAxisAlignment = MainAxisAlignment.spaceBetween,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorManager.secondColor,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: [
          leadingWidget ??
              Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(3.1416),
                child: IconButton(
                  icon: const Icon(
                    Icons.logout,
                    size: 24,
                    color: ColorManager.blackColor,
                  ),
                  onPressed: onLogout,
                ),
              ),
          SizedBox(width: 80),
          if (showAddButton && onAddPressed != null)
            Row(
              children: [
                Text("إضافة", style: TextStyles.black14Bold),
                IconButton(
                  icon: Icon(
                    Icons.add_circle_outline,
                    color: ColorManager.blackColor,
                  ),
                  onPressed: onAddPressed,
                ),
              ],
            ),
          SizedBox(width: 142),
          Expanded(
            child:
                titleWidget ??
                (title != null
                    ? Text(title!, style: TextStyles.black20Bold)
                    : const SizedBox.shrink()),
          ),

          // الطرف الآخر (مثلاً اللوجو)
        ],
      ),
    );
  }
}
