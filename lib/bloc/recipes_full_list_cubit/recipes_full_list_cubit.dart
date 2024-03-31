import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:coozy_cafe/model/recipe_model.dart';
import 'package:coozy_cafe/repositories/components/restaurant_repository.dart';
import 'package:coozy_cafe/utlis/utlis.dart';
import 'package:coozy_cafe/widgets/fliter_system_widget/filter_system.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'recipes_full_list_state.dart';

class RecipesFullListCubit extends Cubit<RecipesFullListState> {
  RecipesFullListCubit() : super(RecipesInitialState());

  final BehaviorSubject<RecipesFullListState> _stateSubject = BehaviorSubject();

  Stream<RecipesFullListState> get stateStream => _stateSubject.stream;
  List<int> itemsPerPageList = [10, 20, 40, 80, 100, 150];

  List<RecipeModel>? recipeList = [];
  List<int?>? uniqueServings = [];
  List<FilterItemModel>? servingsFilterOptionsList = [];
  List<String>? uniqueCuisine = [];
  List<FilterItemModel>? cuisineFilterOptionsList = [];

  List<String>? uniqueCourse = [];
  List<FilterItemModel>? courseFilterOptionsList = [];

  List<String>? uniqueDiet = [];
  List<FilterItemModel>? dietFilterOptionsList = [];
  List<AppliedFilterModel>? appliedFilterList = [];

