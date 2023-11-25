part of 'category_form_bloc.dart';

abstract class CategoryFormEvent extends Equatable {
  const CategoryFormEvent();
}

class LoadSubcategoriesEvent extends CategoryFormEvent {
  @override
  List<Object?> get props => [];
}

class AddNewSubcategoryEvent extends CategoryFormEvent {
  @override
  List<Object?> get props => [];
}

class UpdateCategoryControllerEvent extends CategoryFormEvent {
  final String value;

  const UpdateCategoryControllerEvent(this.value);

  @override
  List<Object?> get props => [value];
}

class UpdateSelectedSubcategoryEvent extends CategoryFormEvent {
  int index;
  String? value;

  UpdateSelectedSubcategoryEvent(this.index, this.value);

  @override
  List<Object?> get props => [index, value];
}

class RemoveSubcategoryEvent extends CategoryFormEvent {
  final int index;

  RemoveSubcategoryEvent(this.index);

  @override
  List<Object?> get props => [index];
}


class SubmitFormEvent extends CategoryFormEvent {
  final BuildContext context;
  final GlobalKey<FormState> formKey;

  const SubmitFormEvent(this.context, this.formKey);

  @override
  List<Object?> get props => [context, formKey];
}