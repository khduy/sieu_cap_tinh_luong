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
    return InkWell(
      borderRadius: BorderRadius.circular(5),
      child: Ink(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: color ?? Theme.of(context).colorScheme.primary,
        ),
        child: Center(
          child: Padding(
            padding: padding,
            child: child ??
                Text(
                  text!,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
          ),
        ),
      ),
      onTap: onPressed,
    );
  }
}
