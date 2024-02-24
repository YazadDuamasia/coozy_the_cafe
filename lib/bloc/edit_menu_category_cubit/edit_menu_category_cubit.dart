import 'package:coozy_cafe/model/category.dart';
import 'package:coozy_cafe/model/sub_category.dart';
import 'package:coozy_cafe/repositories/components/restaurant_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Define states for your Cubit
abstract class EditMenuCategoryState {}

class EditMenuCategoryInitial extends EditMenuCategoryState {}

class EditMenuCategoryLoading extends EditMenuCategoryState {}

class EditMenuCategoryError extends EditMenuCategoryState {
  final String errorMessage;

  EditMenuCategoryError(this.errorMessage);
}

class EditMenuCategoryLoaded extends EditMenuCategoryState {
  final Category? category;
  final List<SubCategory>? subCategories;

  EditMenuCategoryLoaded(this.category, this.subCategories);
}

// Define events for your Cubit
abstract class EditMenuCategoryEvent {}

class LoadEditMenuCategoryEvent extends EditMenuCategoryEvent {
  final String categoryId;

  LoadEditMenuCategoryEvent(this.categoryId);
}

class EditMenuCategoryCubit extends Cubit<EditMenuCategoryState> {
  EditMenuCategoryCubit() : super(EditMenuCategoryInitial());

  // Implement the logic to emit states based on events
  void loadCategory(categoryId) async {
    emit(EditMenuCategoryLoading());
    try {
      Category? category = await RestaurantRepository()
          .getCategoryBasedOnCategoryId(categoryId: categoryId);
      List<SubCategory>? subCategories = await RestaurantRepository()
          .getSubcategoryBaseCategoryId(id: categoryId!);

      emit(EditMenuCategoryLoaded(category, subCategories));
    } catch (e) {
      emit(EditMenuCategoryError("Failed to load category: $e"));
    }
  }
}
