import 'package:coozy_cafe/utlis/components/constants.dart';
import 'package:coozy_cafe/widgets/fliter_system_widget/props/applied_filter_model.dart';
import 'package:coozy_cafe/widgets/fliter_system_widget/props/filter_item_model.dart';
import 'package:coozy_cafe/widgets/fliter_system_widget/props/filter_list_model.dart';
import 'package:coozy_cafe/widgets/fliter_system_widget/props/filter_props.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'filter_state.dart';

class FilterCubit extends Cubit<FilterState> {
  FilterCubit({
    required this.filterProps,
  }) : super(
          FilterState.init(
              filters: filterProps.filters,
              activeFilterIndex: 0,
              type: filterProps.filters.first.type ?? FilterType.CheckboxList),
        );

  final FilterProps filterProps;

  List<FilterListModel>? filters;
  int? activeFilterIndex;

  bool checked(List<FilterItemModel> items, FilterItemModel item) {
    return items.contains(item);
  }

  onFilterTitleTap(int index) {
    activeFilterIndex = index;
    emit(
      state.copyWith(
        activeFilterIndex: index,
        type: filterProps.filters[index].type ?? FilterType.CheckboxList,
      ),
    );
  }

  Future<void> onFilterItemCheck(item) async {
    List<FilterListModel> filterModels = [...state.filters];
    FilterListModel filterItem = filterModels[state.activeFilterIndex];
    List<FilterItemModel>? checkedItems = [...filterItem.previousApplied];

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
          if (checkedItems.contains(item)) {
            checkedItems = [];
          } else {
            checkedItems = [];
            checkedItems.add(item);
          }
          Constants.debugLog(
              FilterCubit, "RadioGroup:checkedItems:${checkedItems}");
        }
        break;
      case FilterType.Slider:
        {
          Constants.debugLog(FilterCubit, "Slider");
          checkedItems = [];
          checkedItems.add(item);
          Constants.debugLog(FilterCubit, "Slider:Slider:${checkedItems}");
        }
        break;

