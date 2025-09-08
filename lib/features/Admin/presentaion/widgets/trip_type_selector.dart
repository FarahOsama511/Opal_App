import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/resources/text_styles.dart';

class TripTypeSelector extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  const TripTypeSelector({
    super.key,
    this.selectedIndex = 0,
    required this.onChanged,
  });

  @override
  State<TripTypeSelector> createState() => _TripTypeSelectorState();
}

class _TripTypeSelectorState extends State<TripTypeSelector> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.selectedIndex;
  }

  void _onSelect(int index) {
    setState(() {
      _currentIndex = index;
    });
    widget.onChanged(index); // ⬅️ نرجع الاختيار للـ parent
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () => _onSelect(0),
              style: ElevatedButton.styleFrom(
                backgroundColor: _currentIndex == 0
                    ? const Color(0xFFE71A45)
                    : Colors.grey.shade300,
                minimumSize: Size.fromHeight(38.h),
              ),
              child: Text(
                'رحلات الذهاب',
                style: _currentIndex == 0
                    ? TextStyles.white14Bold
                    : TextStyles.black14Bold,
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: ElevatedButton(
              onPressed: () => _onSelect(1),
              style: ElevatedButton.styleFrom(
                backgroundColor: _currentIndex == 1
                    ? const Color(0xFFE71A45)
                    : Colors.grey.shade300,
                minimumSize: Size.fromHeight(38.h),
              ),
              child: Text(
                'رحلات العودة',
                style: _currentIndex == 1
                    ? TextStyles.white14Bold
                    : TextStyles.black14Bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
