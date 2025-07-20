import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  final VoidCallback onLogout;
  final bool showAddButton;
  final VoidCallback? onAddPressed;
  final Widget? trailingWidget; // لو عايز تضيف حاجة على الطرف التاني زي اللوجو أو أيقونات
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
    this.crossAxisAlignment = CrossAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        crossAxisAlignment: crossAxisAlignment,
        children: [
          leadingWidget ??
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: onLogout,
              ),

          // لو في زر إضافة
          if (showAddButton && onAddPressed != null)
            IconButton(
              icon: const Icon(Icons.add_circle_outline, color: Colors.black),
              onPressed: onAddPressed,
            ),

          // العنوان أو ويدجت العنوان في الوسط
          Expanded(
            child: Center(
              child: titleWidget ??
                  (title != null
                      ? Text(
                    title!,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 20),
                  )
                      : const SizedBox.shrink()),
            ),
          ),

          // الطرف الآخر (مثلاً اللوجو)
          trailingWidget ??
              Image.asset(
                'assets/logo.png',
                height: 60,
              ),
        ],
      ),
    );
  }
}
