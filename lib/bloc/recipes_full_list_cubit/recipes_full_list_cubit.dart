import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:coozy_the_cafe/model/recipe_model.dart';
import 'package:coozy_the_cafe/repositories/components/restaurant_repository.dart';
import 'package:coozy_the_cafe/utlis/utlis.dart';
import 'package:coozy_the_cafe/widgets/fliter_system_widget/filter_system.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'recipes_full_list_state.dart';

class RecipesFullListCubit extends Cubit<RecipesFullListState> {
  RecipesFullListCubit() : super(RecipesInitialState());

  final BehaviorSubject<RecipesFullListState> _stateSubject = BehaviorSubject();

  Stream<RecipesFullListState> get stateStream => _stateSubject.stream;
  List<int> itemsPerPageList = [10, 20, 30, 40, 50,100];

  List<RecipeModel>? recipeList = [];

  List<int?>? uniqueServings = [];
  List<FilterItemModel>? servingsFilterOptionsList = [];

  List<String>? uniqueCuisine = [];
  List<FilterItemModel>? cuisineFilterOptionsList = [];

  List<String>? uniqueCourse = [];
  List<FilterItemModel>? courseFilterOptionsList = [];

  List<String>? uniqueDiet = [];
  List<FilterItemModel>? dietFilterOptionsList = [];

  List<int?>? uniqueCookingTime = [];
  List<FilterItemModel>? cookingTimeFilterOptionsList = [];

  List<int?>? uniqueTotalCookingTime = [];
  List<FilterItemModel>? totalCookingTimeFilterOptionsList = [];

  List<dynamic>? uniqueDate = [];
  List<FilterItemModel>? dateFilterOptionsList = [];

  List<dynamic>? uniqueTime = [];
  List<FilterItemModel>? timeFilterOptionsList = [];


  List<AppliedFilterModel>? appliedFilterList = [];

  int? currentPage;
  int? currentItemsPerPage;

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
      uniqueCookingTime = [];
      cookingTimeFilterOptionsList = [];
      uniqueTotalCookingTime = [];
      totalCookingTimeFilterOptionsList = [];

      uniqueDate = [];
      dateFilterOptionsList = [];

      uniqueTime = [];
      timeFilterOptionsList = [];

