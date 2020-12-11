import 'dart:core';
import 'package:flutter/material.dart';
import 'Screens/ChatScreen.dart';
import 'Utils/AppColors.dart';

main() {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: new ThemeData(
      accentColor: DARK_BLUE,
      primaryColor: Colors.white,
      primaryColorDark: Colors.white,
      fontFamily: 'Gamja Flower',
    ),
    home: new MyChatScreen(),
  ));
}

