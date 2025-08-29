import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:opal_app/core/resources/color_manager.dart';

import '../../../../core/resources/text_styles.dart';

class WaitingScreen extends StatelessWidget {
  const WaitingScreen({super.key});
  Future<bool> showExitDialog(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('تأكيد الخروج', style: TextStyles.black20Bold),
            content: Text(
              'هل تريد الخروج من التطبيق؟',
              style: TextStyles.black16Regular,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text('لا', style: TextStyles.black10Bold),
              ),
              TextButton(
                onPressed: () {
                  if (Platform.isAndroid) {
                    SystemNavigator.pop();
                  } else if (Platform.isIOS) {
                    Navigator.of(context).pop(true);
                  } else {
                    SystemNavigator.pop();
                  }
                },
                child: Text('نعم', style: TextStyles.red10Bold),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: SizedBox(
              height: size.height * 0.85,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(20.r),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: ColorManager.primaryColor,
                    ),
                    child: Image.asset('assets/logo.png', width: 0.35.sw),
                  ),
                  SizedBox(height: 30.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                    child: Text(
                      'برجاء الانتظار، في أقرب وقت سيتم الموافقة على طلب إنشاء حسابك من قبل أحد المسؤولين',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: ColorManager.blackColor,
                        height: 1.6,
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: SizedBox(
                      width: double.infinity,
                      height: 40.h,
                      child: ElevatedButton(
                        onPressed: () async {
                          bool? exitConfirmed = await showExitDialog(context);
                          // لو iOS وأكد المستخدم "نعم" (exitConfirmed == true)
                          // ممكن تضيف هنا أي سلوك آخر لو تحب، أو تخلي المستخدم يخرج بالطريقة الطبيعية (زر الـ Home)
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorManager.primaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          'خروج من التطبيق',
                          style: TextStyles.white14Bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
