import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppHeader extends StatelessWidget {
  final VoidCallback onLogout;
  final bool showAddButton;
  final VoidCallback? onAddPressed;
  final Widget? trailingWidget;
  final Widget? leadingWidget;
  final String? title;
  final Widget? titleWidget;
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
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          children: [
            leadingWidget ??
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: onLogout,
                  iconSize: 24.sp,
                ),

            if (showAddButton && onAddPressed != null)
              IconButton(
                icon: Icon(Icons.add_circle_outline, color: Colors.black, size: 24.sp), // تعديل الحجم
                onPressed: onAddPressed,
              ),

            Expanded(
              child: Center(
                child: titleWidget ??
                    (title != null
                        ? Text(
                      title!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.sp,
                      ),
                      textAlign: TextAlign.right,
                    )
                        : const SizedBox.shrink()),
              ),
            ),

            if (trailingWidget != null) trailingWidget!,
          ],
        ),
      ),
    );
  }
}
