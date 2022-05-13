import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sieu_cap_tinh_luong/bloc/cubit/worker_cubit.dart';
import 'package:sieu_cap_tinh_luong/bloc_observer.dart';
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
        themeMode: ThemeMode.dark,
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xff313133),
            toolbarTextStyle: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xfff3f3f3),
            ),
          ),
          scaffoldBackgroundColor: const Color(0xff3D3C3F),
          iconTheme: const IconThemeData(
            color: Color(0xffA2A1A4),
          ),
          splashColor: Colors.transparent,
          highlightColor: const Color(0xff5985FF),
          primaryColor: const Color(0xff313133),
        ),
        home: const HomePage(),
      ),
    );
  }
}
