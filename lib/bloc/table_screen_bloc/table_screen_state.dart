part of 'table_screen_bloc.dart';

abstract class TableScreenState extends Equatable {
  const TableScreenState();

  @override
  List<Object> get props => [];
}

class TableScreenInitial extends TableScreenState {}

class TableScreenInitialState extends TableScreenState {}

class TableScreenLoadingState extends TableScreenState {}

class TableScreenLoadedState extends TableScreenState {
  List<TableInfoModel>? list = [];
  bool? isGridView = false;

  TableScreenLoadedState({this.list, this.isGridView});

  @override
  List<Object> get props => [list!, isGridView!];
}

class TableScreenErrorState extends TableScreenState {
  final String? errorMessage;

  const TableScreenErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage!];
}

class TableScreenNoInternetState extends TableScreenState {
  final String? errorMessage;

  const TableScreenNoInternetState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage!];
}
