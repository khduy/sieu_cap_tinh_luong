import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'config/theme/theme.dart';
import 'config/constant/constant.dart';
import 'feature/home/home.dart';

import 'model/worker.dart';
import 'model/working_day.dart';

enum Edition {
  mama,
  di4,
}

Edition get currentEdition => Hive.box<String>(kEditionBoxName).get(kEditionKey)?.toEdition() ?? Edition.di4;

extension EditionExtension on String {
  Edition toEdition() {
    return Edition.values.firstWhere(
      (e) => e.toString() == this,
      orElse: () => Edition.di4,
    );
  }
}

extension EditionStringExtension on Edition {
  String toStorageString() {
    return toString();
  }
}

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(WorkerAdapter());
  Hive.registerAdapter(WorkingDayAdapter());
  await Hive.openBox<Worker>(kWorkerBoxName);
  await Hive.openBox<bool>(kDarkModeBoxName);
  await Hive.openBox<String>(kLogBoxName);
  await Hive.openBox<String>(kEditionBoxName);
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