      // Replace this with your actual data loading logic
      List<RecipeModel>? data;
      try {
        data = await RestaurantRepository().recipeList();
      } catch (e) {
        print(e);
      }
      recipeList = data;
      if (data == null || data.isEmpty) {
        await Future.delayed(const Duration(milliseconds: 700));

        uniqueServings = [];
        servingsFilterOptionsList = [];
        uniqueCuisine = [];
        cuisineFilterOptionsList = [];
        uniqueCourse = [];
        courseFilterOptionsList = [];
        uniqueDiet = [];
        dietFilterOptionsList = [];
        uniqueCookingTime = [];
        cookingTimeFilterOptionsList = [];
        uniqueTotalCookingTime = [];
        totalCookingTimeFilterOptionsList = [];
        uniqueDate = [];
        dateFilterOptionsList = [];

        uniqueTime = [];
        timeFilterOptionsList = [];

        currentPage = 1;
        currentItemsPerPage = 0;
        emit(
          RecipesLoadedState(
            list: [],
            paginatedData: [],
            currentPage: 1,
            itemsPerPage: itemsPerPageList.first,
            totalElements: 0,
            totalPages: 0,
            startIndex: 0,
            endIndex: 0,
            isInternalLoading: false,
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
          if (!uniqueCookingTime!.contains(recipe.recipeCookingTimeInMins)) {
            uniqueCookingTime!.add(recipe.recipeCookingTimeInMins);
          }
          if (!uniqueTotalCookingTime!.contains(recipe.recipeTotalTimeInMins)) {
            uniqueTotalCookingTime!.add(recipe.recipeTotalTimeInMins);
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
        uniqueCuisine!.sort((a, b) => a[0].compareTo(b[0]));
        // Merge sort uniqueCourse list
        uniqueCourse!.sort((a, b) => a[0].compareTo(b[0]));
        // Merge sort uniqueDiet list
        uniqueDiet!.sort((a, b) => a[0].compareTo(b[0]));
        uniqueCookingTime!.sort((a, b) => a!.compareTo(b!));
        uniqueTotalCookingTime!.sort((a, b) => a!.compareTo(b!));

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
        uniqueCookingTime?.forEach((int? time) {
          if (time != null) {
            cookingTimeFilterOptionsList!.add(FilterItemModel(
              filterTitle: "${time ?? 0} mins",
              filterKey: time,
            ));
          }
        });
        uniqueTotalCookingTime?.forEach((int? time) {
          if (time != null) {
            totalCookingTimeFilterOptionsList!.add(FilterItemModel(
              filterTitle: "${time ?? 0} mins",
              filterKey: time,
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

        // Calculate the total number of pages
        int totalPages = ((data.length ?? 0) / itemsPerPageList.first).ceil();
        int startIndex = 0;

        // Calculate the ending index
        int endIndex = itemsPerPageList.first;

        // Ensure endIndex doesn't exceed the total number of elements
        endIndex =
            endIndex > (data.length ?? 0) ? (data.length ?? 0) : endIndex;

        // Get the paginated data based on the calculated indices
        List<RecipeModel>? paginatedData = data.sublist(startIndex, endIndex);

        currentPage = 1;
        currentItemsPerPage = itemsPerPageList.first;

        await Future.delayed(const Duration(milliseconds: 700));
        emit(RecipesLoadedState(
            list: data ?? [],
            paginatedData: paginatedData ?? [],
            startIndex: startIndex,
            endIndex: endIndex,
            currentPage: 1,
            isInternalLoading: false,
            itemsPerPage: itemsPerPageList.first,
            totalElements: data.length ?? 0,
            totalPages: totalPages,
            itemsPerPageList: itemsPerPageList));
      }
      //   emit(NoInternetState());
    } catch (e) {
      Constants.debugLog(RecipesFullListCubit, "loadData:error:$e");
      emit(RecipesErrorState('An error occurred: $e'));
    }
  }

  Future<void> updatePageItems({int? itemsPerPage}) async {
    try {
      RecipesLoadedState currentState = state as RecipesLoadedState;
      emit(RecipesLoadedState(
        list: currentState.list,
        paginatedData: currentState.paginatedData,
        currentPage: currentState.currentPage,
        itemsPerPage: itemsPerPage,
        totalPages: currentState.totalPages,
        totalElements: currentState.totalElements,
        itemsPerPageList: currentState.itemsPerPageList,
        startIndex: currentState.startIndex,
        endIndex: currentState.endIndex,
        isInternalLoading: true,
      ));

      RecipesLoadedState recipesLoadedState = state as RecipesLoadedState;

      if (recipesLoadedState.list == null || recipesLoadedState.list!.isEmpty) {
        await Future.delayed(const Duration(milliseconds: 700));
        currentPage = 1;
        currentItemsPerPage = itemsPerPage;
        emit(RecipesLoadedState(
            list: [],
            paginatedData: [],
            currentPage: 1,
            itemsPerPage: itemsPerPage!,
            totalElements: 0,
            totalPages: 0,
            startIndex: 0,
            endIndex: 0,
            isInternalLoading: false,
            itemsPerPageList: itemsPerPageList));
      } else {
        // Calculate the total number of pages
        int totalPages =
            (recipesLoadedState.list!.length / itemsPerPage!).ceil();

        currentPage = 1;
        currentItemsPerPage = itemsPerPage;
        int startIndex = 0;

        // Calculate the ending index
        int endIndex = itemsPerPage!;

        // Ensure endIndex doesn't exceed the total number of elements
        endIndex = endIndex > recipesLoadedState.list!.length
            ? recipesLoadedState.list!.length
            : endIndex;

        // Get the paginated data based on the calculated indices
        List<RecipeModel>? paginatedData =
            recipesLoadedState.list!.sublist(startIndex, endIndex);
        // await Future.delayed(const Duration(milliseconds: 700));

        Constants.debugLog(
            RecipesFullListCubit, "updatePageItems:totalPages:$totalPages");

        Constants.debugLog(RecipesFullListCubit,
            "updatePageItems:list:size:${recipesLoadedState.list?.length ?? 0}");
        emit(RecipesLoadedState(
          list: recipesLoadedState.list ?? [],
          paginatedData: paginatedData ?? [],
          currentPage: 1,
          startIndex: startIndex,
          endIndex: endIndex,
          itemsPerPage: itemsPerPage,
          isInternalLoading: false,
          totalElements: recipesLoadedState.list!.length,
          totalPages: totalPages,
          itemsPerPageList: itemsPerPageList,
        ));
      }
      //   emit(NoInternetState());
    } catch (e) {
      Constants.debugLog(RecipesFullListCubit, "updatePageItems:error:$e");
      emit(RecipesErrorState('An error occurred: $e'));
    }
  }

  Future<void> updateBookmark(
      {int? currentIndex,
      required RecipeModel model,
      BuildContext? context}) async {
    RecipesLoadedState currentState = state as RecipesLoadedState;
    RecipeModel currentModel = model;
    currentModel.isBookmark = !model.isBookmark!;

    Constants.showLoadingDialog(context!);
    try {
      var res = await RestaurantRepository().updateRecipe(currentModel);
      Constants.debugLog(RecipesFullListCubit, "updateBookmark:res:$res ");
      int? index = currentState.list
          ?.indexWhere((element) => element.recipeID == currentModel.recipeID);
      currentState.list![index!] = currentModel;
      currentState.paginatedData![currentIndex!] = currentModel;
    } catch (e) {
      Constants.debugLog(RecipesFullListCubit, "updateBookmark:error:$e");
    }

    Navigator.pop(context);
    emit(RecipesLoadedState(
      list: currentState.list,
      paginatedData: currentState.paginatedData,
      currentPage: currentState.currentPage,
      itemsPerPage: currentState.itemsPerPage,
      totalPages: currentState.totalPages,
      totalElements: currentState.totalElements,
      itemsPerPageList: currentState.itemsPerPageList,
      startIndex: currentState.startIndex,
      endIndex: currentState.endIndex,
      isInternalLoading: false,
    ));
  }

  Future<void> pullToRefresh({int? itemsPerPage}) async {
    try {
      RecipesLoadedState recipesLoadedState = state as RecipesLoadedState;

      emit(RecipesLoadedState(
        list: recipesLoadedState.list,
        paginatedData: recipesLoadedState.paginatedData,
        currentPage: recipesLoadedState.currentPage,
        itemsPerPage: itemsPerPage,
        totalPages: recipesLoadedState.totalPages,
        totalElements: recipesLoadedState.totalElements,
        itemsPerPageList: recipesLoadedState.itemsPerPageList,
        startIndex: recipesLoadedState.startIndex,
        endIndex: recipesLoadedState.endIndex,
        isInternalLoading: true,
      ));

      // Replace this with your actual data loading logic
      if (recipesLoadedState.list == null || recipesLoadedState.list!.isEmpty) {
        await Future.delayed(const Duration(milliseconds: 700));
        currentPage = 1;
        currentItemsPerPage = itemsPerPage;

        emit(RecipesLoadedState(
            list: [],
            paginatedData: [],
            currentPage: 1,
            itemsPerPage: itemsPerPage!,
            totalElements: 0,
            totalPages: 0,
            startIndex: 0,
            endIndex: 0,
            isInternalLoading: false,
            itemsPerPageList: itemsPerPageList));
      } else {
/*        List<GlobalKey?>? expansionTileKeys =
            List.generate(itemsPerPage.length, (index) => GlobalKey());

        List<ExpansionTileController>? expandedTitleControllerList =
            List.generate(data.length, (index) => ExpansionTileController());*/

        int totalPages =
            ((recipesLoadedState.list?.length ?? 0) / itemsPerPage!).ceil();
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
        await Future.delayed(const Duration(milliseconds: 700));
        currentPage = 1;
        currentItemsPerPage = itemsPerPage;
        emit(RecipesLoadedState(
            list: recipesLoadedState.list ?? [],
            paginatedData: paginatedData ?? [],
            currentPage: 1,
            startIndex: startIndex,
            endIndex: endIndex,
            itemsPerPage: itemsPerPage,
            isInternalLoading: false,
            totalElements: recipesLoadedState.list?.length ?? 0,
            totalPages: totalPages,
            itemsPerPageList: itemsPerPageList));
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

      emit(RecipesLoadedState(
        list: recipesLoadedState.list,
        paginatedData: recipesLoadedState.paginatedData,
        currentPage: nextPage,
        itemsPerPage: recipesLoadedState.itemsPerPage,
        totalPages: recipesLoadedState.totalPages,
        totalElements: recipesLoadedState.totalElements,
        itemsPerPageList: recipesLoadedState.itemsPerPageList,
        startIndex: recipesLoadedState.startIndex,
        endIndex: recipesLoadedState.endIndex,
        isInternalLoading: true,
      ));

      // emit(RecipesLoadingState());
      // Replace this with your actual data loading logic
      if (recipesLoadedState.list == null || recipesLoadedState.list!.isEmpty) {
        await Future.delayed(const Duration(milliseconds: 700));
        currentPage = 1;
        currentItemsPerPage = 0;
        emit(RecipesLoadedState(
            list: [],
            paginatedData: [],
            currentPage: 1,
            itemsPerPage: recipesLoadedState.itemsPerPage,
            totalElements: 0,
            totalPages: 0,
            startIndex: 0,
            endIndex: 0,
            isInternalLoading: false,
            itemsPerPageList: itemsPerPageList));
      } else {
        // Calculate the new start index based on the next page
        int totalPages = ((recipesLoadedState.list?.length ?? 0) /
                recipesLoadedState.itemsPerPage!)
            .ceil();
        int startIndex = (nextPage - 1) * recipesLoadedState.itemsPerPage!;

        // Calculate the new end index
        int endIndex = startIndex + recipesLoadedState.itemsPerPage!;

        // Ensure endIndex doesn't exceed the total number of elements
        endIndex = endIndex > (recipesLoadedState.list?.length ?? 0)
            ? (recipesLoadedState.list?.length ?? 0)
            : endIndex;

        // Get the paginated data based on the calculated indices
        List<RecipeModel>? paginatedData =
            recipesLoadedState.list?.sublist(startIndex, endIndex);
        await Future.delayed(const Duration(milliseconds: 700));
        currentPage = nextPage;
        currentItemsPerPage = recipesLoadedState.itemsPerPage;
        emit(RecipesLoadedState(
            list: recipesLoadedState.list ?? [],
            paginatedData: paginatedData ?? [],
            currentPage: nextPage,
            startIndex: startIndex,
            endIndex: endIndex,
            isInternalLoading: false,
            itemsPerPage: recipesLoadedState.itemsPerPage,
            totalElements: recipesLoadedState.list?.length ?? 0,
            totalPages: totalPages,
            itemsPerPageList: itemsPerPageList));
      }
      //   emit(NoInternetState());
    } catch (e) {
      Constants.debugLog(RecipesFullListCubit, "updatePageNumber:error:$e");
      emit(RecipesErrorState('An error occurred: $e'));
    }
  }

  Future<void> searchRecipes(
    String? query,
  ) async {
    if (query == null || query.isEmpty) {
      try {
        emit(RecipesLoadedState(
            list: [],
            paginatedData: [],
            startIndex: 0,
            endIndex: 0,
            currentPage: 1,
            isInternalLoading: true,
            itemsPerPage: itemsPerPageList.first,
            totalElements: 0,
            totalPages: 0,
            itemsPerPageList: itemsPerPageList));
        uniqueServings = [];
        servingsFilterOptionsList = [];
        uniqueCuisine = [];
        cuisineFilterOptionsList = [];
        uniqueCourse = [];
        courseFilterOptionsList = [];
        uniqueDiet = [];
        dietFilterOptionsList = [];
        uniqueCookingTime = [];
        cookingTimeFilterOptionsList = [];
        uniqueTotalCookingTime = [];
        totalCookingTimeFilterOptionsList = [];
        uniqueDate = [];
        dateFilterOptionsList = [];

        uniqueTime = [];
        timeFilterOptionsList = [];
        // Replace this with your actual data loading logic
        List<RecipeModel>? data = await RestaurantRepository().recipeList();
        recipeList = data;
        if (data == null || data.isEmpty) {
          await Future.delayed(const Duration(milliseconds: 700));

          uniqueServings = [];
          servingsFilterOptionsList = [];
          uniqueCuisine = [];
          cuisineFilterOptionsList = [];
          uniqueCourse = [];
          courseFilterOptionsList = [];
          uniqueDiet = [];
          dietFilterOptionsList = [];
          uniqueCookingTime = [];
          cookingTimeFilterOptionsList = [];
          uniqueTotalCookingTime = [];
          totalCookingTimeFilterOptionsList = [];
          uniqueDate = [];
          dateFilterOptionsList = [];

          uniqueTime = [];
          timeFilterOptionsList = [];

          currentPage = 1;
          currentItemsPerPage = 0;
          emit(
            RecipesLoadedState(
              list: [],
              paginatedData: [],
              currentPage: 1,
              itemsPerPage: itemsPerPageList.first,
              totalElements: 0,
              totalPages: 0,
              startIndex: 0,
              endIndex: 0,
              isInternalLoading: false,
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
            if (!uniqueCookingTime!.contains(recipe.recipeCookingTimeInMins)) {
              uniqueCookingTime!.add(recipe.recipeCookingTimeInMins);
            }
            if (!uniqueTotalCookingTime!
                .contains(recipe.recipeTotalTimeInMins)) {
              uniqueTotalCookingTime!.add(recipe.recipeTotalTimeInMins);
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
          uniqueCuisine!.sort((a, b) => a[0].compareTo(b[0]));
          // Merge sort uniqueCourse list
          uniqueCourse!.sort((a, b) => a[0].compareTo(b[0]));
          // Merge sort uniqueDiet list
          uniqueDiet!.sort((a, b) => a[0].compareTo(b[0]));
          uniqueCookingTime!.sort((a, b) => a!.compareTo(b!));
          uniqueTotalCookingTime!.sort((a, b) => a!.compareTo(b!));

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
          uniqueCookingTime?.forEach((int? time) {
            if (time != null) {
              cookingTimeFilterOptionsList!.add(FilterItemModel(
                filterTitle: time.toString(),
                filterKey: time,
              ));
            }
          });
          uniqueTotalCookingTime?.forEach((int? time) {
            if (time != null) {
              totalCookingTimeFilterOptionsList!.add(FilterItemModel(
                filterTitle: time.toString(),
                filterKey: time,
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

          // Calculate the total number of pages
          int totalPages = ((data.length ?? 0) / itemsPerPageList.first).ceil();
          int startIndex = 0;

          // Calculate the ending index
          int endIndex = itemsPerPageList.first;

          // Ensure endIndex doesn't exceed the total number of elements
          endIndex =
              endIndex > (data.length ?? 0) ? (data.length ?? 0) : endIndex;

          // Get the paginated data based on the calculated indices
          List<RecipeModel>? paginatedData = data.sublist(startIndex, endIndex);

          currentPage = 1;
          currentItemsPerPage = itemsPerPageList.first;

          await Future.delayed(const Duration(milliseconds: 700));
          emit(RecipesLoadedState(
              list: data ?? [],
              paginatedData: paginatedData ?? [],
              startIndex: startIndex,
              endIndex: endIndex,
              currentPage: 1,
              isInternalLoading: false,
              itemsPerPage: itemsPerPageList.first,
              totalElements: data.length ?? 0,
              totalPages: totalPages,
              itemsPerPageList: itemsPerPageList));
        }
        //   emit(NoInternetState());
      } catch (e) {
        Constants.debugLog(RecipesFullListCubit, "loadData:error:$e");
        emit(RecipesErrorState('An error occurred: $e'));
      }
    } else {
      try {
        // Simulate loading data

        emit(RecipesLoadedState(
          list: recipeList,
          paginatedData: [],
          currentPage: 1,
          itemsPerPage: itemsPerPageList.first,
          totalElements: 0,
          totalPages: 0,
          startIndex: 0,
          endIndex: 0,
          isInternalLoading: true,
          itemsPerPageList: itemsPerPageList,
        ));

        // Replace this with your actual data loading logic
        List<RecipeModel>? searchResults = await recipeList
            ?.where((recipe) =>
                recipe.recipeName!.toLowerCase().contains(query!.toLowerCase()))
            .toList();

        Constants.debugLog(RecipesFullListCubit,
            "searchRecipes:searchResults:length:${searchResults?.length ?? 0}");
        await Future.delayed(const Duration(
          milliseconds: 700,
        ));

        currentPage = 1;
        currentItemsPerPage = itemsPerPageList.first;

        if (searchResults == null || searchResults.isEmpty) {
          // No results found
          emit(RecipesLoadedState(
            list: [],
            paginatedData: [],
            currentPage: 1,
            itemsPerPage: itemsPerPageList.first,
            totalElements: 0,
            totalPages: 0,
            startIndex: 0,
            endIndex: 0,
            isInternalLoading: false,
            itemsPerPageList: itemsPerPageList,
          ));
        } else {
          // Results found

          int startIndex = 0;

          // Calculate the ending index
          int endIndex = itemsPerPageList.first;

          // Ensure endIndex doesn't exceed the total number of elements
          endIndex = endIndex > (searchResults.length ?? 0)
              ? (searchResults.length ?? 0)
              : endIndex;

          // Get the paginated data based on the calculated indices
          List<RecipeModel>? paginatedData =
              searchResults.sublist(startIndex, endIndex);

          currentPage = 1;
          currentItemsPerPage = itemsPerPageList.first;

          emit(RecipesLoadedState(
              list: searchResults ?? [],
              paginatedData: paginatedData ?? [],
              startIndex: startIndex,
              endIndex: endIndex,
              currentPage: 1,
              isInternalLoading: false,
              itemsPerPage: itemsPerPageList.first,
              totalElements: searchResults.length ?? 0,
              totalPages: (searchResults.length ?? 0) ~/ itemsPerPageList.first,
              itemsPerPageList: itemsPerPageList));
        }
      } catch (e) {
        // Handle errors
        Constants.debugLog(RecipesFullListCubit, "searchRecipes:else:error:$e");
        emit(RecipesErrorState('An error occurred: $e'));
      }
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
      Constants.debugLog(RecipesFullListCubit,
          "applyFilter:filteredRecipes:Length${filteredRecipes?.length ?? 0}");
      // Constants.debugLog(RecipesFullListCubit, "applyFilter:filteredRecipes:${json.encode(filteredRecipes)}");

      if (filteredRecipes == null || filteredRecipes.isEmpty) {
        await Future.delayed(const Duration(milliseconds: 700));
        currentPage = 1;
        currentItemsPerPage = recipesLoadedState.itemsPerPage;
        emit(RecipesLoadedState(
          list: [],
          paginatedData: [],
          currentPage: 1,
          itemsPerPage: recipesLoadedState.itemsPerPage,
          totalElements: 0,
          totalPages: 0,
          startIndex: 0,
          endIndex: 0,
          isInternalLoading: false,
          itemsPerPageList: itemsPerPageList,
        ));
      } else {
        int totalPages =
            ((filteredRecipes.length ?? 0) / recipesLoadedState.itemsPerPage!)
                .ceil();
        int startIndex = 0;

        // Calculate the ending index
        int endIndex = recipesLoadedState.itemsPerPage!;

        // Ensure endIndex doesn't exceed the total number of elements
        endIndex = endIndex > (filteredRecipes.length ?? 0)
            ? (filteredRecipes.length ?? 0)
            : endIndex;

        // Get the paginated data based on the calculated indices
        List<RecipeModel>? paginatedData =
            filteredRecipes.sublist(startIndex, endIndex);
        Constants.debugLog(RecipesFullListCubit,
            "applyFilter:paginatedData:${json.encode(paginatedData)}");
        await Future.delayed(const Duration(milliseconds: 700));
        emit(RecipesLoadedState(
            list: filteredRecipes ?? [],
            paginatedData: paginatedData ?? [],
            startIndex: startIndex,
            endIndex: endIndex,
            currentPage: 1,
            isInternalLoading: false,
            itemsPerPage: recipesLoadedState.itemsPerPage,
            totalElements: filteredRecipes.length ?? 0,
            totalPages: totalPages,
            itemsPerPageList: itemsPerPageList));
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
        case 'cooking_time':
          if (filter.applied.isNotEmpty) {
            filteredRecipes =
                _filterRecipesByCookingTime(filteredRecipes, filter.applied);
          }
          break;

        default:
          break;
      }
    }

    if (filteredRecipes != null) {
      filteredRecipes = filteredRecipes.toSet().toList();
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

  List<RecipeModel>? _filterRecipesByCookingTime(
      List<RecipeModel>? recipes, List<FilterItemModel> appliedFilters) {
    return recipes?.where((recipe) {
      return appliedFilters.any((filter) =>
          (recipe.recipeCookingTimeInMins ?? 0) <=
          (int.tryParse("${filter.filterTitle}") ?? 0));
    }).toList();
  }

  List<RecipeModel>? _filterRecipesByCookingTotalTime(
      List<RecipeModel>? recipes, List<FilterItemModel> appliedFilters) {
    return recipes?.where((recipe) {
      return appliedFilters.any((filter) =>
          (recipe.recipeTotalTimeInMins ?? 0) <=
          (int.tryParse("${filter.filterTitle}") ?? 0));
    }).toList();
  }
}
