import 'package:flutter/material.dart';

class AppColors {
  static const Color black = Colors.black;
  static const Color blue = Color(0xFF0051FF);
}

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.blue,
      scaffoldBackgroundColor: AppColors.black,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.black,
        foregroundColor: AppColors.blue,
        elevation: 0,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.blue,
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: AppColors.blue),
        bodyMedium: const TextStyle(color: Colors.white),
        titleLarge: TextStyle(color: AppColors.blue),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: const OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.blue),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.blue, width: 2),
        ),
        hintStyle: const TextStyle(color: Colors.grey),
        labelStyle: TextStyle(color: AppColors.blue),
      ),
      colorScheme: ColorScheme.dark(
        primary: AppColors.blue,
        secondary: AppColors.blue,
      ),
    );
  }
}
