import 'dart:async';

import 'package:collection/collection.dart';
import 'package:coozy_the_cafe/AppLocalization.dart';
import 'package:coozy_the_cafe/model/category.dart';
import 'package:coozy_the_cafe/model/sub_category.dart';
import 'package:coozy_the_cafe/repositories/components/restaurant_repository.dart';
import 'package:coozy_the_cafe/utlis/components/constants.dart';
import 'package:coozy_the_cafe/utlis/components/string_value.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/src/widgets/framework.dart';
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
    } catch (e) {
      emit(MenuSubCategoryErrorState('An error occurred: $e'));
    }
  }

  void _handleEditSubCategory(
    EditSubCategoryEvent event,
    Emitter<MenuSubCategoryState> emit,
  ) async {
    var currentState = state as MenuSubCategoryLoadedState;
    bool? isSearchActive = currentState.isSearchActive;
    try {
      int? result = await RestaurantRepository()
          .updateSubcategory(event.editedSubCategory);
      if (result != null && result > 0) {
        Constants.showToastMsg(
            msg: AppLocalizations.of(event.context)?.translate(
                    StringValue.menu_subCategory_update_successfully) ??
                "The selected sub-category has been updated successfully.");

        int? index = allSubCategories!.indexWhere((subCategory) => subCategory.id == event.editedSubCategory.id);
        // Update the element at the found index
        allSubCategories![index] = event.editedSubCategory;

        emit(MenuSubCategoryLoadedState(
            subCategories: allSubCategories ?? [],
            indexBarData: indexBarData ?? [],
            isSearchActive: isSearchActive,
            allCategory: allCategory ?? []));
      } else {
        Constants.showToastMsg(
            msg: AppLocalizations.of(event.context)
                    ?.translate(StringValue.menu_subCategory_update_failed) ??
                "Failed to updated the selected sub-category. Please Try again.");
      }
    } catch (e) {
      Constants.showToastMsg(msg: AppLocalizations.of(event.context)?.translate(StringValue.common_error_msg) ?? "Something when wrong. Please try again.");
      emit(MenuSubCategoryLoadedState(
          subCategories: allSubCategories ?? [],
          indexBarData: indexBarData ?? [],
          isSearchActive: isSearchActive,
          allCategory: allCategory ?? []));
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
