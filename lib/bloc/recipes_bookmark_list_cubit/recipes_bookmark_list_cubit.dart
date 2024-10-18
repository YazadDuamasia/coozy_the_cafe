import 'package:coozy_the_cafe/model/recipe_model.dart';
import 'package:coozy_the_cafe/repositories/repositories.dart';
import 'package:coozy_the_cafe/utlis/utlis.dart';
import 'package:coozy_the_cafe/app_extension/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:lottie/lottie.dart';
import 'package:rxdart/rxdart.dart';

part 'recipes_bookmark_list_state.dart';

class RecipesBookmarkListCubit extends Cubit<RecipesBookmarkListState> {
  RecipesBookmarkListCubit() : super(RecipesBookmarkListInitialState());

  final BehaviorSubject<RecipesBookmarkListState> _stateSubject =
      BehaviorSubject<RecipesBookmarkListState>();

  Stream<RecipesBookmarkListState> get stateStream => _stateSubject.stream;
  List<RecipeModel>? list;

  Future<void> loadData() async {
    try {
      emit(RecipesBookmarkListLoadingState());
      List<RecipeModel>? result = await fetchDataFromApi();
      emit(RecipesBookmarkListLoadedState(data: result));
    } catch (e) {
      emit(RecipesBookmarkListErrorState("${e.toString()}"));
    }
  }

  Future<List<RecipeModel>?> fetchDataFromApi() async {
    return await RestaurantRepository().getBookmarkedRecipes();
  }

  Future<void> addRecipe(RecipeModel recipe) async {
    try {
      emit(RecipesBookmarkListLoadingState());
      list ??= [];
      list!.add(recipe);
      emit(RecipesBookmarkListLoadedState(data: list));
    } catch (e) {
      emit(RecipesBookmarkListErrorState("${e.toString()}"));
    }
  }

  Future<void> updateRecipe(RecipeModel updatedRecipe) async {
    try {
      emit(RecipesBookmarkListLoadingState());

      var res = await RestaurantRepository().updateRecipe(updatedRecipe);
      Constants.debugLog(RecipesBookmarkListCubit, "updateBookmark:res:$res ");
      List<RecipeModel>? result = await fetchDataFromApi();
      list = result;
      emit(RecipesBookmarkListLoadedState(data: result));
    } catch (e) {
      emit(RecipesBookmarkListErrorState("${e.toString()}"));
    }
  }

  Future<void> deleteRecipe(
      {required var recipeId, required BuildContext? context}) async {
    try {
      emit(RecipesBookmarkListLoadingState());
      if (list != null) {
        var result = await RestaurantRepository().deleteRecipe(recipeId);
        if (result != null && result > 0) {
          list!.removeWhere((recipe) => recipe.id == recipeId);
          emit(RecipesBookmarkListLoadedState(data: list));
        } else {
          Constants.customPopUpDialogMessage(
            classObject: RecipesBookmarkListCubit,
            context: context,
            actions: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        context!.pop();
                      },
                      child: Text("Okay"),
                    ),
                  ),
                ],
              ),
            ),
            descriptions: "Fail to delete select item.Please try again.",
            title: "Something when wrong!",
            titleIcon: Lottie.asset(
              StringImagePath.red_circled_white_cross_error_lottie,
              fit: BoxFit.fill,
                repeat: false
            ),
          );
        }
      }
    } catch (e) {
      emit(RecipesBookmarkListErrorState("${e.toString()}"));
    }
  }

  @override
  Future<void> close() {
    _stateSubject.close();
    return super.close();
  }
}
