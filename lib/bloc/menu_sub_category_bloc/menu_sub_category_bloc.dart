import 'dart:async';

import 'package:collection/collection.dart';
import 'package:coozy_cafe/model/category.dart';
import 'package:coozy_cafe/model/sub_category.dart';
import 'package:coozy_cafe/repositories/components/restaurant_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'menu_sub_category_event.dart';

part 'menu_sub_category_state.dart';

class MenuSubCategoryBloc
    extends Bloc<MenuSubCategoryEvent, MenuSubCategoryState> {
  MenuSubCategoryBloc() : super(MenuSubCategoryInitialState()) {
    on<InitialLoadingDataEvent>(_handleInitialLoadingData);
    on<EditSubCategoryEvent>(_handleEditSubCategory);
    on<DeleteSubCategoryEvent>(_handleDeleteSubCategory);
    on<SearchSubCategoryEvent>(_handleSearchSubCategory);
  }

  final BehaviorSubject<MenuSubCategoryState> _stateSubject = BehaviorSubject();

  Stream<MenuSubCategoryState> get stateStream => _stateSubject.stream;

  List<SubCategory>? allSubCategories = [];
  List<Category>? allCategory = [];
  List<String>? indexBarData = [];

  void emitState(MenuSubCategoryState state) => _stateSubject.sink.add(state);

  @override
  Future<void> close() {
    _stateSubject.close();
    return super.close();
  }

  void _handleInitialLoadingData(
    InitialLoadingDataEvent event,
    Emitter<MenuSubCategoryState> emit,
  ) async {
    try {
      allSubCategories = [];
      indexBarData = [];
      allCategory = [];
      emit(MenuSubCategoryLoadingState());

      allSubCategories = await RestaurantRepository().getSubcategories() ?? [];
      allCategory = await RestaurantRepository().getCategories() ?? [];

      if (allSubCategories == null || allSubCategories!.isEmpty) {
        indexBarData = [];
      } else {
        indexBarData = allSubCategories
            ?.map((subCategory) => subCategory.name?[0] ?? '')
            .toSet()
            .toList();
        // Sort indexBarData alphabetically
        mergeSort(indexBarData!);
      }

      await Future.delayed(
        Duration(seconds: 3),
      );
      emit(MenuSubCategoryLoadedState(
          subCategories: allSubCategories ?? [],
          indexBarData: indexBarData ?? [],
          isSearchActive: false,
          allCategory: allCategory ?? []));
      //
      // emit(MenuSubCategoryLoadedState(
      //     subCategories: [],
      //     indexBarData: [],
      //     isSearchActive: false,
      //     allCategory: []));
    } catch (e) {
      emit(MenuSubCategoryErrorState('An error occurred: $e'));
    }
  }

  void _handleEditSubCategory(
    EditSubCategoryEvent event,
    Emitter<MenuSubCategoryState> emit,
  ) async {
    try {
      allSubCategories!
          .firstWhere(
              (subCategory) => subCategory.id == event.editedSubCategory.id)
          .name = event.editedSubCategory.name;
      var currentState = state as MenuSubCategoryLoadedState;
      bool? isSearchActive = currentState.isSearchActive;
      emit(MenuSubCategoryLoadedState(
          subCategories: allSubCategories ?? [],
          indexBarData: indexBarData ?? [],
          isSearchActive: isSearchActive,
          allCategory: allCategory ?? []));
    } catch (e) {
      emit(MenuSubCategoryErrorState('Failed to edit sub-category: $e'));
    }
  }

  void _handleDeleteSubCategory(
    DeleteSubCategoryEvent event,
    Emitter<MenuSubCategoryState> emit,
  ) async {
    try {
      var currentState = state as MenuSubCategoryLoadedState;
      bool? isSearchActive = currentState.isSearchActive;

      allSubCategories!.removeWhere(
          (subCategory) => subCategory.id == event.deletedSubCategory.id);

      indexBarData = allSubCategories!
          .map((subCategory) => subCategory.name![0])
          .toSet()
          .toList();
      // Sort indexBarData alphabetically
      mergeSort(indexBarData!);

      emit(MenuSubCategoryLoadedState(
          subCategories: allSubCategories ?? [],
          indexBarData: indexBarData ?? [],
          isSearchActive: isSearchActive,
          allCategory: allCategory ?? []));
    } catch (e) {
      emit(MenuSubCategoryErrorState('Failed to delete sub-category: $e'));
    }
  }

  void _handleSearchSubCategory(
    SearchSubCategoryEvent event,
    Emitter<MenuSubCategoryState> emit,
  ) async {
    if (event.query == null || event.query!.isEmpty) {
      emit(MenuSubCategoryLoadedState(
          subCategories: allSubCategories ?? [],
          indexBarData: indexBarData ?? [],
          isSearchActive: false,
          allCategory: allCategory ?? []));
    } else {
      final List<SubCategory> searchResult = allSubCategories!
          .where((subCategory) => subCategory.name!
              .toLowerCase()
              .contains(event.query!.toLowerCase()))
          .toList();

      if (searchResult.isEmpty) {
        indexBarData = [];
      } else {
        indexBarData = searchResult
            .map((subCategory) => subCategory.name![0].toUpperCase())
            .toSet()
            .toList();
        // Sort indexBarData alphabetically
        mergeSort(indexBarData!);
      }

      emit(MenuSubCategoryLoadedState(
          subCategories: searchResult ?? [],
          indexBarData: indexBarData ?? [],
          isSearchActive: true,
          allCategory: allCategory));
    }
  }
}
