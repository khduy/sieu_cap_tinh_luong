import 'package:flutter/material.dart';

class AppTheme {
  static final textFieldDecoration = InputDecoration(
    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide.none,
    ),
    fillColor: Colors.black12,
    filled: true,
  );

  static const textFieldTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static final light = ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: Colors.indigo,
      secondary: Colors.indigo[700]!,
      surface: Colors.white,
      background: Colors.white,
      error: Colors.redAccent,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.black.withOpacity(0.7),
      onBackground: Colors.black.withOpacity(0.7),
      onError: Colors.white,
    ),
  );

  static final dark = ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: Colors.indigo,
      secondary: Colors.indigo[700]!,
      surface: Colors.grey[800]!,
      background: Colors.grey[900]!,
      error: Colors.redAccent,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      onBackground: Colors.white,
      onError: Colors.white,
    ),
  );
}
