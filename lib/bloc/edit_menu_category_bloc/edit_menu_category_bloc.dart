import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:coozy_cafe/AppLocalization.dart';
import 'package:coozy_cafe/model/category.dart';
import 'package:coozy_cafe/model/sub_category.dart';
import 'package:coozy_cafe/repositories/repositories.dart';
import 'package:coozy_cafe/utlis/utlis.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rxdart/rxdart.dart';

part 'edit_menu_category_event.dart';

part 'edit_menu_category_state.dart';

class EditMenuCategoryBloc
    extends Bloc<EditMenuCategoryEvent, EditMenuCategoryState> {
  final BehaviorSubject<EditMenuCategoryState> _stateSubject =
      BehaviorSubject();

  Stream<EditMenuCategoryState> get stateStream => _stateSubject.stream;

  void emitState(EditMenuCategoryState state) => _stateSubject.sink.add(state);

  EditMenuCategoryBloc() : super(EditMenuCategoryInitial()) {
    on<LoadEditMenuCategoryDataEvent>(_handleInitialLoadingData);
    // on<UpdateEditMenuCategoryEvent>(_handleUpdateEditMenuCategoryData);
    on<onAddNewSubCategoryEditMenuCategoryEvent>(
        _handleOnAddNewSubCategoryData);
    on<UpdateSubCategoryEditMenuCategoryEvent>(_handleUpdateSubCategoryData);
    on<DeleteSubCategoryEditMenuEvent>(_handleDeleteSubCategoryData);
    on<SubmitSubCategoryEditMenuEvent>(_handleSubmitSubCategoryData);
  }

  Category? initialCategory;
  List<SubCategory>? initialSubCategories = [];
  List<TextEditingController>? listController = [];

  @override
  Future<void> close() {
    _stateSubject.close();
    return super.close();
  }

  Future<void> _handleInitialLoadingData(LoadEditMenuCategoryDataEvent event,
      Emitter<EditMenuCategoryState> emit) async {
    initialCategory = null;
    initialSubCategories = [];
    listController = [];
    emit(EditMenuCategoryLoadingState());

    Category? category;
    List<SubCategory>? subCategories = [];
    try {
      category = await RestaurantRepository()
          .getCategoryBasedOnCategoryId(categoryId: event.categoryId);
    } catch (error) {
      Constants.debugLog(
          EditMenuCategoryBloc, "_handleInitialLoadingData:category:$error");
      emit(EditMenuCategoryErrorState("$error"));
      return;
    }

    try {
      subCategories = await RestaurantRepository()
          .getSubcategoryBaseCategoryId(id: event.categoryId);
    } catch (error1) {
      Constants.debugLog(EditMenuCategoryBloc,
          "_handleInitialLoadingData:subCategories:$error1");
      emit(EditMenuCategoryErrorState("$error1"));
      return;
    }
    initialCategory = category;
    initialSubCategories = subCategories;

    // Clear the existing lists
    listController = [];

    // Initialize the currentList and related controllers and focus nodes
    if (initialSubCategories != null && initialSubCategories!.isNotEmpty) {
      for (int i = 0; i < initialSubCategories!.length; i++) {
        SubCategory subCategory = initialSubCategories![i];
        listController!.add(TextEditingController(text: subCategory.name));
        // listFocusNode.add(new FocusNode());
      }
    }
    emit(EditMenuCategoryLoadedState(
        initialCategory: initialCategory,
        initialSubCategories: initialSubCategories,
        listController: listController));
  }

  Future<void> _handleOnAddNewSubCategoryData(
      onAddNewSubCategoryEditMenuCategoryEvent event,
      Emitter<EditMenuCategoryState> emit) async {
    listController!.add(TextEditingController());

    emit(EditMenuCategoryLoadedState(
        initialCategory: initialCategory,
        initialSubCategories: initialSubCategories,
        listController: listController));
  }

  Future<void> _handleDeleteSubCategoryData(
      DeleteSubCategoryEditMenuEvent event,
      Emitter<EditMenuCategoryState> emit) async {
    listController![event.index].clear();
    listController![event.index].dispose();
    listController!.removeAt(event.index);

    emit(EditMenuCategoryLoadedState(
        initialCategory: initialCategory,
        initialSubCategories: initialSubCategories,
        listController: listController));
  }

  Future<void> _handleUpdateSubCategoryData(
      UpdateSubCategoryEditMenuCategoryEvent event,
      Emitter<EditMenuCategoryState> emit) async {}

  Future<void> _handleSubmitSubCategoryData(
      SubmitSubCategoryEditMenuEvent event,
      Emitter<EditMenuCategoryState> emit) async {
    String? categoryName = event.categoryName;
    Constants.debugLog(EditMenuCategoryBloc,
        "_handleSubmitSubCategoryData:categoryName:$categoryName");
    List<String?>? list =
        listController!.map((controller) => controller.text).toList();
    Constants.debugLog(EditMenuCategoryBloc,
        "_handleSubmitSubCategoryData:SubCategory:${listController!.isEmpty ? null : json.encode(list)}");

    Category category = Category(
      id: initialCategory!.id,
      name: categoryName,
      isActive: initialCategory!.isActive,
      createdDate: DateTime.now().toUtc().toIso8601String(),
    );

    Constants.debugLog(EditMenuCategoryBloc,
        "_handleSubmitSubCategoryData:initialCategory:${category.toJson()}");

    try {
      var resCategory = await RestaurantRepository().updateCategory(category);
      Constants.debugLog(EditMenuCategoryBloc,
          "_handleSubmitSubCategoryData:updateCategory:res:$resCategory");
    } catch (error) {
      Constants.debugLog(EditMenuCategoryBloc,
          "_handleSubmitSubCategoryData:updateCategory:Error:${error}");
      Constants.showToastMsg(
        msg: AppLocalizations.of(event.context)?.translate(
                StringValue.edit_menu_category_failed_to_update_category_msg) ??
            "Failed to update the category record! Please try again.",
      );
      return;
    }

    try {
      var resDelete = await RestaurantRepository()
          .deleteAllSubcategoryBasedOnCategoryId(
              categoryId: initialCategory!.id);
      Constants.debugLog(EditMenuCategoryBloc, "onSubmit:resDelete:$resDelete");

      if (list != null && list.isNotEmpty) {
        var res = await RestaurantRepository().insertSubCategoriesForCategoryId(
            categoryId: initialCategory!.id, subCategoriesList: list);
        Constants.debugLog(
            EditMenuCategoryBloc, "_handleSubmitSubCategoryData:res:$res");
      }
    } catch (subcategoryError) {
      Constants.debugLog(EditMenuCategoryBloc,
          "_handleSubmitSubCategoryData:updateSubcategory:Error:${subcategoryError.toString()}");
      Constants.showToastMsg(
          msg: AppLocalizations.of(event.context)?.translate(StringValue
                  .edit_menu_category_failed_to_update_sub_category_msg) ??
              "Failed to update the sub-category record! Please try again.");
      return;
    }
    Navigator.pop(event.context);

    Constants.customAutoDismissAlertDialog(
        classObject: EditMenuCategoryBloc,
        barrierDismissible: true,
        context: navigatorKey.currentContext!,
        descriptions: AppLocalizations.of(navigatorKey.currentContext!)
                ?.translate(
                    StringValue.menu_category_updated_successfully_text) ??
            "The selected menu category has been updated successfully.",
        title: "",
        titleIcon: Lottie.asset(
          MediaQuery.of(navigatorKey.currentContext!).platformBrightness ==
                  Brightness.light
              ? StringImagePath.done_light_brown_color_lottie
              : StringImagePath.done_brown_color_lottie,
          repeat: false,
        ),
        navigatorKey: navigatorKey);
  }
}
