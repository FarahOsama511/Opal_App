import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/resources/color_manager.dart';
import '../../../../core/resources/text_styles.dart';

class SwitchButtonsWidget extends StatelessWidget {
  final bool isUniversitySelected;
  final bool isLineSelected;
  final bool isCitySelected;
  final VoidCallback onUniversityPressed;
  final VoidCallback onLinePressed;
  final VoidCallback onCityPressed;

  const SwitchButtonsWidget({
    super.key,
    required this.isUniversitySelected,
    required this.isLineSelected,
    required this.isCitySelected,
    required this.onUniversityPressed,
    required this.onLinePressed,
    required this.onCityPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: onUniversityPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: isUniversitySelected
                    ? ColorManager.primaryColor
                    : Colors.grey.shade300,
                minimumSize: Size(0, 45.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.r),
                ),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'الجامعات',
                  style: isUniversitySelected
                      ? TextStyles.white14Bold
                      : TextStyles.black14Bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: ElevatedButton(
              onPressed: onLinePressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: isLineSelected
                    ? ColorManager.primaryColor
                    : Colors.grey.shade300,
                minimumSize: Size(0, 45.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.r),
                ),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'الخطوط',
                  style: isLineSelected
                      ? TextStyles.white14Bold
                      : TextStyles.black14Bold,
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: ElevatedButton(
              onPressed: onCityPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: isCitySelected
                    ? ColorManager.primaryColor
                    : Colors.grey.shade300,
                minimumSize: Size(0, 45.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.r),
                ),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  'المدن',
                  style: isCitySelected
                      ? TextStyles.white14Bold
                      : TextStyles.black14Bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
