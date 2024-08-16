part of 'waiter_list_screen_bloc.dart';

sealed class WaiterListScreenState extends Equatable {
  const WaiterListScreenState();

  @override
  List<Object> get props => [];
}

final class WaiterListScreenInitialState extends WaiterListScreenState {}

final class WaiterListScreenLoadingState extends WaiterListScreenState {}

final class WaiterListScreenLoadedState extends WaiterListScreenState {
  List<TableInfoModel>? tableList = [];
  bool? isGridView = false;

  WaiterListScreenLoadedState(
      {required this.tableList, required this.isGridView});

  @override
  List<Object> get props => [tableList!];
}

final class WaiterListScreenErrorState extends WaiterListScreenState {
  String? message;

  WaiterListScreenErrorState(this.message);

  @override
  List<Object> get props => [message!];
}
