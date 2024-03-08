part of 'menu_sub_category_bloc.dart';

abstract class MenuSubCategoryEvent extends Equatable {
  const MenuSubCategoryEvent();

  @override
  List<Object> get props => [];
}

class InitialLoadingDataEvent extends MenuSubCategoryEvent {}

class EditSubCategoryEvent extends MenuSubCategoryEvent {
  final SubCategory editedSubCategory;
  final int? index;

  const EditSubCategoryEvent(this.editedSubCategory, this.index);

  @override
  List<Object> get props => [editedSubCategory, index!];
}

class DeleteSubCategoryEvent extends MenuSubCategoryEvent {
  final SubCategory deletedSubCategory;
  final int? index;

  const DeleteSubCategoryEvent(this.deletedSubCategory, this.index);

  @override
  List<Object> get props => [deletedSubCategory, index!];
}

class SearchSubCategoryEvent extends MenuSubCategoryEvent {
  final String? query;

  const SearchSubCategoryEvent(this.query);

  @override
  List<Object> get props => [query!];
}
