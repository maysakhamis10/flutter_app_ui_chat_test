import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil_init.dart';
import 'Screens/ChatScreen.dart';
import 'Screens/home_page.dart';
import 'Utils/AppColors.dart';

main() {
  runApp(new


  MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: new ThemeData(
      accentColor: DARK_BLUE,
      primaryColor: Colors.white,
      primaryColorDark: Colors.white,
      fontFamily: 'Gamja Flower',
    ),
    home: ScreenUtilInit(
        allowFontScaling: false,
      child: HomePage(),)
  ));
}

