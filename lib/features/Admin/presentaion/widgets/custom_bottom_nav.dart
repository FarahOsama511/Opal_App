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
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: BottomNavigationBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            currentIndex: currentIndex,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
            onTap: onTap,
            selectedLabelStyle: TextStyle(fontSize: 12.sp),
            unselectedLabelStyle: TextStyle(fontSize: 11.sp),
            selectedIconTheme: IconThemeData(size: 28.sp),
            unselectedIconTheme: IconThemeData(size: 24.sp),
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
            ],
          ),
        ),
      ),
    );
  }
}
