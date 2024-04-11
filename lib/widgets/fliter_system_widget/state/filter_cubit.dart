/*
This is a Dart file that implements a Flutter Bloc
for managing the filter item state filtering items. 
Here's what each part of the code does:
*/
import 'package:coozy_cafe/utlis/components/constants.dart';
import 'package:coozy_cafe/widgets/fliter_system_widget/props/applied_filter_model.dart';
import 'package:coozy_cafe/widgets/fliter_system_widget/props/filter_item_model.dart';
import 'package:coozy_cafe/widgets/fliter_system_widget/props/filter_list_model.dart';
import 'package:coozy_cafe/widgets/fliter_system_widget/props/filter_props.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'filter_state.dart';

class FilterCubit extends Cubit<FilterState> {
  FilterCubit({
    required this.filterProps,
  }) : super(
          FilterState.init(
              filters: filterProps.filters,
              activeFilterIndex: 0,
              sliderValues: 0.0,
              rangeSliderValues: RangeValues(0, 0),
              type: filterProps.filters.first.type ?? FilterType.CheckboxList),
        );

  final FilterProps filterProps;

  bool checked(List<FilterItemModel> items, FilterItemModel item) {
    return items.contains(item);
  }

  onFilterTitleTap(int index) {
    emit(
      state.copyWith(
        activeFilterIndex: index,
        type: filterProps.filters[index].type ?? FilterType.CheckboxList,
      ),
    );
  }

  void onFilterItemCheck(FilterItemModel item) {
    List<FilterListModel> filterModels = [...state.filters];
    FilterListModel filterItem = filterModels[state.activeFilterIndex];
    final checkedItems = [...filterItem.previousApplied];

    switch (filterItem.type) {
      case FilterType.CheckboxList:
        {
          Constants.debugLog(FilterCubit, "CheckboxList");
          if (checkedItems.contains(item)) {
            checkedItems.remove(item);
          } else {
            checkedItems.add(item);
          }
          Constants.debugLog(
              FilterCubit, "CheckboxList:checkedItems:${checkedItems}");
        }
        break;
      case FilterType.RadioGroup:
        {
          Constants.debugLog(FilterCubit, "RadioGroup");
          checkedItems.clear();
          checkedItems.add(item);
          Constants.debugLog(
              FilterCubit, "RadioGroup:checkedItems:${checkedItems}");
        }
        break;
      case FilterType.Slider:
        {
          Constants.debugLog(FilterCubit, "Slider");
          checkedItems.clear();
          checkedItems.add(item);
          Constants.debugLog(
              FilterCubit, "Slider:Slider:${checkedItems}");
        }
        break;
      case FilterType.TimePicker:
        {
          Constants.debugLog(FilterCubit, "TimePicker");
        }
        break;
      case FilterType.RangeTimePicker:
        {
          Constants.debugLog(FilterCubit, "RangeTimePicker");
        }
        break;
      case FilterType.DatePicker:
        {
          Constants.debugLog(FilterCubit, "DatePicker");
        }
        break;
      case FilterType.RangeDatePicker:
        {
          Constants.debugLog(FilterCubit, "RangeDatePicker");
        }
        break;
      default:
        Constants.debugLog(FilterCubit, "default");
        break;
    }

    final updatedItem = filterItem.copyWith(
      previousApplied: checkedItems,
    );

    filterModels[state.activeFilterIndex] = updatedItem;
    emit(state.copyWith(
      filters: filterModels,
      sliderValues:double.tryParse("${item.filterKey.toString()}")??0.0
    ));
  }

  void onFilterSubmit() {
    final appliedFilters = <AppliedFilterModel>[];
    for (var element in state.filters) {
      appliedFilters.add(AppliedFilterModel(
        filterKey: element.filterKey,
        applied: element.previousApplied,
        filterTitle: element.title,
      ));
    }
    if (filterProps.onFilterChange != null) {
      filterProps.onFilterChange!(appliedFilters);
    }
  }

  void onFilterRemove() {
    final clearFilterList = <FilterListModel>[];
    final filtered = [...state.filters];
    for (var element in filtered) {
      final newModel = element.copyWith(
        previousApplied: [],
      );
      clearFilterList.add(newModel);
    }
    emit(state.copyWith(
      filters: clearFilterList,
    ));
    if (filterProps.onFilterChange != null) {
      filterProps.onFilterChange!([]);
    }
  }

  void filterBySearch(String text) {
    if (text.isEmpty) {
      return;
    }
    final filteringItem = filterProps.filters[state.activeFilterIndex];
    final filterOption = [...filteringItem.filterOptions];
    if (filterOption.isNotEmpty) {
      List<FilterItemModel> searchedItems = [];
      for (var element in filterOption) {
        if (element.filterTitle.toLowerCase().contains(text.toLowerCase())) {
          searchedItems.add(element);
        }
      }
      List<FilterListModel> filters = [...state.filters];

      final updatedItem = filters[state.activeFilterIndex].copyWith(
        filterOptions: searchedItems,
      );
      filters[state.activeFilterIndex] = updatedItem;
      emit(state.copyWith(
        filters: filters,
      ));
    }
  }

  void clearSearch() {
    final filteringItem = filterProps.filters[state.activeFilterIndex];
    final filterOption = [...filteringItem.filterOptions];
    if (filterOption.isNotEmpty) {
      List<FilterItemModel> searchedItems = filterOption;

      List<FilterListModel> filters = [...state.filters];

      final updatedItem = filters[state.activeFilterIndex].copyWith(
        filterOptions: searchedItems,
      );

      filters[state.activeFilterIndex] = updatedItem;
      emit(state.copyWith(
        filters: filters,
      ));
    }
  }

  @override
  Future<void> close() {
    // TODO: implement close
    return super.close();
  }

}
