part of 'menu_category_full_list_cubit.dart';

sealed class MenuCategoryFullListState extends Equatable {
  const MenuCategoryFullListState();
}

class MenuCategoryFullListInitialState extends MenuCategoryFullListState {
  @override
  List<Object> get props => [];
}

class MenuCategoryFullListLoadingState extends MenuCategoryFullListState {
  @override
  List<Object> get props => [];
}

class MenuCategoryFullListLoadedState extends MenuCategoryFullListState {
  final Map<String, dynamic>? data;
  final List<GlobalKey?>? expansionTileKeys;
  final List<ExpansionTileController>? expandedTitleControllerList;

  const MenuCategoryFullListLoadedState(
      {required this.data,
      required this.expansionTileKeys,
      this.expandedTitleControllerList});

  MenuCategoryFullListLoadedState copyWith({
    Map<String, dynamic>? data,
    List<GlobalKey?>? expansionTileKeys,
    List<ExpansionTileController>? expandedTitleControllerList,
  }) {
    return MenuCategoryFullListLoadedState(
      data: data ?? this.data,
      expansionTileKeys: expansionTileKeys ?? this.expansionTileKeys,
      expandedTitleControllerList:
          expandedTitleControllerList ?? this.expandedTitleControllerList,
    );
  }

  @override
  List<Object> get props =>
      [data!, expansionTileKeys!, expandedTitleControllerList!];
}

class MenuCategoryFullListErrorState extends MenuCategoryFullListState {
  final String? errorMessage;

  const MenuCategoryFullListErrorState(this.errorMessage);

  @override
  List<Object> get props => [errorMessage!];
}

class MenuCategoryFullListNoInternetState extends MenuCategoryFullListState {
  @override
  List<Object> get props => [];
}
