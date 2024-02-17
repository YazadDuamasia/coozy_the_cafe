import 'package:coozy_cafe/AppLocalization.dart';
import 'package:coozy_cafe/model/category.dart';
import 'package:coozy_cafe/model/sub_category.dart';
import 'package:coozy_cafe/repositories/components/restaurant_repository.dart';
import 'package:coozy_cafe/utlis/components/constants.dart';
import 'package:coozy_cafe/utlis/components/global.dart';
import 'package:coozy_cafe/utlis/components/string_image_path.dart';
import 'package:coozy_cafe/utlis/components/string_value.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:rxdart/rxdart.dart';

part 'add_menu_category_state.dart';

class AddMenuCategoryCubit extends Cubit<AddMenuCategoryState> {
  FocusNode menuCategoryNameFocusNode = FocusNode();
  TextEditingController menuCategoryNameController =
      TextEditingController(text: "");
  final BehaviorSubject<List<String>?> _subCategoryListController =
      BehaviorSubject<List<String>>.seeded([]);

  AddMenuCategoryCubit() : super(AddMenuCategoryInitial());

  Stream<List<String>?> get subCategoryListStream =>
      _subCategoryListController.stream;

  void addSubCategory(String subCategory) {
    final List<String> currentList = _subCategoryListController.value ?? [];
    currentList.add(subCategory);
    _subCategoryListController.add(currentList);

    // Emit a state to notify the UI about the changes
    emit(AddMenuCategoryUpdated(
        categoryName: menuCategoryNameController.text,
        subCategoryList: currentList));
  }

  void resetData() {
    menuCategoryNameController = TextEditingController(text: "");
    menuCategoryNameFocusNode = FocusNode();
    List<String> currentList = [];
    _subCategoryListController.add(currentList);

    // Emit a state to notify the UI about the changes
    emit(AddMenuCategoryUpdated(
        categoryName: menuCategoryNameController.text,
        subCategoryList: currentList));
  }

  void onChangeSubCategory(String subCategory, int index) {
    final List<String> currentList = _subCategoryListController.value ?? [];
    currentList[index] = subCategory;
    _subCategoryListController.add(currentList);

    emit(AddMenuCategoryUpdated(
        categoryName: menuCategoryNameController.text,
        subCategoryList: currentList));
  }

  void removeSubCategory(int index) {
    final List<String> currentList = _subCategoryListController.value ?? [];
    currentList.removeAt(index);
    _subCategoryListController.add(currentList);

    // Emit a state to notify the UI about the changes
    emit(AddMenuCategoryUpdated(
        categoryName: menuCategoryNameController.text,
        subCategoryList: currentList));
  }

  Future saveCategory(context) async {
    RestaurantRepository repository = RestaurantRepository();
    final Category newCategory = Category(
      name: menuCategoryNameController.text ?? "",
      createdDate: DateTime.now().toUtc().toIso8601String(),
    );
    Constants.debugLog(
        AddMenuCategoryCubit, "newCategory:${newCategory.toJson()}");
    List<String>? subCategoryList = _subCategoryListController.value ?? [];
    Constants.debugLog(AddMenuCategoryCubit, "newSubCategory:$subCategoryList");
    repository.addCategory(newCategory).then((categoryId) async {
      Constants.debugLog(AddMenuCategoryCubit, "categoryId:$categoryId");
      if (categoryId == null) {
        Constants.customAutoDismissAlertDialog(
            classObject: AddMenuCategoryCubit,
            context: context,
            descriptions: AppLocalizations.of(navigatorKey.currentContext!)
                    ?.translate(StringValue
                        .menu_category_added_failed_successfully_text) ??
                "Failed to add new menu category.Please Try again.",
            title: "",
            titleIcon: Lottie.asset(
              StringImagePath.warming_cricle_blink_icon_lottie,
              repeat: false,
            ),
            barrierDismissible: true,
            navigatorKey: navigatorKey);

        return;
      } else {
        if (subCategoryList != null || subCategoryList.isNotEmpty) {
          Category? category =
              await repository.getCategoryBasedOnName(newCategory.name);
          bool errorOccurred = false; // Flag to track if an error occurred
          var errorIndex = -1; // Flag to track if an error occurred
          if (category != null) {
            for (int i = 0; i < subCategoryList.length; i++) {
              if (subCategoryList[i].isNotEmpty) {
                SubCategory subCategory = SubCategory(
                  name: subCategoryList[i],
                  createdDate: DateTime.now().toUtc().toIso8601String(),
                  categoryId: category.id,
                );
                int subcategoryId =
                    await repository.createSubcategory(subCategory);
                if (subcategoryId > 0) {
                  // Subcategory added successfully
                  Constants.debugLog(AddMenuCategoryCubit,
                      "${subCategory.name} Subcategory added successfully from $i position with ID: $subcategoryId");
                } else {
                  // Failed to add subcategory, handle the error
                  Constants.debugLog(
                      AddMenuCategoryCubit, "Failed to add subcategory");
                  errorOccurred = true; // Set the flag to true
                  errorIndex = i;
                  break; // Exit the loop on the first error
                }
              }
            }
          }
          if (errorOccurred) {
            Constants.debugLog(AddMenuCategoryCubit,
                "Error occurred during creation of $errorIndex subcategory .");
            Constants.customAutoDismissAlertDialog(
                classObject: AddMenuCategoryCubit,
                barrierDismissible: true,
                context: context,
                descriptions: AppLocalizations.of(navigatorKey.currentContext!)
                        ?.translate(StringValue
                            .menu_sub_category_new_added_failed_successfully_text) ??
                    "Error occurred during subcategory creation.",
                title: "",
                titleIcon: Lottie.asset(
                  StringImagePath.warming_cricle_blink_icon_lottie,
                  repeat: false,
                ),
                navigatorKey: navigatorKey);
            return;
          }
        }
        Navigator.pop(context);
        Constants.customAutoDismissAlertDialog(
            classObject: AddMenuCategoryCubit,
            barrierDismissible: true,
            context: navigatorKey.currentContext!,
            descriptions: AppLocalizations.of(navigatorKey.currentContext!)
                    ?.translate(
                        StringValue.menu_category_added_successfully_text) ??
                "New Menu Category has been added successfully.",
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
    });
  }
  
}
