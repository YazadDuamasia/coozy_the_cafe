part of 'recipes_bookmark_list_cubit.dart';

sealed class RecipesBookmarkListState extends Equatable {
  const RecipesBookmarkListState();
}

final class RecipesBookmarkListInitialState extends RecipesBookmarkListState {
  @override
  List<Object> get props => [];
}

class RecipesBookmarkListLoadingState extends RecipesBookmarkListState {
  @override
  List<Object> get props => [];
}

class RecipesBookmarkListLoadedState extends RecipesBookmarkListState {
  final  List<RecipeModel>? data;

  const RecipesBookmarkListLoadedState({this.data});

  @override
  List<Object> get props => [data!];
}

class RecipesBookmarkListErrorState extends RecipesBookmarkListState {
  final String? errorMessage;

  const RecipesBookmarkListErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage!];
}

class RecipesBookmarkListNoInternetState extends RecipesBookmarkListState {
  @override
  List<Object> get props => [];
}
