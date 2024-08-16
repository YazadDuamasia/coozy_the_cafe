part of 'waiter_list_screen_bloc.dart';

sealed class WaiterListScreenEvent extends Equatable {
  const WaiterListScreenEvent();

  @override
  List<Object> get props => [];
}

final class InitialLoadWaiterListScreenEvent extends WaiterListScreenEvent {}

final class SwitchViewWaiterListScreenEvent extends WaiterListScreenEvent {}

final class UpdateTableWaiterListScreenEvent extends WaiterListScreenEvent {
  final TableInfoModel updatedTableInfo;
  BuildContext context;

  UpdateTableWaiterListScreenEvent(
      {required this.updatedTableInfo, required this.context});

  @override
  List<Object> get props => [updatedTableInfo, context];
}

final class DeleteTableWaiterListScreenEvent extends WaiterListScreenEvent {
  final TableInfoModel tableInfoModel;
  final int index;
  BuildContext context;

  DeleteTableWaiterListScreenEvent(
      {required this.tableInfoModel,
      required this.index,
      required this.context});

  @override
  List<Object> get props => [tableInfoModel, index, context];
}

final class onReOrderTableInfoWaiterListScreenEvent
    extends WaiterListScreenEvent {
  final int oldIndex;
  final int newIndex;
  BuildContext context;

  onReOrderTableInfoWaiterListScreenEvent(
      {required this.oldIndex, required this.newIndex, required this.context});

  @override
  List<Object> get props => [oldIndex, newIndex, context];
}

final class onMoveItemUpTableInfoWaiterListScreenEvent
    extends WaiterListScreenEvent {
  final int currentIndex;
  BuildContext context;

  onMoveItemUpTableInfoWaiterListScreenEvent(
      {required this.currentIndex, required this.context});

  @override
  List<Object> get props => [currentIndex, context];
}

final class onMoveItemDownTableInfoWaiterListScreenEvent
    extends WaiterListScreenEvent {
  final int currentIndex;
  BuildContext context;

  onMoveItemDownTableInfoWaiterListScreenEvent(
      {required this.currentIndex, required this.context});

  @override
  List<Object> get props => [currentIndex, context];
}

final class AddNewTableWaiterListScreenEvent extends WaiterListScreenEvent {}
