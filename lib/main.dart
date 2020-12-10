import 'dart:core';
import 'package:flutter/material.dart';
import 'Screens/ChatScreen.dart';

main() {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: new ThemeData(
      accentColor: Colors.blue,
      primaryColor: Colors.white,
      primaryColorDark: Colors.white,
      fontFamily: 'Gamja Flower',
    ),
    home: new MyChatScreen(),
  ));
}
