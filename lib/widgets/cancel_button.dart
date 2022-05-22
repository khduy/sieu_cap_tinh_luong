import 'package:flutter/material.dart';

class CancelButton extends StatelessWidget {
  const CancelButton({
    Key? key,
    this.onPressed,
    this.text,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  }) : super(key: key);

  final VoidCallback? onPressed;

  final EdgeInsets padding;

  final String? text;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      child: Center(
        child: Padding(
          padding: padding,
          child: Text(
            text ?? 'Hủy',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
        ),
      ),
      onTap: onPressed,
    );
  }
}
