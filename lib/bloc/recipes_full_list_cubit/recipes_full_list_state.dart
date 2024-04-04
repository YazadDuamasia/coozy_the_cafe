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
  int? currentPage;
  int? itemsPerPage;
  int? totalPages;
  int? totalElements;
  List<int>? itemsPerPageList;
  int? startIndex;
  int? endIndex;
  bool? isInternalLoading;

  RecipesLoadedState(
      {this.list,
      this.paginatedData,
      this.currentPage,
      this.itemsPerPage,
      this.totalPages,
      this.totalElements,
      this.itemsPerPageList,
      this.startIndex,
      this.endIndex,
      this.isInternalLoading = false});

  @override
  List<Object> get props => [
        paginatedData!,
        list!,
        itemsPerPageList!,
        currentPage!,
        itemsPerPage!,
        totalPages!,
        totalElements!,
        startIndex!,
        endIndex!
      ];
}

class RecipesErrorState extends RecipesFullListState {
  final String? errorMessage;

  const RecipesErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage!];
}

class NoInternetRecipesState extends RecipesFullListState {}
