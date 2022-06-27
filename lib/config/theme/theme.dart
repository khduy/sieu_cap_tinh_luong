import 'package:flutter/material.dart';

class AppTheme {
  // ================ ThemeData ================
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

  // ================ TextStyle ================

  static TextStyle body(BuildContext context) {
    return TextStyle(
      fontWeight: FontWeight.w400,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle title(BuildContext context) {
    return TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle lable(BuildContext context) {
    return TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  static TextStyle textFieldStyle(BuildContext context) {
    return TextStyle(
      fontWeight: FontWeight.w500,
      color: Theme.of(context).colorScheme.onSurface,
    );
  }

  // ================ decoration ================

  static InputDecoration textFieldDecoration({String? hintText}) {
    return InputDecoration(
      contentPadding: const EdgeInsets.all(12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),
        borderSide: BorderSide.none,
      ),
      fillColor: Colors.black12,
      filled: true,
      isDense: true,
      hintText: hintText,
      errorStyle: const TextStyle(
        color: Colors.redAccent,
      ),
    );
  }
}
