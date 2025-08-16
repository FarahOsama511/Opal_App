import 'package:flutter/material.dart';

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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          mainAxisAlignment: mainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          children: [
            leadingWidget ??
                IconButton(icon: const Icon(Icons.logout), onPressed: onLogout),

            if (showAddButton && onAddPressed != null)
              IconButton(
                icon: const Icon(Icons.add_circle_outline, color: Colors.black),
                onPressed: onAddPressed,
              ),

            Expanded(
              child: Center(
                child:
                    titleWidget ??
                    (title != null
                        ? Text(
                            title!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
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
