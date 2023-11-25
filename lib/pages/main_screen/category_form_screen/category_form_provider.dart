import 'package:coozy_cafe/model/sub_category.dart';
import 'package:coozy_cafe/repositories/components/restaurant_repository.dart';
import 'package:flutter/material.dart';

class CategoryFormProvider extends ChangeNotifier {
  final RestaurantRepository _repository = RestaurantRepository();

  TextEditingController categoryController = TextEditingController(text: "");
  List<String?> selectedSubcategories = [];
  List<Subcategory?> subcategories = [];
  Map<int, TextEditingController> newSubcategoryControllers = {};
  Map<int, String> newSubcategoryErrors = {};
  bool isSubmitting = false;

  void loadSubcategories() async {
    subcategories = await _repository.getSubcategories();
    if (subcategories != null && subcategories.isNotEmpty) {
      selectedSubcategories = List.filled(subcategories.length, null);
      newSubcategoryControllers = {};
      newSubcategoryErrors = {};
    }
    notifyListeners();
  }

  void addNewSubcategory() {
    final newIndex = newSubcategoryControllers.length;
    newSubcategoryControllers[newIndex] = TextEditingController(text: "");
    newSubcategoryErrors[newIndex] = "";
    notifyListeners();
  }

  Future<void> submitForm(
      BuildContext context,var formKey) async {
    isSubmitting = true;
    notifyListeners();

    if (formKey.currentState!.validate()) {
      bool hasError = false;

      for (var entry in newSubcategoryControllers.entries) {
        final newIndex = entry.key;
        final controller = entry.value;

        if (selectedSubcategories[newIndex] == 'CreateNew' &&
            controller.text.isEmpty) {
          newSubcategoryErrors[newIndex] =
              'Please enter a name for the new subcategory.';
          hasError = true;
        } else {
          newSubcategoryErrors[newIndex] = '';
        }
      }

      if (!hasError) {
        // Proceed with form submission
        // Add your code to save the category and subcategories

        // After successful submission, you can clear the form or navigate to another screen.
        categoryController.clear();
        selectedSubcategories = [];
        newSubcategoryControllers.clear();
        newSubcategoryErrors.clear();

        // Example: Navigator.of(context).pushReplacementNamed('/success');
      }
    }

    isSubmitting = false;
    notifyListeners();
  }
}
