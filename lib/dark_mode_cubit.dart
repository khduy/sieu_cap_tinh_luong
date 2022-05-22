import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DarkModeCubit extends Cubit<bool> {
  DarkModeCubit(
    this.darkModeBox,
  ) : super(darkModeBox.get('enable') ?? false);
  final Box<bool> darkModeBox;

  void toggle() {
    darkModeBox.put('enable', !state);
    emit(!state);
  }
}
