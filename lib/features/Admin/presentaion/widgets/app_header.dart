import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opal_app/core/resources/color_manager.dart';

import '../../../../core/resources/text_styles.dart';

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
  final bool isAdmin;

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
    this.isAdmin = false,
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
          children: isAdmin
              ? [
                  if (showAddButton && onAddPressed != null)
                    TextButton.icon(
                      onPressed: onAddPressed,
                      icon: Icon(Icons.add, color: Colors.black, size: 30.sp),
                      label: Text("إضافة", style: TextStyles.black20Bold),
                    ),
                  const Spacer(),
                  IconButton(
                    icon: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..scale(-1.0, 1.0),
                      child: Icon(
                        Icons.logout,
                        size: 30.sp,
                        color: Colors.black,
                      ),
                    ),
                    onPressed: onLogout,
                    iconSize: 30.sp,
                  ),
                ]
              : [
                  leadingWidget ??
                      IconButton(
                        icon: const Icon(Icons.logout, color: Colors.black),
                        onPressed: onLogout,
                        iconSize: 30.sp,
                      ),
                  if (showAddButton && onAddPressed != null)
                    IconButton(
                      icon: const Icon(
                        Icons.add_circle_outline,
                        color: Colors.black,
                      ),
                      onPressed: onAddPressed,
                      iconSize: 24.sp,
                    ),
                  Expanded(
                    child: Center(
                      child:
                          titleWidget ??
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