      case FilterType.RangeSlider:
        {
          Constants.debugLog(FilterCubit, "RangeSlider");
          Constants.debugLog(FilterCubit, "RangeSlider:${item}");
          checkedItems = [];
          for (FilterItemModel model in item) {
            checkedItems.add(model);
          }
          Constants.debugLog(
              FilterCubit, "RangeSlider:RangeSlider:${checkedItems}");
        }
        break;
      case FilterType.TimePicker:
        {
          if (item == null) {
            checkedItems = [];
          } else {
            checkedItems.add(item);
          }
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
          if (item == null) {
            checkedItems = [];
          } else {
            checkedItems.add(item);
          }
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
    filters = filterModels;
    Constants.debugLog(FilterCubit, "CurrentList:${filters.toString()}");
    emit(state.copyWith(
      filters: filterModels,
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
    Constants.debugLog(
        FilterCubit, "appliedFilters:${appliedFilters.toString()}");
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
      // emit(state.copyWith(
      //   filters: filters,
      // ));
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

/*
import 'package:coozy_cafe/widgets/fliter_system_widget/props/applied_filter_model.dart';
import 'package:coozy_cafe/widgets/fliter_system_widget/props/filter_item_model.dart';
import 'package:coozy_cafe/widgets/fliter_system_widget/props/filter_list_model.dart';
import 'package:rxdart/rxdart.dart';

class FilterCubit {
  final BehaviorSubject<int> _activeFilterIndexSubject = BehaviorSubject<int>();
  final BehaviorSubject<FilterType> _filterTypeSubject = BehaviorSubject<FilterType>();
  final BehaviorSubject<List<FilterListModel>> _filtersSubject = BehaviorSubject<List<FilterListModel>>();

  Stream<int> get activeFilterIndexStream => _activeFilterIndexSubject.stream;
  Stream<FilterType> get filterTypeStream => _filterTypeSubject.stream;
  Stream<List<FilterListModel>> get filtersStream => _filtersSubject.stream;

  FilterCubit({
    required List<FilterListModel> filters,
    required int activeFilterIndex,
    required FilterType filterType,
  }) {
    _filtersSubject.add(filters);
    _activeFilterIndexSubject.add(activeFilterIndex);
    _filterTypeSubject.add(filterType);
  }

  void setActiveFilterIndex(int index) {
    _activeFilterIndexSubject.add(index);
  }

  void setFilterType(FilterType type) {
    _filterTypeSubject.add(type);
  }

  void setFilters(List<FilterListModel> filters) {
    _filtersSubject.add(filters);
  }

  bool checked(List<FilterItemModel> items, FilterItemModel item) {
    return items.contains(item);
  }

  void onFilterItemCheck(var item) {
    final currentIndex = _activeFilterIndexSubject.value;
    final currentFilters = _filtersSubject.value ?? [];
    final currentFilter = currentFilters[currentIndex];
    final List<FilterItemModel> checkedItems = [...currentFilter.previousApplied];

    switch (currentFilter.type) {
      case FilterType.CheckboxList:
        if (checkedItems.contains(item)) {
          checkedItems.remove(item);
        } else {
          checkedItems.add(item);
        }
        break;
      case FilterType.RadioGroup:
        checkedItems.clear();
        checkedItems.add(item);
        break;
      case FilterType.Slider:
        checkedItems.clear();
        checkedItems.add(item);
        break;
      case FilterType.RangeSlider:
        checkedItems.clear();
        for(int i=0;i<item!.lenght;i++){
          checkedItems.add(item[i]);
        }
        */
/*for (FilterItemModel model in item) {
          checkedItems.add(model);
        }*/ /*

        break;
      case FilterType.TimePicker:
        break;
      case FilterType.RangeTimePicker:
        break;
      case FilterType.DatePicker:
        break;
      case FilterType.RangeDatePicker:
        break;
      default:
        break;
    }

    final updatedItem = currentFilter.copyWith(previousApplied: checkedItems);
    final updatedFilters = List<FilterListModel>.from(currentFilters);
    updatedFilters[currentIndex] = updatedItem;

    _filtersSubject.add(updatedFilters);
  }

  void onFilterSubmit(Function(List<AppliedFilterModel>)? onFilterChange) {
    final currentFilters = _filtersSubject.value ?? [];
    final appliedFilters = <AppliedFilterModel>[];
    for (var element in currentFilters) {
      appliedFilters.add(AppliedFilterModel(
        filterKey: element.title,
        applied: element.previousApplied,
        filterTitle: element.title,
      ));
    }
    if (onFilterChange != null) {
      onFilterChange(appliedFilters);
    }
  }

  void onFilterRemove(Function(List<AppliedFilterModel>)? onFilterChange) {
    final currentFilters = _filtersSubject.value ?? [];
    final clearFilterList = <FilterListModel>[];
    for (var element in currentFilters) {
      final newModel = element.copyWith(
        previousApplied: [],
      );
      clearFilterList.add(newModel);
    }
    _filtersSubject.add(clearFilterList);
    if (onFilterChange != null) {
      onFilterChange([]);
    }
  }

  void filterBySearch(String text) {
    if (text.isEmpty) {
      return;
    }
    final currentFilters = _filtersSubject.value ?? [];
    final currentFilter = currentFilters[_activeFilterIndexSubject.value];
    final filterOptions = [...currentFilter.filterOptions];
    if (filterOptions.isNotEmpty) {
      List<FilterItemModel> searchedItems = [];
      for (var element in filterOptions) {
        if (element.filterTitle.toLowerCase().contains(text.toLowerCase())) {
          searchedItems.add(element);
        }
      }
      final updatedItem = currentFilter.copyWith(filterOptions: searchedItems);
      final updatedFilters = List<FilterListModel>.from(currentFilters);
      updatedFilters[_activeFilterIndexSubject.value] = updatedItem;
      _filtersSubject.add(updatedFilters);
    }
  }

  void clearSearch() {
    final currentFilters = _filtersSubject.value ?? [];
    final currentFilter = currentFilters[_activeFilterIndexSubject.value];
    final filterOptions = [...currentFilter.filterOptions];
    if (filterOptions.isNotEmpty) {
      final updatedItem = currentFilter.copyWith(filterOptions: filterOptions);
      final updatedFilters = List<FilterListModel>.from(currentFilters);
      updatedFilters[_activeFilterIndexSubject.value] = updatedItem;
      _filtersSubject.add(updatedFilters);
    }
  }

  void dispose() {
    _activeFilterIndexSubject.close();
    _filterTypeSubject.close();
    _filtersSubject.close();
  }

}*/
