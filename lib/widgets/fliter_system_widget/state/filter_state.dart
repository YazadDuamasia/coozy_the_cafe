/*
This code defines the FilterState class and implements
 the Equatable interface
*/

part of 'filter_cubit.dart';

class FilterState extends Equatable {
  final List<FilterListModel> filters;
  final int activeFilterIndex;

  const FilterState({
    required this.filters,
    required this.activeFilterIndex,
  });

  const FilterState.init({
    required this.filters,
    required this.activeFilterIndex,
  });

  FilterState copyWith({
    List<FilterListModel>? filters,
    int? activeFilterIndex,
  }) {
    return FilterState(
      activeFilterIndex: activeFilterIndex ?? this.activeFilterIndex,
      filters: filters ?? this.filters,
    );
  }

  @override
  List<Object?> get props => [
        filters,
        activeFilterIndex,
      ];
}
