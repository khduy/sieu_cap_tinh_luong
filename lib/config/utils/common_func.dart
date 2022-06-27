import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void showToastError(String message) {
  BotToast.showText(
    text: message,
    contentColor: Colors.redAccent,
  );
}

String formatNumber(double number) {
  return NumberFormat("#.##").format(number);
}
