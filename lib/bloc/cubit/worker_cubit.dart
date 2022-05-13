import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../data/model/worker.dart';

part 'worker_state.dart';

class WorkerCubit extends Cubit<WorkerState> {
  WorkerCubit() : super(WorkerInitial());

  void getWorkers() {
    emit(WorkerLoadInProgress());
    try {
      final workers = Hive.box<Worker>('workers').values.toList();
      emit(WorkerLoadSuccess(workers: workers));
    } catch (e) {
      emit(WorkerLoadFailure(message: e.toString()));
    }
  }

  void addWorker(Worker worker) {
    try {
      final box = Hive.box<Worker>('workers');
      box.add(worker);
      emit(WorkerLoadSuccess(workers: box.values.toList()));
    } catch (e) {
      emit(WorkerLoadFailure(message: e.toString()));
    }
  }

  void updateWorker(int index, Worker worker) {
    try {
      final box = Hive.box<Worker>('workers');
      box.putAt(index, worker);
      emit(WorkerLoadSuccess(workers: box.values.toList()));
    } catch (e) {
      emit(WorkerLoadFailure(message: e.toString()));
    }
  }

  void deleteWorker(int index) {
    try {
      final box = Hive.box<Worker>('workers');
      box.deleteAt(index);
      emit(WorkerLoadSuccess(workers: box.values.toList()));
    } catch (e) {
      emit(WorkerLoadFailure(message: e.toString()));
    }
  }
}