import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DecimalTextField extends StatelessWidget {
  const DecimalTextField({
    Key? key,
    this.controller,
    this.focusNode,
    this.onSubmitted,
    this.onChanged,
    this.onEditingComplete,
    this.hintText,
    this.autoFocus = false,
    this.backgroundColor,
    this.hintAsLabel = false,
  })  : assert(!hintAsLabel || (hintAsLabel && hintText != null)),
        super(key: key);

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onEditingComplete;
  final String? hintText;
  final bool autoFocus;
  final Color? backgroundColor;
  final bool hintAsLabel;

  @override
  Widget build(BuildContext context) {
    return TextField(
      key: key,
      controller: controller,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide.none,
        ),
        fillColor: backgroundColor,
        filled: true,
        hintText: hintAsLabel ? null : hintText,
        label: hintAsLabel ? Text(hintText!) : null,
      ),
      focusNode: focusNode,
      autofocus: autoFocus,
      onSubmitted: onSubmitted,
      onChanged: onChanged,
      onEditingComplete: onEditingComplete,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r"[0-9.-]")),
        TextInputFormatter.withFunction((oldValue, newValue) {
          try {
            final text = newValue.text;
            if (text.isNotEmpty) double.parse(text);
            return newValue;
          } catch (_) {}
          return oldValue;
        }),
      ],
    );
  }
}
