part of 'inventory_bloc.dart';

sealed class InventoryState extends Equatable {
  const InventoryState();
}

final class InventoryInitial extends InventoryState {
  @override
  List<Object> get props => [];
}

class InventoryLoadingState extends InventoryState {
  @override
  List<Object> get props => [];
}

class InventoryLoadedState extends InventoryState {
  final List<InventoryModel>? inventoryList;

  const InventoryLoadedState({this.inventoryList});

  @override
  List<Object> get props => [inventoryList!];
}

class InventoryErrorState extends InventoryState {
  final String? errorMessage;

  const InventoryErrorState({this.errorMessage});

  @override
  List<Object> get props => [errorMessage!];
}

class InventoryNoInternetState extends InventoryState {
  final String? errorMessage;

  const InventoryNoInternetState({this.errorMessage});

  @override
  List<Object> get props => [errorMessage!];
}
