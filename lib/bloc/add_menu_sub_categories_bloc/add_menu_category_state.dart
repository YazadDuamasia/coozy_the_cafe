part of 'add_menu_categories_cubit.dart';

abstract class AddMenuCategoryState extends Equatable {
  const AddMenuCategoryState();

  @override
  List<Object?> get props => [];
}

class AddMenuCategoryInitial extends AddMenuCategoryState {}

class AddMenuCategoryUpdated extends AddMenuCategoryState {
  final String categoryName;
  final List<String> subCategoryList;

  const AddMenuCategoryUpdated({
    required this.categoryName,
    required this.subCategoryList,
  });

  @override
  List<Object?> get props => [categoryName, subCategoryList];
}