  Future<void> loadData() async {
    try {
      // Simulate loading data
      emit(RecipesLoadingState());

      uniqueServings = [];
      servingsFilterOptionsList = [];
      uniqueCuisine = [];
      cuisineFilterOptionsList = [];
      uniqueCourse = [];
      courseFilterOptionsList = [];
      uniqueDiet = [];
      dietFilterOptionsList = [];
      // Replace this with your actual data loading logic
      List<RecipeModel>? data = await RestaurantRepository().recipeList();
      recipeList = data;
      if (data == null || data.isEmpty) {
        await Future.delayed(Duration(seconds: 2));

        uniqueServings = [];
        servingsFilterOptionsList = [];
        uniqueCuisine = [];
        cuisineFilterOptionsList = [];
        uniqueCourse = [];
        courseFilterOptionsList = [];
        uniqueDiet = [];
        dietFilterOptionsList = [];

        emit(
          RecipesLoadedState(
            list: [],
            paginatedData: [],
            expansionTileKeys: [],
            expandedTitleControllerList: [],
            currentPage: 1,
            itemsPerPage: itemsPerPageList.first,
            totalElements: 0,
            totalPages: 0,
            startIndex: 0,
            endIndex: 0,
            itemsPerPageList: itemsPerPageList,
          ),
        );
      } else {
        data.forEach((recipe) {
          // Extract unique values for each attribute and add them to the respective lists
          if (!uniqueServings!.contains(recipe.recipeServings)) {
            uniqueServings!.add(recipe.recipeServings);
          }
          if (!uniqueCuisine!.contains(recipe.recipeCuisine)) {
            uniqueCuisine!.add(recipe.recipeCuisine ?? "");
          }
          if (!uniqueCourse!.contains(recipe.recipeCourse)) {
            uniqueCourse!.add(recipe.recipeCourse ?? "");
          }
          if (!uniqueDiet!.contains(recipe.recipeDiet)) {
            uniqueDiet!.add(recipe.recipeDiet ?? "");
          }
        });

        // Merge sort uniqueServings list
        mergeSort(
          uniqueServings!,
          compare: (a, b) {
            if (a == null || b == null) {
              return 0; // Handle null values if necessary
            }
            return a.compareTo(b);
          },
        );
        // Merge sort uniqueCuisine list
        uniqueCuisine!.sort((a, b) => a![0].compareTo(b![0]));
        // Merge sort uniqueCourse list
        uniqueCourse!.sort((a, b) => a![0].compareTo(b![0]));
        // Merge sort uniqueDiet list
        uniqueDiet!.sort((a, b) => a![0].compareTo(b![0]));

        uniqueServings?.forEach((int? serving) {
          if (serving != null) {
            servingsFilterOptionsList!.add(FilterItemModel(
              filterTitle: serving.toString(),
              filterKey: serving,
            ));
          }
        });
        uniqueCuisine?.forEach((String? cuisine) {
          if (cuisine != null) {
            cuisineFilterOptionsList!.add(FilterItemModel(
              filterTitle: cuisine.toString(),
              filterKey: cuisine,
            ));
          }
        });

        uniqueCourse?.forEach((String? course) {
          if (course != null) {
            courseFilterOptionsList!.add(FilterItemModel(
              filterTitle: course.toString(),
              filterKey: course,
            ));
          }
        });

        uniqueDiet?.forEach((String? diet) {
          if (diet != null) {
            dietFilterOptionsList!.add(FilterItemModel(
              filterTitle: diet.toString(),
              filterKey: diet,
            ));
          }
        });

        Constants.debugLog(RecipesFullListCubit,
            "loadData:uniqueServings:${uniqueServings?.length ?? 0}");
        Constants.debugLog(RecipesFullListCubit,
            "loadData:uniqueServings:${json.encode(uniqueServings)}");

        Constants.debugLog(RecipesFullListCubit,
            "loadData:uniqueCuisine:${uniqueCuisine?.length ?? 0}");
        Constants.debugLog(RecipesFullListCubit,
            "loadData:uniqueCuisine:${json.encode(uniqueCuisine)}");

        Constants.debugLog(RecipesFullListCubit,
            "loadData:uniqueCourse:${uniqueCourse?.length ?? 0}");
        Constants.debugLog(RecipesFullListCubit,
            "loadData:uniqueCourse:${json.encode(uniqueCourse)}");

        Constants.debugLog(RecipesFullListCubit,
            "loadData:uniqueDiet:${uniqueDiet?.length ?? 0}");
        Constants.debugLog(RecipesFullListCubit,
            "loadData:uniqueDiet:${json.encode(uniqueDiet)}");

        List<GlobalKey?>? expansionTileKeys =
            List.generate(data.length, (index) => new GlobalKey());

        List<ExpansionTileController>? expandedTitleControllerList =
            List.generate(
                data.length, (index) => new ExpansionTileController());

        int startIndex = 0;

        // Calculate the ending index
        int endIndex = itemsPerPageList.first;

        // Ensure endIndex doesn't exceed the total number of elements
        endIndex =
            endIndex > (data.length ?? 0) ? (data.length ?? 0) : endIndex;

        // Get the paginated data based on the calculated indices
        List<RecipeModel>? paginatedData = data.sublist(startIndex, endIndex);

        await Future.delayed(Duration(seconds: 2));
        emit(RecipesLoadedState(
            list: data??[],
            paginatedData: paginatedData??[],
            startIndex: startIndex,
            endIndex: endIndex,
            currentPage: 1,
            itemsPerPage: itemsPerPageList.first,
            totalElements: data.length ?? 0,
            totalPages: (data.length ?? 0) ~/ itemsPerPageList.first,
            expansionTileKeys: expansionTileKeys,
            itemsPerPageList: itemsPerPageList,
            expandedTitleControllerList: expandedTitleControllerList??[]));
      }
      //   emit(NoInternetState());
    } catch (e) {
      Constants.debugLog(RecipesFullListCubit, "loadData:error:$e");
      emit(RecipesErrorState('An error occurred: $e'));
    }
  }

