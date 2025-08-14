import 'package:flutter/material.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/text_styles.dart';

class SearchField extends StatelessWidget {
  final String hintText;
  final ValueChanged<String> onChanged;
  final EdgeInsetsGeometry padding;
  final IconData prefixIcon;
  final Color fillColor;
  final Color iconColor;

  const SearchField({
    Key? key,
    required this.hintText,
    required this.onChanged,
    this.padding = const EdgeInsets.all(16.0),
    this.prefixIcon = Icons.search,
    this.fillColor = Colors.white,
    this.iconColor = ColorManager.secondColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          hintText: hintText,
          hintStyle: TextStyles.grey14Regular,
          prefixIcon: Icon(prefixIcon, color: iconColor),
          filled: true,
          fillColor: fillColor,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: iconColor, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: ColorManager.greyColor, width: 1.0),
          ),
        ),
      ),
    );
  }
}
