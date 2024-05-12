/*
This code defines the FilterState class and implements
 the Equatable interface
*/


part of 'filter_cubit.dart';

class FilterState extends Equatable {
  final List<FilterListModel> filters;
  final int activeFilterIndex;
  FilterType? type;

  FilterState({
    required this.filters,
    this.type,
    required this.activeFilterIndex,
  });

  FilterState.init({
    required this.filters,
    this.type,
    required this.activeFilterIndex,
  });

  FilterState copyWith({
    List<FilterListModel>? filters,
    int? activeFilterIndex,
    FilterType? type,
  }) {
    return FilterState(
      activeFilterIndex: activeFilterIndex ?? this.activeFilterIndex,
      filters: filters ?? this.filters,
      type: type ?? this.type,
    );
  }

  @override
  List<Object?> get props => [filters, activeFilterIndex, type];
}
