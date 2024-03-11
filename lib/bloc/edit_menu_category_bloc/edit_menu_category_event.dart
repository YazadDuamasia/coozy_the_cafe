part of 'edit_menu_category_bloc.dart';

abstract class EditMenuCategoryEvent extends Equatable {
  EditMenuCategoryEvent();

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LoadEditMenuCategoryDataEvent extends EditMenuCategoryEvent {
  var categoryId;

  LoadEditMenuCategoryDataEvent({required this.categoryId});

  @override
  List<Object> get props => [categoryId!];
}

class UpdateEditMenuCategoryEvent extends EditMenuCategoryEvent {
  final String? value;

  UpdateEditMenuCategoryEvent({required this.value});

  @override
  List<Object> get props => [value!];
}

class onAddNewSubCategoryEditMenuCategoryEvent extends EditMenuCategoryEvent {}

class UpdateSubCategoryEditMenuCategoryEvent extends EditMenuCategoryEvent {
  final String? value;
  int index;

  UpdateSubCategoryEditMenuCategoryEvent(
      {required this.value, required this.index});

  @override
  List<Object> get props => [value!, index];
}

class DeleteSubCategoryEditMenuEvent extends EditMenuCategoryEvent {
  int index;

  DeleteSubCategoryEditMenuEvent({required this.index});

  @override
  List<Object> get props => [index!];
}

class SubmitSubCategoryEditMenuEvent extends EditMenuCategoryEvent {
  String? categoryName;
  BuildContext context;

  SubmitSubCategoryEditMenuEvent(
      {required this.categoryName, required this.context});

  @override
  List<Object> get props => [categoryName!, context];
}