  Future<void> updatePageItems({int? itemsPerPage}) async {
    try {
      RecipesLoadedState recipesLoadedState = state as RecipesLoadedState;
      // Replace this with your actual data loading logic
      if (recipesLoadedState.list == null || recipesLoadedState.list!.isEmpty) {
        await Future.delayed(Duration(seconds: 2));
        emit(RecipesLoadedState(
            list: [],
            paginatedData: [],
            expansionTileKeys: [],
            expandedTitleControllerList: [],
            currentPage: 1,
            itemsPerPage: itemsPerPage!,
            totalElements: 0,
            totalPages: 0,
            startIndex: 0,
            endIndex: 0,
            itemsPerPageList: itemsPerPageList));
      } else {
/*        List<GlobalKey?>? expansionTileKeys =
            List.generate(itemsPerPage.length, (index) => GlobalKey());

        List<ExpansionTileController>? expandedTitleControllerList =
            List.generate(data.length, (index) => ExpansionTileController());*/

        int startIndex = 0;

        // Calculate the ending index
        int endIndex = itemsPerPage!;

        // Ensure endIndex doesn't exceed the total number of elements
        endIndex = endIndex > (recipesLoadedState.list?.length ?? 0)
            ? (recipesLoadedState.list?.length ?? 0)
            : endIndex;

        // Get the paginated data based on the calculated indices
        List<RecipeModel>? paginatedData =
            recipesLoadedState.list?.sublist(startIndex, endIndex);
        await Future.delayed(Duration(seconds: 2));
        emit(RecipesLoadedState(
            list: recipesLoadedState.list??[],
            paginatedData: paginatedData??[],
            currentPage: 1,
            startIndex: startIndex,
            endIndex: endIndex,
            itemsPerPage: itemsPerPage,
            totalElements: recipesLoadedState.list?.length ?? 0,
            totalPages: (recipesLoadedState.list?.length ?? 0) ~/ itemsPerPage,
            expansionTileKeys: recipesLoadedState.expansionTileKeys,
            itemsPerPageList: itemsPerPageList,
            expandedTitleControllerList:
                recipesLoadedState.expandedTitleControllerList));
      }
      //   emit(NoInternetState());
    } catch (e) {
      Constants.debugLog(RecipesFullListCubit, "updatePageItems:error:$e");
      emit(RecipesErrorState('An error occurred: $e'));
    }
  }

  Future<void> pullToRefresh({int? itemsPerPage}) async {
    try {
      RecipesLoadedState recipesLoadedState = state as RecipesLoadedState;
      // Replace this with your actual data loading logic
      if (recipesLoadedState.list == null || recipesLoadedState.list!.isEmpty) {
        await Future.delayed(Duration(seconds: 2));
        emit(RecipesLoadedState(
            list: [],
            paginatedData: [],
            expansionTileKeys: [],
            expandedTitleControllerList: [],
            currentPage: 1,
            itemsPerPage: itemsPerPage!,
            totalElements: 0,
            totalPages: 0,
            startIndex: 0,
            endIndex: 0,
            itemsPerPageList: itemsPerPageList));
      } else {
/*        List<GlobalKey?>? expansionTileKeys =
            List.generate(itemsPerPage.length, (index) => GlobalKey());

        List<ExpansionTileController>? expandedTitleControllerList =
            List.generate(data.length, (index) => ExpansionTileController());*/

        int startIndex = 0;

        // Calculate the ending index
        int endIndex = itemsPerPage!;

        // Ensure endIndex doesn't exceed the total number of elements
        endIndex = endIndex > (recipesLoadedState.list?.length ?? 0)
            ? (recipesLoadedState.list?.length ?? 0)
            : endIndex;

        // Get the paginated data based on the calculated indices
        List<RecipeModel>? paginatedData =
            recipesLoadedState.list?.sublist(startIndex, endIndex);
        await Future.delayed(Duration(seconds: 2));
        emit(RecipesLoadedState(
            list: recipesLoadedState.list??[],
            paginatedData: paginatedData??[],
            currentPage: 1,
            startIndex: startIndex,
            endIndex: endIndex,
            itemsPerPage: itemsPerPage,
            totalElements: recipesLoadedState.list?.length ?? 0,
            totalPages: (recipesLoadedState.list?.length ?? 0) ~/ itemsPerPage,
            expansionTileKeys: recipesLoadedState.expansionTileKeys,
            itemsPerPageList: itemsPerPageList,
            expandedTitleControllerList:
                recipesLoadedState.expandedTitleControllerList??[]));
      }
      //   emit(NoInternetState());
    } catch (e) {
      Constants.debugLog(RecipesFullListCubit, "pullToRefresh:error:$e");
      emit(RecipesErrorState('An error occurred: $e'));
    }
  }

