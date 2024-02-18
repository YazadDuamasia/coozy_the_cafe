part of 'edit_menu_category_cubit.dart';

abstract class EditMenuCategoryState extends Equatable {
  const EditMenuCategoryState();

  @override
  List<Object?> get props => [];
}

class InitialEditMenuCategoryState extends EditMenuCategoryState {}

class LoadingEditMenuCategoryState extends EditMenuCategoryState {}

class LoadedEditMenuCategoryState extends EditMenuCategoryState {
  final String categoryName;
  final List<String> subCategoryList;

  const LoadedEditMenuCategoryState({
    required this.categoryName,
    required this.subCategoryList,
  });

  @override
  List<Object?> get props => [categoryName, subCategoryList];
}

class ErrorEditMenuCategoryState extends EditMenuCategoryState {
  final String? errorMessage;

  ErrorEditMenuCategoryState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage!];
}

class NoInternetEditMenuCategoryState extends EditMenuCategoryState {}
