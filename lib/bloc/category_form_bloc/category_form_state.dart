part of 'category_form_bloc.dart';

abstract class CategoryFormState extends Equatable {
  const CategoryFormState();

  @override
  List<Object?> get props => [];
}

class InitialCategoryFormState extends CategoryFormState {
  final TextEditingController categoryController;
  List<String?> selectedSubcategories;
  final List<Subcategory?> subcategoryList;
  final Map<int, TextEditingController> newSubcategoryControllers;
  final Map<int, String> newSubcategoryErrors;
  final bool isSubmitting;

  InitialCategoryFormState({
    required this.categoryController,
    required this.selectedSubcategories,
    required this.subcategoryList,
    required this.newSubcategoryControllers,
    required this.newSubcategoryErrors,
    required this.isSubmitting,
  });

  // Implement the copyWith method to create a new state with updated values.
  InitialCategoryFormState copyWith({
    TextEditingController? categoryController,
    List<String?>? selectedSubcategories,
    List<Subcategory?>? subcategories,
    Map<dynamic, dynamic>? newSubcategoryControllers,
    Map<dynamic, dynamic>? newSubcategoryErrors,
    bool? isSubmitting,
  }) {
    final updatedNewSubcategoryControllers = <int, TextEditingController>{};
    newSubcategoryControllers?.forEach((key, value) {
      if (key is int) {
        updatedNewSubcategoryControllers[key] = value as TextEditingController;
      }
    });

    final updatedNewSubcategoryErrors = <int, String>{};
    newSubcategoryErrors?.forEach((key, value) {
      if (key is int) {
        updatedNewSubcategoryErrors[key] = value as String;
      }
    });

    return InitialCategoryFormState(
      categoryController: categoryController ?? this.categoryController,
      selectedSubcategories: selectedSubcategories ??
          this.selectedSubcategories,
      subcategoryList: subcategories ?? this.subcategoryList,
      newSubcategoryControllers: updatedNewSubcategoryControllers,
      newSubcategoryErrors: updatedNewSubcategoryErrors,
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  @override
  List<Object?> get props => [
        categoryController,
        selectedSubcategories,
        subcategoryList,
        newSubcategoryControllers,
        newSubcategoryErrors,
        isSubmitting,
      ];
}
