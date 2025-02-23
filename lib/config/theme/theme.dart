import 'package:flutter/material.dart';

class AppTheme {
  // ================ TextStyle ================

  static TextStyle body(BuildContext context) {
    return const TextStyle(
      fontWeight: FontWeight.w400,
    );
  }

  static TextStyle title(BuildContext context) {
    return const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
    );
  }

  static TextStyle label(BuildContext context) {
    return const TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w500,
    );
  }

  static TextStyle textFieldStyle(BuildContext context) {
    return const TextStyle(
      fontWeight: FontWeight.w500,
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

  static get darkTheme => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: Colors.indigo, // Primary color used as a seed
    ),
    useMaterial3: false,
  );

 static get lightTheme => ThemeData(
    colorScheme: ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: Colors.indigo, // Primary color used as a seed
    ),
    useMaterial3: false,
  );
}
