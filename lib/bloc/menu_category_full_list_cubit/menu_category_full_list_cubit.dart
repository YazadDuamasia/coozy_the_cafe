import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:coozy_the_cafe/AppLocalization.dart';
import 'package:coozy_the_cafe/model/category.dart';
import 'package:coozy_the_cafe/model/sub_category.dart';
import 'package:coozy_the_cafe/repositories/components/restaurant_repository.dart';
import 'package:coozy_the_cafe/utlis/components/constants.dart';
import 'package:coozy_the_cafe/utlis/components/string_value.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'menu_category_full_list_state.dart';

class MenuCategoryFullListCubit extends Cubit<MenuCategoryFullListState> {
  MenuCategoryFullListCubit() : super(MenuCategoryFullListInitialState());

  final BehaviorSubject<MenuCategoryFullListState> _stateSubject =
      BehaviorSubject();

  Stream<MenuCategoryFullListState> get stateStream => _stateSubject.stream;

  List<Category>? categoryList;
  List<SubCategory>? subCategoryList;
  List<GlobalKey?>? expansionTileKeys;
  List<ExpansionTileController>? expandedTitleControllerList;

  Future<void> loadData() async {
    try {
      // Simulate loading data
      emit(MenuCategoryFullListLoadingState());

      // Replace this with your actual data loading logic
      Map<String, dynamic>? data = await fetchDataFromApi();
      if (data == null || data.isEmpty) {
        expansionTileKeys = [];
        expandedTitleControllerList = [];
        emit(MenuCategoryFullListLoadedState(
            data: null,
            expansionTileKeys: null,
            expandedTitleControllerList: null));
      } else {
        expansionTileKeys = List.generate(
            data == null ? 0 : data['categories'].length ?? 0,
            (index) => GlobalKey());

        expandedTitleControllerList = List.generate(
            data == null ? 0 : data['categories'].length ?? 0,
            (index) => ExpansionTileController());

        emit(MenuCategoryFullListLoadedState(
            data: data,
            expansionTileKeys: expansionTileKeys,
            expandedTitleControllerList: expandedTitleControllerList));
      }
      //   emit(NoInternetState());
    } catch (e) {
      emit(MenuCategoryFullListErrorState('An error occurred: $e'));
    }
  }

  Future<void> deletecategory({int? categoryId, Category? category}) async {
    try {
      await RestaurantRepository()
          .delete_complete_record_category(categoryId!, category);
      // Replace this with your actual data loading logic
      Map<String, dynamic>? data = await fetchDataFromApi();
      if (data == null || data.isEmpty) {
        expansionTileKeys = [];
        expandedTitleControllerList = [];
        emit(MenuCategoryFullListLoadedState(
            data: null,
            expansionTileKeys: null,
            expandedTitleControllerList: null));
      } else {
        expansionTileKeys = List.generate(
            data == null ? 0 : data['categories'].length ?? 0,
            (index) => GlobalKey());
        expandedTitleControllerList = List.generate(
            data == null ? 0 : data['categories'].length ?? 0,
            (index) => ExpansionTileController());

        emit(MenuCategoryFullListLoadedState(
            data: data,
            expansionTileKeys: expansionTileKeys,
            expandedTitleControllerList: expandedTitleControllerList));
      }
      //   emit(NoInternetState());
    } catch (e) {
      emit(MenuCategoryFullListErrorState('An error occurred: $e'));
    }
  }

  Future<Map<String, dynamic>?> fetchDataFromApi() async {
    try {

      categoryList = await RestaurantRepository().getCategories() ?? [];
      subCategoryList = await RestaurantRepository().getSubcategories() ?? [];

      var result = {
        "categories": categoryList?.map((category) {
              List<Map<String, dynamic>> subCategories = subCategoryList
                      ?.where((subCategory) =>
                          subCategory.categoryId == category.id)
                      .map((subCategory) => subCategory.toJson())
                      .toList() ??
                  [];
              return {
                "id": category.id!,
                "name": category.name!,
                "isActive": category.isActive!,
                "createdDate": category.createdDate,
                "position": category.position,
                "subCategories": subCategories,
              };
            }).toList() ??
            [],
      };

      Constants.debugLog(MenuCategoryFullListCubit,
          "fetchDataFromApi:output:${result.toString()}");

      return result;
    } catch (e) {
      Constants.debugLog(
          MenuCategoryFullListCubit, "fetchDataFromApi:catchError:$e");
      return null;
    }
  }

