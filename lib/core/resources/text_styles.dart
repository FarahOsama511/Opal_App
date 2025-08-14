import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'color_manager.dart';

class TextStyles {
  TextStyles._();

  static TextStyle black16Regular = TextStyle(
    //Text field
    fontSize: 16.sp,
    fontFamily: 'Cairo',
    color: ColorManager.blackColor.withOpacity(.5),
    fontWeight: FontWeight.w400,
  );

  static TextStyle white14Bold = TextStyle(
    //buttons
    fontSize: 14.sp,
    fontFamily: 'Cairo',
    color: ColorManager.secondColor,
    fontWeight: FontWeight.w700,
  );
  static TextStyle white12Bold = TextStyle(
    fontSize: 12.sp,
    fontFamily: 'Cairo',
    color: ColorManager.secondColor,
    fontWeight: FontWeight.w700,
  );
  static TextStyle white20Bold = TextStyle(
    fontSize: 20.sp,
    fontFamily: 'Cairo',
    color: ColorManager.secondColor,
    fontWeight: FontWeight.w700,
  );

  // static TextStyle white14Bold = TextStyle(
  //   fontSize: 14.sp,
  //   fontFamily: 'Cairo',
  //   color: ColorManager.primaryColor,
  //   fontWeight: FontWeight.w700,
  // );

  static TextStyle grey14Regular = TextStyle(
    //الاقتراحات
    fontSize: 14.sp,
    fontFamily: 'Cairo',
    color: ColorManager.greyColor,
    fontWeight: FontWeight.w400,
  );

  static TextStyle grey16Regular = TextStyle(
    //الاقتراحات
    fontSize: 16.sp,
    fontFamily: 'Cairo',
    color: const Color.fromARGB(255, 93, 92, 92),
    fontWeight: FontWeight.w500,
  );
  static TextStyle red10Bold = TextStyle(
    fontSize: 10.sp,
    fontFamily: 'Cairo',
    color: ColorManager.primaryColor,
    fontWeight: FontWeight.w700,
  );
  static TextStyle red12Bold = TextStyle(
    fontSize: 12.sp,
    fontFamily: 'Cairo',
    color: ColorManager.primaryColor,
    fontWeight: FontWeight.w700,
  );

  static TextStyle black10Bold = TextStyle(
    fontSize: 10.sp,
    fontFamily: 'Cairo',
    color: ColorManager.blackColor,
    fontWeight: FontWeight.w700,
  );
  static TextStyle black14Bold = TextStyle(
    //data
    fontSize: 14.sp,
    fontFamily: 'Cairo',
    color: ColorManager.blackColor,
    fontWeight: FontWeight.w700,
  );
  static TextStyle black20Bold = TextStyle(
    //data
    fontSize: 20.sp,
    fontFamily: 'Cairo',
    color: ColorManager.blackColor,
    fontWeight: FontWeight.w700,
  );
}
