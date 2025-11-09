import 'package:flutter/material.dart';

class AppColors {
  static const Color black = Colors.black;
  static const Color blue = Color.fromARGB(255, 255, 217, 0);
}

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.blue, // Set primary color
      scaffoldBackgroundColor: const Color.fromARGB(
        255,
        0,
        0,
        0,
      ), // Changed to black for dark theme
      appBarTheme: AppBarTheme(
        backgroundColor: const Color.fromARGB(
          255,
          0,
          0,
          0,
        ), // Changed to black for dark theme
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
        labelStyle: TextStyle(
          color: Colors.white,
        ), // Changed to white for better contrast
      ),
      colorScheme: ColorScheme.dark(
        primary: AppColors.blue,
        secondary: AppColors.blue,
      ),
    );
  }
}
