import 'package:coozy_cafe/model/category.dart';
import 'package:coozy_cafe/model/sub_category.dart';
import 'package:coozy_cafe/repositories/components/restaurant_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'edit_menu_category_state.dart';

class EditMenuCategoryCubit extends Cubit<EditMenuCategoryState> {
  final Category? initialCategory;
  final List<SubCategory>? initialSubCategories;

  final TextEditingController categoryNameController = TextEditingController();
  final List<TextEditingController> subCategoryControllers = [];

  EditMenuCategoryCubit(
      {required this.initialCategory, required this.initialSubCategories})
      : super(EditMenuCategoryInitial()) {
    categoryNameController.text = initialCategory?.name ?? "";
    if (initialSubCategories != null) {
      for (var subCategory in initialSubCategories!) {
        subCategoryControllers
            .add(TextEditingController(text: subCategory.name));
      }
    }
  }

  void addSubCategory() {
    subCategoryControllers.add(TextEditingController());
    emit(EditMenuCategoryUpdated(categoryNameController.text,
        subCategoryControllers.map((controller) => controller.text).toList()));
  }

  void removeSubCategory(int index) {
    subCategoryControllers.removeAt(index);
    emit(EditMenuCategoryUpdated(categoryNameController.text,
        subCategoryControllers.map((controller) => controller.text).toList()));
  }

  Future<void> saveChanges(BuildContext context) async {
    // Validate and save changes
    if (categoryNameController.text.isNotEmpty &&
        subCategoryControllers.isNotEmpty) {
      // Assuming RestaurantRepository provides necessary methods for updating categories and subcategories
      final RestaurantRepository repository = RestaurantRepository();
      final Category updatedCategory = Category(
        id: initialCategory?.id,
        name: categoryNameController.text,
        createdDate: DateTime.now().toUtc().toIso8601String(),
      );
      await repository.updateCategory(updatedCategory);
      //
      for (int i = 0;
          i < initialSubCategories!.length && i < subCategoryControllers.length;
          i++) {
        final SubCategory updatedSubCategory = SubCategory(
          name: subCategoryControllers[i].text,
          categoryId: initialCategory!.id,
          createdDate: DateTime.now().toUtc().toIso8601String(),
        );
      }

      // Optionally, emit a success state or show a success message
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Changes saved successfully')));
    } else {
      // Emit an error state or show an error message
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill all fields')));
    }
  }

  @override
  Future<void> close() {
    categoryNameController.dispose();
    for (var controller in subCategoryControllers) {
      controller.dispose();
    }
    return super.close();
  }
}