  @override
  Future<void> close() {
    _stateSubject.close();
    return super.close();
  }

  Future<void> updatePageNumber(int nextPage) async {
    try {
      RecipesLoadedState recipesLoadedState = state as RecipesLoadedState;

      emit(RecipesLoadingState());
      // Replace this with your actual data loading logic
      if (recipesLoadedState.list == null || recipesLoadedState.list!.isEmpty) {
        await Future.delayed(Duration(seconds: 2));
        emit(RecipesLoadedState(
            list: [],
            paginatedData: [],
            expansionTileKeys: [],
            expandedTitleControllerList: [],
            currentPage: 1,
            itemsPerPage: recipesLoadedState.itemsPerPage,
            totalElements: 0,
            totalPages: 0,
            startIndex: 0,
            endIndex: 0,
            itemsPerPageList: itemsPerPageList));
      } else {
        // Calculate the new start index based on the next page
        int startIndex = (nextPage - 1) * recipesLoadedState.itemsPerPage;

        // Calculate the new end index
        int endIndex = startIndex + recipesLoadedState.itemsPerPage;

        // Ensure endIndex doesn't exceed the total number of elements
        endIndex = endIndex > (recipesLoadedState.list?.length ?? 0)
            ? (recipesLoadedState.list?.length ?? 0)
            : endIndex;

        // Get the paginated data based on the calculated indices
        List<RecipeModel>? paginatedData =
            recipesLoadedState.list?.sublist(startIndex, endIndex);
        await Future.delayed(Duration(seconds: 2));
        emit(RecipesLoadedState(
            list: recipesLoadedState.list??[],
            paginatedData: paginatedData??[],
            currentPage: nextPage,
            startIndex: startIndex,
            endIndex: endIndex,
            itemsPerPage: recipesLoadedState.itemsPerPage,
            totalElements: recipesLoadedState.list?.length ?? 0,
            totalPages: (recipesLoadedState.list?.length ?? 0) ~/
                recipesLoadedState.itemsPerPage,
            expansionTileKeys: recipesLoadedState.expansionTileKeys,
            itemsPerPageList: itemsPerPageList,
            expandedTitleControllerList:
                recipesLoadedState.expandedTitleControllerList??[]));
      }
      //   emit(NoInternetState());
    } catch (e) {
      Constants.debugLog(RecipesFullListCubit, "updatePageNumber:error:$e");
      emit(RecipesErrorState('An error occurred: $e'));
    }
  }

