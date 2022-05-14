import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;
  final Color? color;

  const CustomButton({
    Key? key,
    required this.child,
    required this.onTap,
    this.onLongPress,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.white12,
      highlightColor: Colors.white12,
      splashFactory: InkRipple.splashFactory,
      borderRadius: BorderRadius.circular(10),
      child: Ink(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Color(0xff313333),
        ),
        child: Center(child: child),
      ),
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}
