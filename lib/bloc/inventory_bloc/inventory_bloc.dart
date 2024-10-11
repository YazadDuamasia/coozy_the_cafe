import 'dart:async';

import 'package:coozy_the_cafe/model/inventory_model/inventory_model.dart';
import 'package:coozy_the_cafe/repositories/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'inventory_event.dart';

part 'inventory_state.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  final RestaurantRepository repository;

  InventoryBloc(this.repository) : super(InventoryInitial()) {
    on<FetchInventoryEvent>(_handleInitialLoadingData);
    on<RefreshInventoryEvent>(_handleRefreshLoadingData);
    on<AddInventoryEvent>(_handleOnAddNewSubCategoryData);
    on<UpdateInventoryEvent>(_handleUpdateSubCategoryData);
    on<DeleteInventoryEvent>(_handleDeleteSubCategoryData);
  }

  final BehaviorSubject<InventoryState> _stateSubject = BehaviorSubject();

  Stream<InventoryState> get stateStream => _stateSubject.stream;

  void emitState(InventoryState state) => _stateSubject.sink.add(state);

  @override
  Future<void> close() {
    _stateSubject.close();
    return super.close();
  }

  FutureOr<void> _handleInitialLoadingData(
      FetchInventoryEvent event, Emitter<InventoryState> emit) async {
    try {} catch (e) {
      emitState(InventoryErrorState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> _handleRefreshLoadingData(
      RefreshInventoryEvent event, Emitter<InventoryState> emit) async {
    try {} catch (e) {
      emitState(InventoryErrorState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> _handleOnAddNewSubCategoryData(
      AddInventoryEvent event, Emitter<InventoryState> emit) async {
    try {} catch (e) {
      emitState(InventoryErrorState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> _handleUpdateSubCategoryData(
      UpdateInventoryEvent event, Emitter<InventoryState> emit) async {
    try {} catch (e) {
      emitState(InventoryErrorState(errorMessage: e.toString()));
    }
  }

  FutureOr<void> _handleDeleteSubCategoryData(
      DeleteInventoryEvent event, Emitter<InventoryState> emit) async {
    try {} catch (e) {
      emitState(InventoryErrorState(errorMessage: e.toString()));
    }
  }
}
