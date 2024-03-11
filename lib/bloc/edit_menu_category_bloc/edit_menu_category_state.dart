part of 'edit_menu_category_bloc.dart';

abstract class EditMenuCategoryState extends Equatable {
  const EditMenuCategoryState();

  @override
  List<Object> get props => [];
}

class EditMenuCategoryInitial extends EditMenuCategoryState {}

class EditMenuCategoryLoadingState extends EditMenuCategoryState {}

class EditMenuCategoryLoadedState extends EditMenuCategoryState {
  Category? initialCategory;
  List<SubCategory>? initialSubCategories;
  List<TextEditingController>? listController;

  EditMenuCategoryLoadedState(
      {required this.initialCategory,
      required this.initialSubCategories,
      required this.listController});

  @override
  List<Object> get props =>
      [initialCategory!, initialSubCategories!, listController!];
}

class EditMenuCategoryErrorState extends EditMenuCategoryState {
  final String? errorMessage;

  const EditMenuCategoryErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage!];
}

class EditMenuCategoryNoInternetState extends EditMenuCategoryState {
  final String? errorMessage;

  const EditMenuCategoryNoInternetState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage!];
}
