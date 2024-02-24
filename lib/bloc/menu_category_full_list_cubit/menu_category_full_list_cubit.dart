import 'package:coozy_cafe/model/category.dart';
import 'package:coozy_cafe/model/sub_category.dart';
import 'package:coozy_cafe/repositories/components/restaurant_repository.dart';
import 'package:coozy_cafe/utlis/components/constants.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'menu_category_full_list_state.dart';

class MenuCategoryFullListCubit extends Cubit<MenuCategoryFullListState> {
  MenuCategoryFullListCubit() : super(InitialState());

  final BehaviorSubject<MenuCategoryFullListState> _stateSubject =
      BehaviorSubject();

  Stream<MenuCategoryFullListState> get stateStream => _stateSubject.stream;

  Future<void> loadData() async {
    try {
      // Simulate loading data
      emit(LoadingState());

      // Replace this with your actual data loading logic
      Map<String, dynamic>? data = await fetchDataFromApi();
      if (data == null || data.isEmpty) {
        emit(LoadedState(
            data: null,
            expansionTileKeys: null,
            expandedTitleControllerList: null));
      } else {
        List<GlobalKey?>? expansionTileKeys = List.generate(
            data == null ? 0 : data['categories'].length ?? 0,
            (index) => GlobalKey());
        List<ExpansionTileController>? expandedTitleControllerList =
            List.generate(data == null ? 0 : data['categories'].length ?? 0,
                (index) => ExpansionTileController());

        emit(LoadedState(
            data: data,
            expansionTileKeys: expansionTileKeys,
            expandedTitleControllerList: expandedTitleControllerList));
      }
      //   emit(NoInternetState());
    } catch (e) {
      emit(ErrorState('An error occurred: $e'));
    }
  }

  Future<Map<String, dynamic>?> fetchDataFromApi() async {
    try {
      List<Category>? categoryList = await RestaurantRepository().getCategories();
      List<SubCategory>? subCategoryList =
          await RestaurantRepository().getSubcategories();

      var result = {
        "categories": categoryList?.map((category) {
              List<Map<String, dynamic>> subCategories = subCategoryList
                      ?.where((subCategory) =>
                          subCategory.categoryId == category.id)
                      .map((subCategory) => subCategory.toJson())
                      .toList() ??
                  [];
              return {
                "id": category.id!,
                "name": category.name!,
                "createdDate": category.createdDate,
                "subCategories": subCategories,
              };
            }).toList() ??
            [],
      };

      return result;
    } catch (e) {
      Constants.debugLog(
          MenuCategoryFullListCubit, "fetchDataFromApi:catchError:$e");
      return null;
    }
  }

  @override
  Future<void> close() {
    _stateSubject.close();
    return super.close();
  }
}
