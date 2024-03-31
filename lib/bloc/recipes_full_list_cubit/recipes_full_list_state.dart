part of 'recipes_full_list_cubit.dart';

abstract class RecipesFullListState extends Equatable {
  const RecipesFullListState();

  @override
  List<Object> get props => [];
}

class RecipesInitialState extends RecipesFullListState {}

class RecipesLoadingState extends RecipesFullListState {}

class RecipesLoadedState extends RecipesFullListState {
  final List<RecipeModel>? list;
  final List<RecipeModel>? paginatedData;

  List<GlobalKey?>? expansionTileKeys;
  List<ExpansionTileController>? expandedTitleControllerList;
  int currentPage;
  int itemsPerPage;
  int totalPages;
  int totalElements;
  List<int>? itemsPerPageList;
  int startIndex;
  int endIndex;

  RecipesLoadedState({
    required this.list,
    required this.paginatedData,
    required this.currentPage,
    required this.itemsPerPage,
    required this.totalPages,
    required this.totalElements,
    required this.expansionTileKeys,
    required this.itemsPerPageList,
    required this.startIndex,
    required this.endIndex,
    this.expandedTitleControllerList,
  });

  @override
  List<Object> get props => [
        paginatedData!,
        list!,
        expansionTileKeys!,
        expandedTitleControllerList!,
        itemsPerPageList!,
        currentPage,
        itemsPerPage,
        totalPages,
        totalElements,
        startIndex,
        endIndex
      ];
}

class RecipesErrorState extends RecipesFullListState {
  final String? errorMessage;

  const RecipesErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage!];
}

class NoInternetRecipesState extends RecipesFullListState {}
