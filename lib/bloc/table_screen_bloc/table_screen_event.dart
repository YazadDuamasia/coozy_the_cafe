part of 'table_screen_bloc.dart';

abstract class TableScreenEvent extends Equatable {
  const TableScreenEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LoadTableScreenDataEvent extends TableScreenEvent {}

class SwitchViewTableInfoEvent extends TableScreenEvent {}
class AddNewTableInfoEvent extends TableScreenEvent {}

class UpdateTableInfoEvent extends TableScreenEvent {
  final TableInfoModel updatedTableInfo;
  BuildContext context;

  UpdateTableInfoEvent({required this.updatedTableInfo, required this.context});

  @override
  List<Object> get props => [updatedTableInfo, context];
}

class DeleteTableInfoEvent extends TableScreenEvent {
  final TableInfoModel tableInfoModel;
  final int index;
  BuildContext context;

  DeleteTableInfoEvent(
      {required this.tableInfoModel,
      required this.index,
      required this.context});

  @override
  List<Object> get props => [tableInfoModel, index, context];
}

class onReOrderTableInfoEvent extends TableScreenEvent {
  final int oldIndex;
  final int newIndex;
  BuildContext context;

  onReOrderTableInfoEvent(
      {required this.oldIndex, required this.newIndex, required this.context});

  @override
  List<Object> get props => [oldIndex, newIndex, context];
}

class onMoveItemUpTableInfoEvent extends TableScreenEvent {
  final int currentIndex;
  BuildContext context;

  onMoveItemUpTableInfoEvent(
      {required this.currentIndex, required this.context});

  @override
  List<Object> get props => [currentIndex, context];
}

class onMoveItemDownTableInfoEvent extends TableScreenEvent {
  final int currentIndex;
  BuildContext context;

  onMoveItemDownTableInfoEvent(
      {required this.currentIndex, required this.context});

  @override
  List<Object> get props => [currentIndex, context];
}
