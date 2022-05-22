import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sieu_cap_tinh_luong/config/constant/constant.dart';
import 'config/theme/theme.dart';
import 'feature/home/home.dart';

import 'data/model/worker.dart';
import 'data/model/working_day.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(WorkerAdapter());
  Hive.registerAdapter(WorkingDayAdapter());
  await Hive.openBox<Worker>(kWorkerBoxName);
  await Hive.openBox<bool>(kDarkModeBoxName);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<bool>>(
      valueListenable: Hive.box<bool>(kDarkModeBoxName).listenable(),
      builder: (context, darkMode, _) {
        return MaterialApp(
          title: 'Siêu cấp tính lương',
          debugShowCheckedModeBanner: false,
          themeMode: (darkMode.get(kDarkModeKey) ?? false)
              ? ThemeMode.dark
              : ThemeMode.light,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          home: const HomePage(),
        );
      },
    );
  }
}
