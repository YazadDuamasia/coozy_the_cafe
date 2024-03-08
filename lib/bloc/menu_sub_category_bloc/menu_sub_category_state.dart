part of 'menu_sub_category_bloc.dart';

abstract class MenuSubCategoryState extends Equatable {
  const MenuSubCategoryState();

  @override
  List<Object> get props => [];
}

class MenuSubCategoryInitialState extends MenuSubCategoryState {}

class MenuSubCategoryLoadingState extends MenuSubCategoryState {}

class MenuSubCategoryLoadedState extends MenuSubCategoryState {
  final List<SubCategory>? subCategories;
  final List<Category>? allCategory;
  final List<String>? indexBarData;
  final bool? isSearchActive;

  const MenuSubCategoryLoadedState(
      {this.subCategories,
      this.indexBarData,
      this.isSearchActive,
      this.allCategory});

  @override
  List<Object> get props =>
      [subCategories!, allCategory!, indexBarData!, isSearchActive!];
}

class MenuSubCategoryErrorState extends MenuSubCategoryState {
  final String? errorMessage;

  const MenuSubCategoryErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage!];
}