  Future<void> handleIsEnableCategory(
      BuildContext context, Category category, bool isEnable) async {
    try {
      Constants.debugLog(MenuCategoryFullListCubit,
          "handleIsEnableCategory:initialCategory:${category.toJson()}");

      try {
        category.isActive = isEnable == false ? 0 : 1;

        Constants.debugLog(MenuCategoryFullListCubit,
            "handleIsEnableCategory:Category:${category.toJson()}");
        var resCategory = await RestaurantRepository().updateCategory(category);
        Constants.debugLog(MenuCategoryFullListCubit,
            "handleIsEnableCategory:updateCategory:res:$resCategory");

        if (isEnable == false) {
          // Constants.showToastMsg(
          //     msg: AppLocalizations.of(context)?.translate(StringValue
          //             .menu_category_full_list_unable_to_update_category_msg) ??
          //         "Your selected Category has been deactivated, and you will no longer receive orders for it.");

          Flushbar(
            message: AppLocalizations.of(context)?.translate(StringValue
                    .menu_category_full_list_unable_to_update_category_msg) ??
                "Your selected Category has been deactivated, and you will no longer receive orders for it.",
            icon: Icon(
              Icons.info_outline,
              size: 28.0,
              color: Colors.white,
            ),
            margin: EdgeInsets.all(5.0),
            flushbarStyle: FlushbarStyle.FLOATING,
            flushbarPosition: FlushbarPosition.BOTTOM,
            textDirection: Directionality.of(context),
            borderRadius: BorderRadius.circular(12),
            duration: Duration(seconds: 3),
            leftBarIndicatorColor: Theme.of(context).colorScheme.primary,
          )..show(context);
        } else {
          // Constants.showToastMsg(
          //     msg: AppLocalizations.of(context)?.translate(StringValue
          //             .menu_category_full_list_enable_to_update_category_msg) ??
          //         "Your selected Category has been activated, and you are able to accept orders for it.");

          Flushbar(
            message: AppLocalizations.of(context)?.translate(StringValue
                    .menu_category_full_list_enable_to_update_category_msg) ??
                "Your selected Category has been activated, and you are able to accept orders for it.",
            icon: Icon(
              Icons.info_outline,
              size: 28.0,
              color: Colors.white,
            ),
            margin: EdgeInsets.all(5.0),
            flushbarStyle: FlushbarStyle.FLOATING,
            flushbarPosition: FlushbarPosition.BOTTOM,
            textDirection: Directionality.of(context),
            borderRadius: BorderRadius.circular(12),
            duration: Duration(seconds: 3),
            leftBarIndicatorColor: Theme.of(context).colorScheme.primary,
          )..show(context);
        }
      } catch (error) {
        Constants.debugLog(
            MenuCategoryFullListCubit, "handleIsEnableCategory:Error:${error}");

        // Constants.showToastMsg(
        //     msg: AppLocalizations.of(context)?.translate(StringValue
        //             .menu_category_full_list_failed_to_update_category_msg) ??
        //         "Failed to enable your selected category! Please try again.");

        Flushbar(
          message: AppLocalizations.of(context)?.translate(StringValue
                  .menu_category_full_list_failed_to_update_category_msg) ??
              "Failed to enable your selected category! Please try again.",
          icon: Icon(
            Icons.warning,
            size: 28.0,
            color: Colors.white,
          ),
          margin: EdgeInsets.all(5.0),
          flushbarStyle: FlushbarStyle.FLOATING,
          flushbarPosition: FlushbarPosition.BOTTOM,
          textDirection: Directionality.of(context),
          borderRadius: BorderRadius.circular(12),
          duration: Duration(seconds: 3),
          leftBarIndicatorColor: Theme.of(context).colorScheme.primary,
        )..show(context);

        return;
      }

      Map<String, dynamic>? data = await fetchDataFromApi();
      if (data == null || data.isEmpty) {
        expansionTileKeys = [];
        expandedTitleControllerList = [];
        emit(MenuCategoryFullListLoadedState(
            data: null,
            expansionTileKeys: null,
            expandedTitleControllerList: null));
      } else {
        List<GlobalKey?>? expansionTileKeys = List.generate(
            data == null ? 0 : data['categories'].length ?? 0,
            (index) => GlobalKey());
        List<ExpansionTileController>? expandedTitleControllerList =
            List.generate(data == null ? 0 : data['categories'].length ?? 0,
                (index) => ExpansionTileController());

        // emit(LoadedState(
        //     data: data,
        //     expansionTileKeys: expansionTileKeys,
        //     expandedTitleControllerList: expandedTitleControllerList));
        //
        final currentState = state as MenuCategoryFullListLoadedState;

        final newExpansionTileKeys =
            List<GlobalKey?>.from(currentState.expansionTileKeys!);
        final newExpandedTitleControllerList =
            List<ExpansionTileController>.from(
                currentState.expandedTitleControllerList!);
        this.expansionTileKeys = newExpansionTileKeys;
        this.expandedTitleControllerList = newExpandedTitleControllerList;
        emit(MenuCategoryFullListLoadedState(
            data: data,
            expansionTileKeys: newExpansionTileKeys,
            expandedTitleControllerList: newExpandedTitleControllerList));
      }
      //   emit(NoInternetState());
    } catch (e) {
      emit(MenuCategoryFullListErrorState('An error occurred: $e'));
    }
  }

