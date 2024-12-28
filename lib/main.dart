import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'config/theme/theme.dart';
import 'config/constant/constant.dart';
import 'feature/home/home.dart';

import 'model/worker.dart';
import 'model/working_day.dart';

const Edition edition = Edition.mama;

enum Edition {
  mama,
  di4,
}

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(WorkerAdapter());
  Hive.registerAdapter(WorkingDayAdapter());
  await Hive.openBox<Worker>(kWorkerBoxName);
  await Hive.openBox<bool>(kDarkModeBoxName);
  await Hive.openBox<String>(kLogBoxName);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<bool>>(
      valueListenable: Hive.box<bool>(kDarkModeBoxName).listenable(),
      builder: (context, darkMode, _) {
        final darkModeEnabled = darkMode.get(kDarkModeKey) ?? false;
        return MaterialApp(
          title: 'Tính lương',
          debugShowCheckedModeBanner: false,
          themeMode: darkModeEnabled ? ThemeMode.dark : ThemeMode.light,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          builder: BotToastInit(),
          home: const HomePage(),
        );
      },
    );
  }
}
