part of 'my_general_cubit.dart';

abstract class MyGeneralState extends Equatable {
  const MyGeneralState();

  @override
  List<Object> get props => [];
}

class InitialState extends MyGeneralState {}

class LoadingState extends MyGeneralState {}

class LoadedState extends MyGeneralState {
  final List? data;

  LoadedState(this.data);

  @override
  List<Object> get props => [data!];
}

class ErrorState extends MyGeneralState {
  final String? errorMessage;

  ErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage!];
}

class NoInternetState extends MyGeneralState {}
