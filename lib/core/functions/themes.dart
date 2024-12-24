import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

ThemeData appTheme = ThemeData(
  primaryColor: AppColors.forestGreen,
  textTheme: TextTheme(
    titleLarge: const TextStyle(
        fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
    bodyMedium: TextStyle(fontSize: 16, color: Colors.grey[800]),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: AppColors.forestGreen, // Button text color
    ),
  ),
);
ThemeData darkTheme = ThemeData.dark().copyWith(
  primaryColor: Colors.greenAccent,
  hintColor: Colors.greenAccent,
  scaffoldBackgroundColor: Colors.black,
);