  void handleIsEnableSubCategory(
      BuildContext context, SubCategory subCategory, bool isEnable) async {
    try {
      Constants.debugLog(MenuCategoryFullListCubit,
          "handleIsEnableCategory:initialCategory:${subCategory.toJson()}");

      try {
        subCategory.isActive = isEnable == false ? 0 : 1;

        Constants.debugLog(MenuCategoryFullListCubit,
            "handleIsEnableCategory:Category:${subCategory.toJson()}");
        var resCategory =
            await RestaurantRepository().updateSubcategory(subCategory);
        Constants.debugLog(MenuCategoryFullListCubit,
            "handleIsEnableCategory:updateCategory:res:$resCategory");

        if (isEnable == false) {
          // Constants.showToastMsg(
          //     msg: AppLocalizations.of(context)?.translate(StringValue
          //             .menu_category_full_list_unable_to_update_sub_category_msg) ??
          //         "Your selected sub-category has been deactivated, and you will no longer receive orders for it.");
          Flushbar(
            message: AppLocalizations.of(context)?.translate(StringValue
                    .menu_category_full_list_unable_to_update_sub_category_msg) ??
                "Your selected sub-category has been deactivated, and you will no longer receive orders for it.",
            icon: Icon(
              Icons.info_outline,
              size: 28.0,
              color: Colors.white,
            ),
            margin: EdgeInsets.all(5.0),
            flushbarStyle: FlushbarStyle.FLOATING,
            flushbarPosition: FlushbarPosition.BOTTOM,
            textDirection: Directionality.of(context),
            borderRadius: BorderRadius.circular(12),
            duration: Duration(seconds: 3),
            leftBarIndicatorColor: Theme.of(context).colorScheme.primary,
          )..show(context);
        } else {
          // Constants.showToastMsg(
          //     msg: AppLocalizations.of(context)?.translate(StringValue
          //             .menu_category_full_list_enable_to_update_sub_category_msg) ??
          //         "Your selected sub-category has been activated, and you are able to accept orders for it.");
          Flushbar(
            message: AppLocalizations.of(context)?.translate(StringValue
                    .menu_category_full_list_enable_to_update_sub_category_msg) ??
                "Your selected sub-category has been activated, and you are able to accept orders for it.",
            icon: Icon(
              Icons.info_outline,
              size: 28.0,
              color: Colors.white,
            ),
            margin: EdgeInsets.all(5.0),
            flushbarStyle: FlushbarStyle.FLOATING,
            flushbarPosition: FlushbarPosition.BOTTOM,
            textDirection: Directionality.of(context),
            borderRadius: BorderRadius.circular(12),
            duration: Duration(seconds: 3),
            leftBarIndicatorColor: Theme.of(context).colorScheme.primary,
          )..show(context);
        }
      } catch (error) {
        Constants.debugLog(
            MenuCategoryFullListCubit, "handleIsEnableCategory:Error:${error}");

        // Constants.showToastMsg(
        //     msg: AppLocalizations.of(context)?.translate(StringValue
        //             .menu_category_full_list_failed_to_update_sub_category_msg) ??
        //         "Failed to enable your selected sub-category! Please try again.");
        Flushbar(
          message: AppLocalizations.of(context)?.translate(StringValue
                  .menu_category_full_list_failed_to_update_sub_category_msg) ??
              "Failed to enable your selected sub-category! Please try again.",
          icon: Icon(
            Icons.warning,
            size: 28.0,
            color: Colors.white,
          ),
          margin: EdgeInsets.all(5.0),
          flushbarStyle: FlushbarStyle.FLOATING,
          flushbarPosition: FlushbarPosition.BOTTOM,
          textDirection: Directionality.of(context),
          borderRadius: BorderRadius.circular(12),
          duration: Duration(seconds: 3),
          leftBarIndicatorColor: Theme.of(context).colorScheme.primary,
        )..show(context);
        return;
      }

      Map<String, dynamic>? data = await fetchDataFromApi();
      if (data == null || data.isEmpty) {
        expansionTileKeys = [];
        expandedTitleControllerList = [];
        emit(MenuCategoryFullListLoadedState(
            data: null,
            expansionTileKeys: null,
            expandedTitleControllerList: null));
      } else {
        List<GlobalKey?>? expansionTileKeys = List.generate(
            data == null ? 0 : data['categories'].length ?? 0,
            (index) => GlobalKey());
        List<ExpansionTileController>? expandedTitleControllerList =
            List.generate(data == null ? 0 : data['categories'].length ?? 0,
                (index) => ExpansionTileController());

        final currentState = state as MenuCategoryFullListLoadedState;

        final newExpansionTileKeys =
            List<GlobalKey?>.from(currentState.expansionTileKeys!);
        final newExpandedTitleControllerList =
            List<ExpansionTileController>.from(
                currentState.expandedTitleControllerList!);
        this.expansionTileKeys = newExpansionTileKeys;
        this.expandedTitleControllerList = newExpandedTitleControllerList;
        emit(MenuCategoryFullListLoadedState(
            data: data,
            expansionTileKeys: newExpansionTileKeys,
            expandedTitleControllerList: newExpandedTitleControllerList));
      }
      //   emit(NoInternetState());
    } catch (e) {
      emit(MenuCategoryFullListErrorState('An error occurred: $e'));
    }
  }

