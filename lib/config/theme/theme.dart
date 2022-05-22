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
      secondary: Colors.indigo,
      surface: Colors.white,
      background: Colors.white,
      error: Colors.redAccent,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.black.withOpacity(0.7),
      onBackground: Colors.black.withOpacity(0.7),
      onError: Colors.white,
    ),
    splashFactory: InkRipple.splashFactory,
    hintColor: Colors.black45,
  );

  static final dark = ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: Colors.indigo[400]!,
      secondary: Colors.indigo[400]!,
      surface: Colors.grey[800]!,
      background: Colors.grey[900]!,
      error: Colors.redAccent,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      onBackground: Colors.white,
      onError: Colors.white,
    ),
    splashFactory: InkRipple.splashFactory,
    hintColor: Colors.white54,
  );

  static TextStyle textFieldLabelStyle(context) {
    final theme = Theme.of(context);
    return TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: theme.colorScheme.onSurface,
    );
  }
}
