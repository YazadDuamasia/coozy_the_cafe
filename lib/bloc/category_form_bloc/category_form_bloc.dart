import 'package:coozy_cafe/model/sub_category.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:coozy_cafe/repositories/components/restaurant_repository.dart';

part 'category_form_event.dart';

part 'category_form_state.dart';

class CategoryFormBloc extends Bloc<CategoryFormEvent, CategoryFormState> {
  final RestaurantRepository _repository = RestaurantRepository();

  CategoryFormBloc()
      : super(InitialCategoryFormState(
          categoryController: TextEditingController(text: ""),
          selectedSubcategories: [],
          subcategoryList: [],
          newSubcategoryControllers: {},
          newSubcategoryErrors: {},
          isSubmitting: false,
        )) {
    on<CategoryFormEvent>((event, emit) {
      on<LoadSubcategoriesEvent>(_onLoadSubcategories);
      on<AddNewSubcategoryEvent>(_onAddNewSubcategory);
      on<UpdateCategoryControllerEvent>(_onUpdateCategoryController);
      on<UpdateSelectedSubcategoryEvent>(_onUpdateSelectedSubcategoryController);
      on<RemoveSubcategoryEvent>(_onRemoveSubcategoryController);

      on<SubmitFormEvent>(_onSubmitForm);
    });
  }

  void _onLoadSubcategories(
      LoadSubcategoriesEvent event, Emitter<CategoryFormState> emit) async {
    // Implement loading subcategories logic here
    try {
      final subcategories = await _repository.getSubcategories();
      final updatedState = (state as InitialCategoryFormState).copyWith(
        subcategories: subcategories,
      );
      emit(updatedState);
    } catch (error) {
      // Handle the error, e.g., show an error message.
    }
  }

  void _onAddNewSubcategory(
      AddNewSubcategoryEvent event, Emitter<CategoryFormState> emit) {
    // Implement adding a new subcategory logic here
    final currentState = state as InitialCategoryFormState;
    final newIndex = currentState.newSubcategoryControllers.length;
    final newSubcategoryControllers =
        Map.from(currentState.newSubcategoryControllers);
    final newSubcategoryErrors = Map.from(currentState.newSubcategoryErrors);

    newSubcategoryControllers[newIndex] = TextEditingController(text: "");
    newSubcategoryErrors[newIndex] = "";

    final updatedState = currentState.copyWith(
      newSubcategoryControllers: newSubcategoryControllers,
      newSubcategoryErrors: newSubcategoryErrors,
    );
    emit(updatedState);
  }

  void _onUpdateCategoryController(
      UpdateCategoryControllerEvent event, Emitter<CategoryFormState> emit) {
    // Implement updating the category controller logic here
    final currentState = state as InitialCategoryFormState;
    final updatedCategoryController = TextEditingController.fromValue(
      TextEditingValue(text: event.value),
    );
    final updatedState = currentState.copyWith(
      categoryController: updatedCategoryController,
    );
    emit(updatedState);
  }

  void _onUpdateSelectedSubcategoryController(
      UpdateSelectedSubcategoryEvent event, Emitter<CategoryFormState> emit) {
    // Implement updating the category controller logic here
    final currentState = state as InitialCategoryFormState;
    var updatedSelectedSubcategories =
        List<String?>.from(currentState.selectedSubcategories);
    updatedSelectedSubcategories[event.index] = event.value;
    final updatedState = currentState.copyWith(
      selectedSubcategories: updatedSelectedSubcategories,
    );
    emit(updatedState);
  }

  void _onRemoveSubcategoryController(RemoveSubcategoryEvent event, Emitter<CategoryFormState> emit) {
    final currentState = state as InitialCategoryFormState;
    final updatedSelectedSubcategories = List<String?>.from(currentState.selectedSubcategories);
    updatedSelectedSubcategories.removeAt(event.index);

    final updatedNewSubcategoryControllers = Map.from(currentState.newSubcategoryControllers);
    updatedNewSubcategoryControllers.remove(event.index);
    final updatedNewSubcategoryErrors = Map.from(currentState.newSubcategoryErrors);
    updatedNewSubcategoryErrors.remove(event.index);

    final updatedState = currentState.copyWith(
      selectedSubcategories: updatedSelectedSubcategories,
      newSubcategoryControllers: updatedNewSubcategoryControllers,
      newSubcategoryErrors: updatedNewSubcategoryErrors,
    );

    emit(updatedState);
  }

  void _onSubmitForm(
      SubmitFormEvent event, Emitter<CategoryFormState> emit) async {
    // Implement form submission logic here
    final currentState = state as InitialCategoryFormState;

    if (event.formKey.currentState!.validate()) {
      bool hasError = false;

      // Check for errors in new subcategory entries.
      for (var entry in currentState.newSubcategoryControllers.entries) {
        final newIndex = entry.key;
        final controller = entry.value;

        if (currentState.selectedSubcategories[newIndex] == 'CreateNew' &&
            controller.text.isEmpty) {
          currentState.newSubcategoryErrors[newIndex] =
              'Please enter a name for the new subcategory.';
          hasError = true;
        } else {
          currentState.newSubcategoryErrors[newIndex] = '';
        }
      }

      if (!hasError) {
        // Proceed with form submission, you can add your logic here.

        // Example: Clear the form fields.
        currentState.categoryController.clear();
        currentState.selectedSubcategories = [];
        currentState.newSubcategoryControllers.clear();
        currentState.newSubcategoryErrors.clear();

        // Notify the UI that the form has been successfully submitted.
        emit(currentState);
      }
    }
  }
}
