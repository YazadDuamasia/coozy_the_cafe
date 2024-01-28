part of 'menu_category_full_list_cubit.dart';

abstract class MenuCategoryFullListState extends Equatable {
  const MenuCategoryFullListState();

  @override
  List<Object> get props => [];
}

class InitialState extends MenuCategoryFullListState {}

class LoadingState extends MenuCategoryFullListState {}

class LoadedState extends MenuCategoryFullListState {
  final Map<String, dynamic>? data;
  List<GlobalKey?>? expansionTileKeys;
  List<ExpansionTileController>? expandedTitleControllerList;

  LoadedState(
      {required this.data,
      required this.expansionTileKeys,
      this.expandedTitleControllerList});

  @override
  List<Object> get props => [data!];
}

class ErrorState extends MenuCategoryFullListState {
  final String? errorMessage;

  const ErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage!];
}

class NoInternetState extends MenuCategoryFullListState {}
