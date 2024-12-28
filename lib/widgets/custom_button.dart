import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton({
    Key? key,
    this.text,
    this.child,
    this.onPressed,
    this.padding = const EdgeInsets.all(8),
    this.color,
  }) : super(key: key) {
    assert(text != null || child != null);
  }

  final String? text;
  final Widget? child;
  final VoidCallback? onPressed;
  final EdgeInsets padding;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final color = this.color ?? Theme.of(context).colorScheme.primary;
    final textColor = ThemeData.estimateBrightnessForColor(color) == Brightness.light ? Colors.black : Colors.white;
    return Material(
      borderRadius: BorderRadius.circular(5),
      color: color,
      child: InkWell(
        borderRadius: BorderRadius.circular(5),
        onTap: onPressed,
        child: Center(
          child: Padding(
            padding: padding,
            child: child ??
                Text(
                  text!,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
          ),
        ),
      ),
    );
  }
}
