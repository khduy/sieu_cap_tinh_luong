part of 'worker_cubit.dart';

abstract class WorkerState extends Equatable {
  const WorkerState();

  @override
  List<Object> get props => [];
}

class WorkerInitial extends WorkerState {}

class WorkerLoadInProgress extends WorkerState {}

class WorkerLoadSuccess extends WorkerState {
  final List<Worker> workers;

  const WorkerLoadSuccess({required this.workers});

  @override
  List<Object> get props => [workers];
}

class WorkerLoadFailure extends WorkerState {
  final String message;

  const WorkerLoadFailure({required this.message});

  @override
  List<Object> get props => [message];
}
