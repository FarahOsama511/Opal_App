import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'color_manager.dart';

class TextStyles {
  TextStyles._();

  static TextStyle black16Regular = TextStyle(
    //Text field
    fontSize: 16.sp,
    fontFamily: 'Roboto_Condensed',
    color: ColorManager.blackColor.withOpacity(.5),
    fontWeight: FontWeight.w400,
  );

  static TextStyle white14Bold = TextStyle(
    //buttons
    fontSize: 14.sp,
    fontFamily: 'Roboto_Condensed',
    color: ColorManager.secondColor,
    fontWeight: FontWeight.w700,
  );
  static TextStyle white12Bold = TextStyle(
    fontSize: 12.sp,
    fontFamily: 'Roboto_Condensed',
    color: ColorManager.secondColor,
    fontWeight: FontWeight.w700,
  );
  static TextStyle white20Bold = TextStyle(
    fontSize: 20.sp,
    fontFamily: 'Roboto_Condensed',
    color: ColorManager.secondColor,
    fontWeight: FontWeight.w700,
  );

  // static TextStyle white14Bold = TextStyle(
  //   fontSize: 14.sp,
  //   fontFamily: 'Roboto_Condensed',
  //   color: ColorManager.primaryColor,
  //   fontWeight: FontWeight.w700,
  // );

  static TextStyle grey14Regular = TextStyle(
    //الاقتراحات
    fontSize: 14.sp,
    fontFamily: 'Roboto_Condensed',
    color: ColorManager.greyColor,
    fontWeight: FontWeight.w400,
  );
  static TextStyle red10Bold = TextStyle(
    fontSize: 10.sp,
    fontFamily: 'Roboto_Condensed',
    color: ColorManager.primaryColor,
    fontWeight: FontWeight.w700,
  );

  static TextStyle black10Bold = TextStyle(
    fontSize: 10.sp,
    fontFamily: 'Roboto_Condensed',
    color: ColorManager.blackColor,
    fontWeight: FontWeight.w700,
  );
  static TextStyle black14Bold = TextStyle(
    //data
    fontSize: 14.sp,
    fontFamily: 'Roboto_Condensed',
    color: ColorManager.blackColor,
    fontWeight: FontWeight.w700,
  );
  static TextStyle black20Bold = TextStyle(
    //data
    fontSize: 20.sp,
    fontFamily: 'Roboto_Condensed',
    color: ColorManager.blackColor,
    fontWeight: FontWeight.w700,
  );
}
