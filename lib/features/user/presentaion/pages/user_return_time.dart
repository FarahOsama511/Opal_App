import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opal_app/core/resources/color_manager.dart';

import '../../../selection/presentation/pages/confirm_details.dart';

class ChooseReturnTimeScreen extends StatelessWidget {
  const ChooseReturnTimeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            const _Header(),
            Expanded(
              child: Center(
                child: Container(
                  margin: EdgeInsets.all(16.r),
                  padding: EdgeInsets.all(20.r),
                  decoration: BoxDecoration(
                    color: ColorManager.secondColor,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'اختر ميعاد العودة',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            hint: const Text('اختر ميعاد العودة'),
                            isExpanded: true,
                            items: const [
                              DropdownMenuItem(
                                value: '3:00',
                                child: Text('3:00 مساءً'),
                              ),
                              DropdownMenuItem(
                                value: '5:00',
                                child: Text('5:00 مساءً'),
                              ),
                            ],
                            onChanged: (val) {},
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorManager.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          onPressed: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (_) =>  ConfirmDetailsScreen(),
                            //   ),
                            // );
                          },
                          child: const Text(
                            'التالي',
                            style: TextStyle(color: ColorManager.secondColor),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorManager.greyColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'إلغاء',
                            style: TextStyle(color: ColorManager.secondColor),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      color: ColorManager.secondColor,
      child: Row(
        children: [
          Icon(Icons.logout, color: ColorManager.blackColor),
          SizedBox(width: 6.sw),
          Icon(Icons.person),
          Spacer(),
          Text(
            'متى تريد الذهاب؟',
            style: TextStyle(fontSize: 16.sp, color: ColorManager.blackColor),
          ),
        ],
      ),
    );
  }
}
