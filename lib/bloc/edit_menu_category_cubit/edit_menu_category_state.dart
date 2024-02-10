part of 'edit_menu_category_cubit.dart';

class EditMenuCategoryState extends Equatable {
  final List<String?>? subCategoryList;

  const EditMenuCategoryState({required this.subCategoryList});

  factory EditMenuCategoryState.initial() =>
      EditMenuCategoryState(subCategoryList: []);

  @override
  // TODO: implement props
  List<Object?> get props => [subCategoryList];
}
