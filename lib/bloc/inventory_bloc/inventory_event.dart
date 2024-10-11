part of 'inventory_bloc.dart';

sealed class InventoryEvent extends Equatable {
  const InventoryEvent();
}

class FetchInventoryEvent extends InventoryEvent {
  @override
  List<Object?> get props => [];
}

class RefreshInventoryEvent extends InventoryEvent {
  @override
  List<Object?> get props => [];
}

class AddInventoryEvent extends InventoryEvent {
  final InventoryModel? inventory;

  const AddInventoryEvent(this.inventory);

  @override
  List<Object?> get props => [inventory!];
}

class UpdateInventoryEvent extends InventoryEvent {
  final InventoryModel? inventory;

  const UpdateInventoryEvent(this.inventory);

  @override
  List<Object?> get props => [inventory];
}

class DeleteInventoryEvent extends InventoryEvent {
  final int? inventoryId;

  const  DeleteInventoryEvent(this.inventoryId);

  @override
  List<Object?> get props => [inventoryId!];
}
