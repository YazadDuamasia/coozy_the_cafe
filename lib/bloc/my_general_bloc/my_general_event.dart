part of 'my_general_bloc.dart';

sealed class MyGeneralEvent extends Equatable {
  const MyGeneralEvent();
}

class FetchInitialGeneralEvent extends MyGeneralEvent {
  @override
  List<Object?> get props => [];
}

class RefreshGeneralEvent extends MyGeneralEvent {
  @override
  List<Object?> get props => [];
}
//Or CURD events