  Future<void> applyFilter({required List<AppliedFilterModel>? fliter}) async {
    try {
      appliedFilterList = fliter;
      RecipesLoadedState recipesLoadedState = state as RecipesLoadedState;

      // Apply filters to the recipe list
      List<RecipeModel>? filteredRecipes = recipeList;
      if (appliedFilterList != null && appliedFilterList!.isNotEmpty) {
        filteredRecipes = _applyFilters(appliedFilterList!, recipeList);
      }
      Constants.debugLog(RecipesFullListCubit, "applyFilter:filteredRecipes:Length${filteredRecipes?.length??0}");
      // Constants.debugLog(RecipesFullListCubit, "applyFilter:filteredRecipes:${json.encode(filteredRecipes)}");


      if (filteredRecipes == null || filteredRecipes.isEmpty) {
        await Future.delayed(Duration(seconds: 2));
        emit(RecipesLoadedState(
          list: [],
          paginatedData: [],
          expansionTileKeys: [],
          expandedTitleControllerList: [],
          currentPage: 1,
          itemsPerPage: itemsPerPageList.first,
          totalElements: 0,
          totalPages: 0,
          startIndex: 0,
          endIndex: 0,
          itemsPerPageList: itemsPerPageList,
        ));
      } else {
        List<GlobalKey?>? expansionTileKeys =
            List.generate(filteredRecipes.length, (index) => new GlobalKey());

        List<ExpansionTileController>? expandedTitleControllerList =
            List.generate(filteredRecipes.length,
                (index) => new ExpansionTileController());

        int startIndex = 0;

        // Calculate the ending index
        int endIndex = recipesLoadedState.itemsPerPage;

        // Ensure endIndex doesn't exceed the total number of elements
        endIndex = endIndex > (filteredRecipes.length ?? 0)
            ? (filteredRecipes.length ?? 0)
            : endIndex;

        // Get the paginated data based on the calculated indices
        List<RecipeModel>? paginatedData =
            filteredRecipes.sublist(startIndex, endIndex);
        Constants.debugLog(RecipesFullListCubit,
            "applyFilter:paginatedData:${json.encode(paginatedData)}");
        await Future.delayed(Duration(seconds: 2));
        emit(RecipesLoadedState(
            list: filteredRecipes ?? [],
            paginatedData: paginatedData ?? [],
            startIndex: startIndex,
            endIndex: endIndex,
            currentPage: 1,
            itemsPerPage: recipesLoadedState.itemsPerPage,
            totalElements: filteredRecipes.length ?? 0,
            totalPages: (filteredRecipes.length ?? 0) ~/
                recipesLoadedState.itemsPerPage,
            expansionTileKeys: expansionTileKeys,
            itemsPerPageList: itemsPerPageList,
            expandedTitleControllerList: expandedTitleControllerList));
      }
    } catch (e) {
      Constants.debugLog(RecipesFullListCubit, "applyFilter:error:$e");
      emit(RecipesErrorState('An error occurred: $e'));
    }
  }

  List<RecipeModel>? _applyFilters(
      List<AppliedFilterModel> filters, List<RecipeModel>? recipes) {
    List<RecipeModel>? filteredRecipes = recipes;

    for (var filter in filters) {
      switch (filter.filterKey) {
        case 'servings':
          if (filter.applied.isNotEmpty) {
            filteredRecipes =
                _filterRecipesByServings(filteredRecipes, filter.applied);
          }
          break;
        case 'cuisine':
          if (filter.applied.isNotEmpty) {
            filteredRecipes =
                _filterRecipesByCuisine(filteredRecipes, filter.applied);
          }
          break;
        case 'course':
          if (filter.applied.isNotEmpty) {
            filteredRecipes =
                _filterRecipesByCourse(filteredRecipes, filter.applied);
          }
          break;
        case 'diet':
          if (filter.applied.isNotEmpty) {
            filteredRecipes =
                _filterRecipesByDiet(filteredRecipes, filter.applied);
          }
          break;
        default:
          break;
      }
    }

    return filteredRecipes;
  }

  List<RecipeModel>? _filterRecipesByServings(
      List<RecipeModel>? recipes, List<FilterItemModel> appliedFilters) {
    return recipes?.where((recipe) {
      return appliedFilters.any(
          (filter) => recipe.recipeServings.toString() == filter.filterTitle);
    }).toList();
  }

  List<RecipeModel>? _filterRecipesByCuisine(
      List<RecipeModel>? recipes, List<FilterItemModel> appliedFilters) {
    return recipes?.where((recipe) {
      return appliedFilters
          .any((filter) => recipe.recipeCuisine == filter.filterTitle);
    }).toList();
  }

  List<RecipeModel>? _filterRecipesByCourse(
      List<RecipeModel>? recipes, List<FilterItemModel> appliedFilters) {
    return recipes?.where((recipe) {
      return appliedFilters
          .any((filter) => recipe.recipeCourse == filter.filterTitle);
    }).toList();
  }

  List<RecipeModel>? _filterRecipesByDiet(
      List<RecipeModel>? recipes, List<FilterItemModel> appliedFilters) {
    return recipes?.where((recipe) {
      return appliedFilters
          .any((filter) => recipe.recipeDiet == filter.filterTitle);
    }).toList();
  }
}
