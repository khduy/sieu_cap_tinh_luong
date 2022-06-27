import 'package:flutter_bloc/flutter_bloc.dart';

class BreakCubit extends Cubit<bool> {
  BreakCubit() : super(true);

  void setBreak(bool value) => emit(value);
}
