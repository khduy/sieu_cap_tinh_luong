import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sieu_cap_tinh_luong/bloc/cubit/worker_cubit.dart';
import 'package:sieu_cap_tinh_luong/config/bloc_observer.dart';
import 'package:sieu_cap_tinh_luong/config/theme/theme.dart';
import 'feature/home/home.dart';

import 'data/model/worker.dart';
import 'data/model/working_day.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(WorkerAdapter());
  Hive.registerAdapter(WorkingDayAdapter());
  await Hive.openBox<Worker>('workers');

  BlocOverrides.runZoned(
    () => runApp(const MyApp()),
    blocObserver: AppBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<WorkerCubit>(
      create: (context) => WorkerCubit()..getWorkers(),
      child: MaterialApp(
        title: 'Siêu cấp tính lương',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        theme: AppTheme.darkTheme,
        home: const HomePage(),
      ),
    );
  }
}
