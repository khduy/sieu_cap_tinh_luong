import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sieu_cap_tinh_luong/config/theme/theme.dart';
import 'package:sieu_cap_tinh_luong/dark_mode_cubit.dart';
import 'feature/home/home.dart';

import 'data/model/worker.dart';
import 'data/model/working_day.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(WorkerAdapter());
  Hive.registerAdapter(WorkingDayAdapter());
  await Hive.openBox<Worker>('workers');
  await Hive.openBox<bool>('darkMode');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final darkModeBox = Hive.box<bool>('darkMode');

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DarkModeCubit(darkModeBox),
      child: BlocBuilder<DarkModeCubit, bool>(
        builder: (context, state) {
          return MaterialApp(
            title: 'Siêu cấp tính lương',
            debugShowCheckedModeBanner: false,
            themeMode: state ? ThemeMode.dark : ThemeMode.light,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            home: HomePage(),
          );
        },
      ),
    );
  }
}
