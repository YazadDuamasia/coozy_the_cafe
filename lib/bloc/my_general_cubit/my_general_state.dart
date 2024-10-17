part of 'my_general_cubit.dart';

sealed class MyGeneralState extends Equatable {
  const MyGeneralState();
}

class InitialState extends MyGeneralState {
  @override
  List<Object> get props => [];
}

class LoadingState extends MyGeneralState {
  @override
  List<Object> get props => [];
}

class LoadedState extends MyGeneralState {
  final List? data;

  const LoadedState(this.data);

  @override
  List<Object> get props => [data!];
}

class ErrorState extends MyGeneralState {
  final String? errorMessage;

  const ErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage!];
}

class NoInternetState extends MyGeneralState {
  @override
  List<Object> get props => [];
}
