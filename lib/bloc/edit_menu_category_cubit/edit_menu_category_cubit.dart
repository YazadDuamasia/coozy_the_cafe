import 'package:coozy_cafe/model/category.dart';
import 'package:coozy_cafe/model/sub_category.dart';
import 'package:coozy_cafe/utlis/components/constants.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'edit_menu_category_state.dart';

class EditMenuCategoryCubit extends Cubit<EditMenuCategoryState> {
  Category? initialCategory;
  List<SubCategory>? initialSubCategories;

  FocusNode menuCategoryNameFocusNode = FocusNode();
  TextEditingController menuCategoryNameController =
      TextEditingController(text: "");

  final BehaviorSubject<List<String>?> _subCategoryListController =
      BehaviorSubject<List<String>>.seeded([]);

  Stream<List<String>?> get subCategoryListStream =>
      _subCategoryListController.stream;

  EditMenuCategoryCubit() : super(InitialEditMenuCategoryState());

  void initialLoadData(
      Category? initialCategory, List<SubCategory>? initialSubCategories) {
    try {
      emit(LoadingEditMenuCategoryState());

      menuCategoryNameController = TextEditingController(text: "");
      menuCategoryNameFocusNode = FocusNode();

      if (initialCategory != null &&
          initialCategory.name != null &&
          initialCategory.name != "" &&
          initialCategory.name!.isNotEmpty) {
        menuCategoryNameController.text = initialCategory.name ?? "";
      } else {
        menuCategoryNameController.text = "";
      }
      List<String> currentList = [];

      if (initialSubCategories != null) {
        for (var subCategory in initialSubCategories!) {
          currentList.add(subCategory.name ?? "");
        }
      }
      _subCategoryListController.add(currentList);

      emit(LoadedEditMenuCategoryState(
          categoryName: menuCategoryNameController.text,
          subCategoryList: currentList));


    } catch (e) {
      Constants.debugLog(EditMenuCategoryCubit, "initialLoadData:Error:$e");
      emit(ErrorEditMenuCategoryState(e.toString()));
    }
  }

  void addSubCategory(String subCategory) {
    final List<String> currentList = _subCategoryListController.value ?? [];
    currentList.add(subCategory);
    _subCategoryListController.add(currentList);

    // Emit a state to notify the UI about the changes
    emit(LoadedEditMenuCategoryState(
        categoryName: menuCategoryNameController.text,
        subCategoryList: currentList));
  }

  void onChangeSubCategory(String subCategory, int index) {
    final List<String> currentList = _subCategoryListController.value ?? [];
    currentList[index] = subCategory;
    _subCategoryListController.add(currentList);

    emit(LoadedEditMenuCategoryState(
        categoryName: menuCategoryNameController.text,
        subCategoryList: currentList));
  }

  void removeSubCategory(int index) {
    final List<String> currentList = _subCategoryListController.value ?? [];
    currentList.removeAt(index);
    _subCategoryListController.add(currentList);

    // Emit a state to notify the UI about the changes
    emit(LoadedEditMenuCategoryState(
        categoryName: menuCategoryNameController.text,
        subCategoryList: currentList));
  }

  void submit(BuildContext context) async {}
}