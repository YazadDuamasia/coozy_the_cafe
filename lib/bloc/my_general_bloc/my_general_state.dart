part of 'my_general_bloc.dart';

sealed class MyGeneralState extends Equatable {
  const MyGeneralState();
}

final class MyGeneralInitialState extends MyGeneralState {
  @override
  List<Object> get props => [];
}

final class MyGeneralLoadingState extends MyGeneralState {
  @override
  List<Object> get props => [];
}

final class MyGeneralLoadedState extends MyGeneralState {
  @override
  List<Object> get props => [];
}

final class MyGeneralNoInternetState extends MyGeneralState {
  final String? error_str;

  const MyGeneralNoInternetState({required this.error_str});

  @override
  List<Object> get props => [error_str!];
}

final class MyGeneralErrorState extends MyGeneralState {
  final String? error_str;

  const MyGeneralErrorState({required this.error_str});

  @override
  List<Object> get props => [error_str!];
}

final class MyGeneralTimeOutErrorState extends MyGeneralState {
  final String? error_str;

  const MyGeneralTimeOutErrorState({required this.error_str});

  @override
  List<Object> get props => [error_str!];
}
