part of 'edit_menu_category_cubit.dart';


abstract class EditMenuCategoryState extends Equatable {
  final String categoryName;
  final List<String> subCategories;

  EditMenuCategoryState(this.categoryName, this.subCategories);

  @override
  List<Object?> get props => [categoryName, subCategories];
}

class EditMenuCategoryInitial extends EditMenuCategoryState {
  EditMenuCategoryInitial() : super('', []);
}

class EditMenuCategoryUpdated extends EditMenuCategoryState {
  EditMenuCategoryUpdated(String categoryName, List<String> subCategories)
      : super(categoryName, subCategories);
}