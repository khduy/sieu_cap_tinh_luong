part of 'worker_cubit.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoadSuccess extends HomeState {
  final List<Worker> workers;

  const HomeLoadSuccess({required this.workers});

  @override
  List<Object> get props => [workers];
}

class HomeLoadFailure extends HomeState {
  final String message;

  const HomeLoadFailure({required this.message});

  @override
  List<Object> get props => [message];
}
