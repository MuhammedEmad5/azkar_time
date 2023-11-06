
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'App_colors.dart';

ThemeData lightTheme(context) {
  return ThemeData(
    useMaterial3: true,
    fontFamily: 'ubuntu',
    scaffoldBackgroundColor: AppColors.backGround,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.backGround,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(
          fontSize: 24.sp, fontWeight: FontWeight.w700, color: AppColors.white),
      displayMedium: TextStyle(
          fontSize: 22.sp, fontWeight: FontWeight.w500, color: AppColors.white),
      displaySmall: TextStyle(
          fontSize: 20.sp, fontWeight: FontWeight.w400, color: AppColors.white),
      headlineMedium: TextStyle(
          fontSize: 18.sp, fontWeight: FontWeight.w300, color: AppColors.white),
      headlineSmall: TextStyle(
          fontSize: 16.sp, fontWeight: FontWeight.w300, color: AppColors.white),
      titleLarge: TextStyle(
          fontSize: 14.sp, fontWeight: FontWeight.w300, color: AppColors.white),
      bodySmall: TextStyle(
          fontSize: 12.sp, fontWeight: FontWeight.w300, color: AppColors.white),
      labelSmall: TextStyle(
          fontSize: 10.sp, fontWeight: FontWeight.w200, color: AppColors.white),
    ),
  );
}
