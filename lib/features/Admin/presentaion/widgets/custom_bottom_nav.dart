import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 16.w,
      right: 16.w,
      bottom: 16.h,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFE71A45),
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.transparent,
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              elevation: 0,
              currentIndex: currentIndex,
              selectedItemColor: Colors.white,
              unselectedItemColor: Colors.white70,
              onTap: onTap,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'الرئيسية',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.alt_route),
                  label: 'الرحلات',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.list_outlined),
                  label: 'قائمة الطلاب',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.admin_panel_settings),
                  label: 'الإعدادات',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
