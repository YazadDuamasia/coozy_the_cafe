import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'edit_menu_category_state.dart';

class EditMenuCategoryCubit extends Cubit<EditMenuCategoryState> {
  final BehaviorSubject<List<String?>?> _subCategoryListController =
      BehaviorSubject<List<String>>();

  EditMenuCategoryCubit() : super(EditMenuCategoryState.initial()) {
    _subCategoryListController.add([]);
  }

  Stream<List<String?>?> get subCategoryListStream =>
      _subCategoryListController.stream;

  void addSubCategory(String subCategory) {
    final List<String?>? currentList = state.subCategoryList;
    currentList?.add(subCategory);
    _subCategoryListController.add(currentList);
  }

  void removeSubCategory(int index) {
    final List<String?>? currentList = state.subCategoryList;
    currentList?.removeAt(index);
    _subCategoryListController.add(currentList);
  }

  @override
  Future<void> close() {
    _subCategoryListController.close();
    return super.close();
  }
}