  // Move a category up in the list
  Future<void> moveCategoryUp(int index, BuildContext context) async {
    if (index > 0) {
      final temp = categoryList![index];
      // Save original positions before swapping
      final categoryToMoveUp = categoryList![index];
      final categoryToMoveDown = categoryList![index - 1];

      // Swap the categories in the list
      categoryList![index] = categoryToMoveDown;
      categoryList![index - 1] = categoryToMoveUp;

      // Update their positions in the list
      categoryToMoveUp.position = index - 1;
      categoryToMoveDown.position = index;

      // Update categories in the database
      await RestaurantRepository().updateCategory(categoryToMoveUp);
      await RestaurantRepository().updateCategory(categoryToMoveDown);

      Map<String, dynamic>? data = await fetchDataFromApi();
      if (data == null || data.isEmpty) {
        expansionTileKeys = [];
        expandedTitleControllerList = [];
        emit(MenuCategoryFullListLoadedState(
            data: null,
            expansionTileKeys: null,
            expandedTitleControllerList: null));
      } else {
        List<GlobalKey?>? expansionTileKeys = List.generate(
            data == null ? 0 : data['categories'].length ?? 0,
            (index) => GlobalKey());
        List<ExpansionTileController>? expandedTitleControllerList =
            List.generate(data == null ? 0 : data['categories'].length ?? 0,
                (index) => ExpansionTileController());

        final currentState = state as MenuCategoryFullListLoadedState;

        final newExpansionTileKeys =
            List<GlobalKey?>.from(currentState.expansionTileKeys!);
        final newExpandedTitleControllerList =
            List<ExpansionTileController>.from(
                currentState.expandedTitleControllerList!);
        this.expansionTileKeys = newExpansionTileKeys;
        this.expandedTitleControllerList = newExpandedTitleControllerList;
        emit(MenuCategoryFullListLoadedState(
            data: data,
            expansionTileKeys: newExpansionTileKeys,
            expandedTitleControllerList: newExpandedTitleControllerList));
      }
    }
  }

  // Move a category down in the list
  Future<void> moveCategoryDown(int index, BuildContext context) async {

    if (index < categoryList!.length - 1) {
      // Save original positions before swapping
      final categoryToMoveDown = categoryList![index];
      final categoryToMoveUp = categoryList![index + 1];

      // Swap the categories in the list
      categoryList![index] = categoryToMoveUp;
      categoryList![index + 1] = categoryToMoveDown;

      // Update their positions in the list
      categoryToMoveDown.position = index + 1;
      categoryToMoveUp.position = index;

      // Update categories in the database
      await RestaurantRepository().updateCategory(categoryToMoveDown);
      await RestaurantRepository().updateCategory(categoryToMoveUp);

      Map<String, dynamic>? data = await fetchDataFromApi();
      if (data == null || data.isEmpty) {
        expansionTileKeys = [];
        expandedTitleControllerList = [];
        emit(MenuCategoryFullListLoadedState(
            data: null,
            expansionTileKeys: null,
            expandedTitleControllerList: null));
      } else {
        List<GlobalKey?>? expansionTileKeys = List.generate(
            data == null ? 0 : data['categories'].length ?? 0,
            (index) => GlobalKey());
        List<ExpansionTileController>? expandedTitleControllerList =
            List.generate(data == null ? 0 : data['categories'].length ?? 0,
                (index) => ExpansionTileController());

        final currentState = state as MenuCategoryFullListLoadedState;

        final newExpansionTileKeys =
            List<GlobalKey?>.from(currentState.expansionTileKeys!);
        final newExpandedTitleControllerList =
            List<ExpansionTileController>.from(
                currentState.expandedTitleControllerList!);
        this.expansionTileKeys = newExpansionTileKeys;
        this.expandedTitleControllerList = newExpandedTitleControllerList;
        emit(MenuCategoryFullListLoadedState(
            data: data,
            expansionTileKeys: newExpansionTileKeys,
            expandedTitleControllerList: newExpandedTitleControllerList));
      }
    }
  }

  @override
  Future<void> close() {
    _stateSubject.close();
    return super.close();
  }
}
