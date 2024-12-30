import 'dart:convert';
import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../config/constant/constant.dart';
import '../model/log.dart';

import '../model/working_day.dart';

void hideKeyboard(BuildContext context) {
  final currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}

void showToastError(String message) {
  BotToast.showText(
    text: message,
    contentColor: Colors.redAccent,
  );
}

void showLoading() {
  if (BotToast.cacheCancelFunc[BotToast.loadKey]?.isEmpty ?? true) {
    BotToast.showCustomLoading(
      crossPage: true,
      backgroundColor: Colors.black.withOpacity(0.4),
      toastBuilder: (_) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF424242),
            borderRadius: BorderRadius.circular(10),
          ),
          width: 150,
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SpinKitWave(
                color: Colors.white,
                size: 30,
              ),
              SizedBox(height: 10),
              Text(
                'Chờ xí ...',
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        );
      },
    );
  }
}

void hideLoading() {
  BotToast.closeAllLoading();
}

String formatNumber(double number) {
  return NumberFormat("#.##").format(number);
}

void log(dynamic error, {StackTrace? stacktrace}) {
  final log = Log(error, stackTrace: stacktrace);
  Hive.box<String>(kLogBoxName).add(log.toString());
}

Future<List<WorkingDay>?> analyzeImageWithGemini(File imageFile) async {
  try {
    final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: 'AIzaSyCcruql7Ll1WalM7JItFL5WkMUNd8JdLt4',
    );

    final prompt = TextPart('''
    Analyze this image and determine if it's a timecard with check-in/check-out times.

    If the image is a timecard:
    - For each date, find the earliest check-in time (IN) and latest check-out time (OUT) across all periods (MORNING, AFTERNOON, OVERTIME)
    - Format the results as a JSON array with objects containing:
      + date: in DD format
      + timeIn: earliest time in HH:mm format
      + timeOut: latest time in HH:mm format
    - Only include dates that have at least one time entry
    - Sort results by date ascending
    - Return ONLY the JSON array, no additional text
    - Don't add a comma at the end of the JSON array
    - Example format:
      [
        {
          "date": "16",
          "timeIn": "06:00",
          "timeOut": "17:22"
        }
      ]
    
    If the image is NOT a timecard OR the times are unreadable:
    Return exactly: {"error": "INVALID_TIMECARD"}
    ''');

    final content = [
      Content.multi([
        prompt,
        DataPart('image/jpeg', imageFile.readAsBytesSync()),
      ])
    ];

    final response = await model.generateContent(content);

    if (response.text == null) throw 'Error analyzing image';

    // Check for error response first
    if (response.text!.contains('"error": "INVALID_TIMECARD"')) {
      throw 'Invalid timecard or unreadable image';
    }

    // Tìm và trích xuất phần JSON từ response
    final jsonMatch = RegExp(r'\[[\s\S]*\]').firstMatch(response.text!);
    if (jsonMatch == null) throw 'Error analyzing image';

    final jsonString = jsonMatch.group(0);
    if (jsonString == null) throw 'Error analyzing image';

    final jsonArray = jsonDecode(jsonString) as List<dynamic>;
    final result = <WorkingDay>[];
    for (var e in jsonArray) {
      if (e is Map<String, dynamic>) {
        result.add(WorkingDay.fromGemini(e));
      }
    }

    return result;
  } catch (e, s) {
    if (e.toString() == 'Invalid timecard or unreadable image') {
      showToastError('Đúng cái thẻ chấm công không đó ??');
    } else {
      showToastError('Lỗi gòi');
      log(e, stacktrace: s);
    }
    
    return null;
  }
}
