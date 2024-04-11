/*
This code defines the FilterState class and implements
 the Equatable interface
*/

part of 'filter_cubit.dart';

class FilterState extends Equatable {
  final List<FilterListModel> filters;
  final int activeFilterIndex;
  FilterType? type;
  double? sliderValues;
  RangeValues? rangeSliderValues;

  FilterState({
    required this.filters,
    this.type,
    this.sliderValues,
    this.rangeSliderValues,
    required this.activeFilterIndex,
  });

  FilterState.init({
    required this.filters,
    this.type,
    this.sliderValues,
    this.rangeSliderValues,
    required this.activeFilterIndex,
  });

  FilterState copyWith({
    List<FilterListModel>? filters,
    int? activeFilterIndex,
    FilterType? type,
    double? sliderValues,
    RangeValues? rangeSliderValues,
  }) {
    return FilterState(
      activeFilterIndex: activeFilterIndex ?? this.activeFilterIndex,
      filters: filters ?? this.filters,
      type: type ?? this.type,
      sliderValues: sliderValues ?? this.sliderValues,
      rangeSliderValues: rangeSliderValues ?? this.rangeSliderValues,
    );
  }

  @override
  List<Object?> get props => [filters, activeFilterIndex, type, sliderValues,rangeSliderValues];
}
