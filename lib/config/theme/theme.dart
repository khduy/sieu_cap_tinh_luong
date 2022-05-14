import 'package:flutter/material.dart';

class AppTheme {
  static final darkTheme = ThemeData.from(
    colorScheme: const ColorScheme.dark(
      primary: Color(0xff5985FF),
      secondary: Color(0xff5985FF),
      surface: Color(0xff202121),
      background: Color(0xff202121),
      onBackground: Colors.white70,
      onSurface: Colors.white70,
      error: Colors.redAccent,
    ),
  );

  static final textFieldDecoration = InputDecoration(
    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(5),
      borderSide: BorderSide.none,
    ),
    fillColor: const Color(0xff313333),
    filled: true,
    hintStyle: const TextStyle(fontSize: 15),
  );
}
