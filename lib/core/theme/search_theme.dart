import 'package:flutter/material.dart';

final searchTheme = ThemeData(
  scaffoldBackgroundColor: Colors.teal.shade50,
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.teal.shade800,
    iconTheme: IconThemeData(color: Colors.white),
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontFamily: "Cairo",
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    hintStyle: TextStyle(color: Colors.black54, fontFamily: "Cairo"),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
  ),
);
