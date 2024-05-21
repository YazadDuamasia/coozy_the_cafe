import 'package:coozy_cafe/utlis/utlis.dart';
import 'package:coozy_cafe/widgets/fliter_system_widget/filter_style_mixin.dart';
import 'package:coozy_cafe/widgets/fliter_system_widget/widgets/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../props/props.dart';

class FilterSystemWidget extends StatefulWidget {
  final FilterProps filterProps;

  const FilterSystemWidget({Key? key, required this.filterProps})
      : super(key: key);

  @override
  _FilterSystemWidgetState createState() => _FilterSystemWidgetState();
}

class _FilterSystemWidgetState extends State<FilterSystemWidget>
    with FilterStyleMixin {
  final _searchValueNotifier = ValueNotifier<String>('');
  final _searchController = TextEditingController(text: "");

  FilterProps? filterProps;

  List<FilterListModel>? filters = [];
  int? activeFilterIndex = 0;
  FilterType? type;

  void _clearSearch() {
    _searchValueNotifier.value = '';
    _searchController.clear();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      filterProps = widget.filterProps;
      filters = widget.filterProps.filters;
      activeFilterIndex = 0;
      if (filterProps != null &&
          filterProps!.filters != null &&
          filterProps!.filters.isNotEmpty) {
        type = filterProps?.filters.first.type;
      } else {
        type = FilterType.CheckboxList;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        final themeProps = filterProps?.themeProps;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FilterText(
                    title: filterProps?.title ?? 'Filters',
                    style: themeProps?.titleStyle,
                    fontColor: themeProps?.titleColor,
                  ),
                  Visibility(
                    visible: (filterProps?.showCloseIcon ?? true),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      visualDensity: const VisualDensity(
                        horizontal: -4,
                        vertical: -4,
                      ),
                      onPressed: () {
                        if (filterProps?.onCloseTap != null) {
                          filterProps?.onCloseTap!();
                        }
                        Navigator.of(context).pop();
                      },
                      icon: filterProps?.closeIcon ?? const Icon(Icons.close),
                    ),
                  )
                ],
              ),
            ),
            themeProps?.divider ??
                Container(
                  height: themeProps?.dividerThickness ?? 2,
                  width: MediaQuery.of(context).size.width,
                  color: themeProps?.dividerColor ?? getDividerColor(context),
                ),
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      flex: 4,
                      child: Scrollbar(
                        interactive: true,
                        child: CustomScrollView(
                          physics: ClampingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics(),
                          ),
                          shrinkWrap: true,
                          slivers: [
                            SliverPadding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 5, top: 5),
                              sliver: SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                    final filterTitleListModel =
                                        filters![index];
                                    return Material(
                                      type: MaterialType.transparency,
                                      child: InkWell(
                                        splashColor:
                                            Theme.of(context).splashColor,
                                        onTap: () {
                                          _clearSearch();
                                          onFilterTitleTap(index);
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                color: (index ==
                                                        activeFilterIndex)
                                                    ? themeProps
                                                            ?.inActiveFilterItemBackgroundColor ??
                                                        Theme.of(context)
                                                            .colorScheme
                                                            .primaryContainer
                                                    : null,
                                                padding: const EdgeInsets.only(
                                                    left: 10,
                                                    top: 5,
                                                    bottom: 5),
                                                child: FilterText(
                                                  title: filterTitleListModel
                                                          .title ??
                                                      "",
                                                  fontSize: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium!
                                                      .fontSize,
                                                  style: (index ==
                                                          activeFilterIndex)
                                                      // ? themeProps
                                                      //     ?.activeFilterTextStyle
                                                      ? themeProps
                                                          ?.inActiveFilterTextStyle
                                                      : themeProps
                                                          ?.inActiveFilterTextStyle,
                                                  fontWeight: FontWeight.w500,
                                                  fontColor: (index ==
                                                          activeFilterIndex)
                                                      ? themeProps
                                                              ?.activeFilterTextColor ??
                                                          getTheme(context)
                                                              .primaryColor
                                                      : themeProps
                                                          ?.inActiveFilterTextColor,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                  addSemanticIndexes: true,
                                  addAutomaticKeepAlives: true,
                                  addRepaintBoundaries: false,
                                  childCount: filters?.length ?? 0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    themeProps?.divider ??
                        Container(
                          height: double.maxFinite,
                          width: themeProps?.dividerThickness ?? 1,
                          color: themeProps?.dividerColor ??
                              getDividerColor(context),
                        ),
                    Flexible(
                      flex: 6,
                      child: custom_filter_widget(themeProps),
                    ),
                  ],
                ),
              ),
            ),
            themeProps?.divider ??
                Container(
                  height: themeProps?.dividerThickness ?? 2,
                  width: MediaQuery.of(context).size.width,
                  color: themeProps?.dividerColor ?? getDividerColor(context),
                ),
            Container(
              width: MediaQuery.of(context).size.width,
              // color: getTheme(context).primaryColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  FilterTextButton(
                    text: 'Reset',
                    isSecondary: true,
                    onTap: () {
                      onFilterRemove();
                      Navigator.of(context).pop();
                    },
                    style: themeProps?.resetButtonStyle,
                    txtColor: themeProps?.resetButtonColor,
                  ),
                  FilterTextButton(
                    text: 'Apply',
                    txtColor: themeProps?.submitButtonColor ??
                        getTheme(context).colorScheme.secondary,
                    onTap: () async {
                      await onFilterSubmit();
                      Navigator.of(context).pop();
                    },
                    style: themeProps?.submitButtonStyle,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  onFilterTitleTap(int index) {
    setState(() {
      activeFilterIndex = index;
      type = filterProps?.filters[index].type ?? FilterType.CheckboxList;
    });
  }

  void onFilterRemove() async {
    final clearFilterList = <FilterListModel>[];
    // final filtered = [...filters!];
    final filtered = filters?.where((item) => item != null).toList() ?? [];
    for (var element in filtered) {
      final newModel = element.copyWith(
        previousApplied: [],
      );
      clearFilterList.add(newModel);
    }
    setState(() {
      filters = clearFilterList;
    });
    if (filterProps?.onFilterChange != null) {
      filterProps?.onFilterChange!([]);
    }
    setState(() {});
  }

  bool checked(List<FilterItemModel>? items, FilterItemModel? item) {
    return items!.contains(item);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  onFilterSubmit() async {
    final appliedFilters = <AppliedFilterModel>[];
    for (var element in filters!) {
      appliedFilters.add(AppliedFilterModel(
        filterKey: element.filterKey,
        applied: element.previousApplied,
        filterTitle: element.title,
      ));
    }
    if (filterProps?.onFilterChange != null) {
      filterProps?.onFilterChange!(appliedFilters);
    }
    setState(() {});
  }

  double findSliderValue(List<FilterItemModel>? filterOptions) {
    // Use reduce to find the minimum value
    try {
      return filterOptions
              ?.map<double?>((item) {
                return double.tryParse("${item.filterKey}") ?? 0.0;
              })
              .whereType<double>()
              .reduce(
                  (minValue, value) => value < minValue ? value : minValue) ??
          0.0;
    } catch (e) {
      print(e);
      return 0.0;
    }
  }

  double? findMinValue(List<FilterItemModel>? filterOptions) {
    // Use reduce to find the minimum value
    try {
      return filterOptions
              ?.map<double?>((item) {
                return double.tryParse("${item.filterKey}") ?? 0.0;
              })
              .whereType<double>()
              .reduce(
                  (minValue, value) => value < minValue ? value : minValue) ??
          0.0;
    } catch (e) {
      return 0.0;
    }
  }

  double? findMaxValue(List<FilterItemModel>? filterOptions) {
    // Use reduce to find the maximum value
    try {
      return filterOptions
              ?.map<double?>((item) {
                return double.tryParse("${item.filterKey}") ?? 0.0;
              })
              .whereType<double>()
              .reduce(
                  (maxValue, value) => value > maxValue ? value : maxValue) ??
          0.0;
    } catch (e) {
      print(e);
      return 0.0;
    }
  }

  Widget custom_filter_widget(ThemeProps? themeProps) {
    if (filters == null || filters!.isEmpty) {
      return const SizedBox.shrink();
    } else {
      switch (type) {
        case FilterType.CheckboxList:
          return checkboxWidget(themeProps);
        case FilterType.RadioGroup:
          return radioGroupWidget(themeProps);
        case FilterType.Slider:
          return sliderWidget(themeProps);
        case FilterType.VericalSlider:
          return verticalSliderWidget(themeProps);
        case FilterType.RangeSlider:
          return rangerSliderTitleWidget(themeProps);
        case FilterType.VericalRangeSlider:
          return rangerVerticalSliderTitleWidget(themeProps);
        case FilterType.DatePicker:
          return datePickerWidget(themeProps);
        case FilterType.TimePicker:
          return Container();
        case FilterType.RangeDatePicker:
          return Container();

        case FilterType.RangeTimePicker:
          return Container();
        default:
          return Container();
      }
    }
  }

  void filterBySearch(String text) async {
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    final filteringItem = filterProps?.filters[activeFilterIndex!];
    List<FilterItemModel> filterOption = [];
    if (filteringItem != null && filteringItem.filterOptions.isNotEmpty) {
      filterOption = [...filteringItem.filterOptions];
    } else {
      filterOption = [];
    }

    if (filterOption.isNotEmpty) {
      List<FilterItemModel> searchedItems = [];
      for (var element in filterOption) {
        if (element.filterTitle.toLowerCase().contains(text.toLowerCase())) {
          searchedItems.add(element);
        }
      }

      if (filters != null) {
        final updatedItem = filters![activeFilterIndex!].copyWith(
          filterOptions: searchedItems,
        );
        filters![activeFilterIndex!] = updatedItem;
      }
    }
    setState(() {});
  }

  void onFilterItemCheck(item) {
    List<FilterListModel>? filterModels = filters;
    FilterListModel? filterItem = filterModels?[activeFilterIndex!];
    // final List<FilterItemModel>? checkedItems = [...filterItem.previousApplied];
    final List<FilterItemModel>? checkedItems =
        filterItem?.previousApplied.where((item) => item != null).toList() ??
            [];

    switch (filterItem!.type) {
      case FilterType.CheckboxList:
        {
          Constants.debugLog(FilterSystemWidget, "CheckboxList");
          if (checkedItems!.contains(item)) {
            checkedItems.remove(item);
          } else {
            checkedItems.add(item);
          }
          Constants.debugLog(
              FilterSystemWidget, "CheckboxList:checkedItems:${checkedItems}");
        }
        break;
      case FilterType.RadioGroup:
        {
          Constants.debugLog(FilterSystemWidget, "RadioGroup");
          checkedItems!.clear();
          checkedItems.add(item);
          Constants.debugLog(
              FilterSystemWidget, "RadioGroup:checkedItems:${checkedItems}");
        }
        break;
      case FilterType.Slider:
        {
          Constants.debugLog(FilterSystemWidget, "Slider");
          checkedItems!.clear();
          checkedItems.add(item);
          Constants.debugLog(
              FilterSystemWidget, "Slider:Slider:${checkedItems}");
        }
        break;

      case FilterType.RangeSlider:
        {
          Constants.debugLog(FilterSystemWidget, "RangeSlider");
          Constants.debugLog(FilterSystemWidget, "RangeSlider:${item}");
          checkedItems!.clear();
          for (FilterItemModel model in item) {
            checkedItems.add(model);
          }
          Constants.debugLog(
              FilterSystemWidget, "Slider:Slider:${checkedItems}");
        }
        break;
      case FilterType.TimePicker:
        {
          Constants.debugLog(FilterSystemWidget, "TimePicker");
        }
        break;
      case FilterType.RangeTimePicker:
        {
          Constants.debugLog(FilterSystemWidget, "RangeTimePicker");
        }
        break;
      case FilterType.DatePicker:
        {
          Constants.debugLog(FilterSystemWidget, "DatePicker");
        }
        break;
      case FilterType.RangeDatePicker:
        {
          Constants.debugLog(FilterSystemWidget, "RangeDatePicker");
        }
        break;
      default:
        Constants.debugLog(FilterSystemWidget, "default");
        break;
    }

    final updatedItem = filterItem.copyWith(
      previousApplied: checkedItems,
    );

    filterModels?[activeFilterIndex!] = updatedItem;
    filters = filterModels;
    setState(() {});
  }

  checkboxWidget(ThemeProps? themeProps) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Builder(
        builder: (context) {
          final list = filters?[activeFilterIndex!].filterOptions;

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 7,
                ),
                child: ValueListenableBuilder<String>(
                    valueListenable: _searchValueNotifier,
                    builder: (context, searchValue, child) {
                      return TextFormField(
                        controller: _searchController,
                        style: themeProps?.searchBarViewProps?.textStyle,
                        decoration: InputDecoration(
                            hintText:
                                themeProps?.searchBarViewProps?.searchHint ??
                                    'Search',
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 10,
                            ),
                            hintStyle:
                                themeProps?.searchBarViewProps?.hintStyle,
                            fillColor: themeProps?.searchBarViewProps?.fillColor
                                    ?.withOpacity(0.8) ??
                                Theme.of(context).primaryColor.withOpacity(0.1),
                            filled:
                                themeProps?.searchBarViewProps?.filled ?? true,
                            border:
                                themeProps?.searchBarViewProps?.inputBorder ??
                                    OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: themeProps?.searchBarViewProps
                                                ?.fillColor ??
                                            getTheme(context).primaryColor,
                                      ),
                                    ),
                            suffixIcon: searchValue.isNotEmpty
                                ? IconButton(
                                    onPressed: () {
                                      _clearSearch();
                                    },
                                    icon: themeProps
                                            ?.searchBarViewProps?.clearIcon ??
                                        Icon(Icons.close,
                                            color: themeProps
                                                ?.searchBarViewProps
                                                ?.clearIconColor),
                                  )
                                : IconButton(
                                    onPressed: () {
                                      filterBySearch(_searchController.text);
                                    },
                                    icon: themeProps
                                            ?.searchBarViewProps?.searchIcon ??
                                        Icon(
                                          Icons.search,
                                          color: themeProps?.searchBarViewProps
                                              ?.searchIconColor,
                                        ),
                                  )),
                        onFieldSubmitted: (value) {},
                        textInputAction: TextInputAction.search,
                        onChanged: (value) {
                          _searchValueNotifier.value = value;
                          if (value.isEmpty) {
                            _clearSearch();
                          } else {
                            filterBySearch(_searchController.text);
                          }
                        },
                      );
                    }),
              ),
              Visibility(
                visible: list?.isNotEmpty ?? false,
                child: Expanded(
                  child: Scrollbar(
                    interactive: true,
                    trackVisibility: true,
                    child: CustomScrollView(
                      physics: ClampingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      shrinkWrap: true,
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 10),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final item = list?[index] ?? null;
                                return FilterCheckboxTitle(
                                  key: UniqueKey(),
                                  checkBoxTileThemeProps:
                                      themeProps?.checkBoxTileThemeProps,
                                  selected: checked(
                                    filters?[activeFilterIndex!]
                                        .previousApplied,
                                    item,
                                  ),
                                  title: item?.filterTitle ?? "",
                                  onUpdate: (bool? value) async {
                                    onFilterItemCheck(item);
                                  },
                                );
                              },
                              addSemanticIndexes: true,
                              addAutomaticKeepAlives: true,
                              addRepaintBoundaries: false,
                              childCount: list?.length ?? 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  radioGroupWidget(ThemeProps? themeProps) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Builder(
        builder: (context) {
          final list = filters?[activeFilterIndex!].filterOptions;

          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 7,
                ),
                child: ValueListenableBuilder<String>(
                    valueListenable: _searchValueNotifier,
                    builder: (context, searchValue, child) {
                      return TextFormField(
                        controller: _searchController,
                        style: themeProps?.searchBarViewProps?.textStyle,
                        decoration: InputDecoration(
                            hintText:
                                themeProps?.searchBarViewProps?.searchHint ??
                                    'Search',
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 10,
                            ),
                            hintStyle:
                                themeProps?.searchBarViewProps?.hintStyle,
                            fillColor: themeProps?.searchBarViewProps?.fillColor
                                    ?.withOpacity(0.8) ??
                                Theme.of(context).primaryColor.withOpacity(0.1),
                            filled:
                                themeProps?.searchBarViewProps?.filled ?? true,
                            border:
                                themeProps?.searchBarViewProps?.inputBorder ??
                                    OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: BorderSide(
                                        width: 1,
                                        color: themeProps?.searchBarViewProps
                                                ?.fillColor ??
                                            getTheme(context).primaryColor,
                                      ),
                                    ),
                            suffixIcon: searchValue.isNotEmpty
                                ? IconButton(
                                    onPressed: () async {
                                      _clearSearch();
                                    },
                                    icon: themeProps
                                            ?.searchBarViewProps?.clearIcon ??
                                        Icon(Icons.close,
                                            color: themeProps
                                                ?.searchBarViewProps
                                                ?.clearIconColor),
                                  )
                                : IconButton(
                                    onPressed: () async {
                                      filterBySearch(_searchController.text);
                                    },
                                    icon: themeProps
                                            ?.searchBarViewProps?.searchIcon ??
                                        Icon(
                                          Icons.search,
                                          color: themeProps?.searchBarViewProps
                                              ?.searchIconColor,
                                        ),
                                  )),
                        onFieldSubmitted: (value) {},
                        textInputAction: TextInputAction.search,
                        onChanged: (value) {
                          _searchValueNotifier.value = value;
                          if (value.isEmpty) {
                            _clearSearch();
                          } else {
                            filterBySearch(_searchController.text);
                          }
                        },
                      );
                    }),
              ),
              Visibility(
                visible: list?.isNotEmpty ?? false,
                child: Expanded(
                  child: Scrollbar(
                    interactive: true,
                    trackVisibility: true,
                    child: CustomScrollView(
                      physics: ClampingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                      shrinkWrap: true,
                      slivers: [
                        SliverPadding(
                          padding: const EdgeInsets.only(
                              left: 10, right: 10, top: 10),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                final item = list?[index];
                                return FilterRadioBoxTitle(
                                  options: [item!],
                                  // Use single item as an option
                                  selectedOption: checked(
                                          filters?[activeFilterIndex!]
                                              .previousApplied,
                                          item)
                                      ? item
                                      : null,
                                  onChanged: (selected) {
                                    onFilterItemCheck(item);
                                  },
                                  radioTileThemeProps:
                                      themeProps?.radioTileThemeProps,
                                );
                              },
                              addSemanticIndexes: true,
                              addAutomaticKeepAlives: true,
                              addRepaintBoundaries: false,
                              childCount: list?.length ?? 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  sliderWidget(ThemeProps? themeProps) {
    final List<FilterItemModel>? filterOptions =
        filters?[activeFilterIndex!].filterOptions;
    List<FilterItemModel>? previousApplied =
        filters?[activeFilterIndex!].previousApplied;
    final title = filters?[activeFilterIndex!].title ?? "";

    final minValue = findMinValue(filterOptions!);
    final maxValue = findMaxValue(filterOptions);
    final double minGap = 1.0;
    double? values = (previousApplied == null || previousApplied.isEmpty)
        ? 0.0
        : double.tryParse("${previousApplied.first.filterKey ?? 0.0}") ?? 0.0;
    final SliderTileThemeProps? sliderTileThemeProps =
        filters?[activeFilterIndex!].sliderTileThemeProps;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          child: FilterSliderTitle(
            key: UniqueKey(),
            sliderTileThemeProps: themeProps!.sliderTileThemeProps,
            filterOptions: filterOptions,
            previousApplied: previousApplied!,
            title: title,
            values: values,
            minValue: minValue!,
            maxValue: maxValue!,
            onChanged: (newValues) async {
              FilterItemModel model = FilterItemModel(
                  filterKey: newValues, filterTitle: "${newValues}");
              onFilterItemCheck(model);
            },
          ),
        )
      ],
    );


  }

  verticalSliderWidget(ThemeProps? themeProps) {
    final filterOptions = filters?[activeFilterIndex!].filterOptions;
    final previousApplied = filters?[activeFilterIndex!].previousApplied;
    final title = filters?[activeFilterIndex!].title ?? "";

    final minValue = findMinValue(filterOptions);
    final maxValue = findMaxValue(filterOptions);
    final double minGap = 1.0;
    final double? values = (previousApplied == null || previousApplied.isEmpty)
        ? 0.0
        : double.tryParse("${previousApplied.first.filterKey}") ?? 0.0;
    final SliderTileThemeProps? sliderTileThemeProps =
        filters?[activeFilterIndex!].sliderTileThemeProps;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          child: FilterVerticalSliderTitle(
            key: UniqueKey(),
            sliderTileThemeProps: sliderTileThemeProps,
            filterOptions: filterOptions!,
            previousApplied: previousApplied!,
            title: title,
            values: values,
            minValue: minValue!,
            maxValue: maxValue!,
            onChanged: (double newValues) async {
              FilterItemModel model = FilterItemModel(
                  filterKey: newValues, filterTitle: "${newValues}");
              onFilterItemCheck(model);
            },
          ),
        )
      ],
    );
  }

  rangerSliderTitleWidget(ThemeProps? themeProps) {
    final filterOptions = filters?[activeFilterIndex!].filterOptions;
    final previousApplied = filters?[activeFilterIndex!].previousApplied;
    final title = filters?[activeFilterIndex!].title ?? "";
    Constants.debugLog(
        FilterSystemWidget, "rangerSliderTitleWidget:rangerSliderTitleWidget");

    final minValue = findMinValue(filterOptions);
    final maxValue = findMaxValue(filterOptions);
    final double minGap = 1.0;
    double? minPreviousAppliedValue;
    double? maxPreviousAppliedValue;
    if (previousApplied == null && previousApplied!.isEmpty) {
      minPreviousAppliedValue = 0.0;
      maxPreviousAppliedValue = 0.0;
    } else {
      minPreviousAppliedValue = findMinValue(previousApplied);
      maxPreviousAppliedValue = findMaxValue(previousApplied);
    }
    SfRangeValues? values = ((previousApplied == null &&
            previousApplied!.isEmpty)
        ? SfRangeValues(minValue ?? 0.0, maxValue ?? 0.0)
        : SfRangeValues(
            minPreviousAppliedValue ?? 0.0, maxPreviousAppliedValue ?? 0.0));
    final SliderTileThemeProps? sliderTileThemeProps =
        filters?[activeFilterIndex!].sliderTileThemeProps;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          child: FilterRangerSliderTitle(
            key: UniqueKey(),
            sliderTileThemeProps: sliderTileThemeProps,
            filterOptions: filterOptions!,
            previousApplied: previousApplied!,
            title: title,
            values: values,
            minValue: minValue!,
            maxValue: maxValue!,
            onChanged: (newValues) async {
              FilterItemModel startModel = FilterItemModel(
                  filterKey: newValues.start,
                  filterTitle: "${newValues.start}");
              FilterItemModel endModel = FilterItemModel(
                  filterKey: newValues.end, filterTitle: "${newValues.end}");
              List<FilterItemModel> list = [];
              list.add(startModel);
              list.add(endModel);
              Constants.debugLog(FilterSystemWidget,
                  "rangerSliderTitleWidget:rangerSliderTitleWidget:onChanged:${list.toString()}");
              onFilterItemCheck(list);
            },
          ),
        )
      ],
    );
  }

  rangerVerticalSliderTitleWidget(ThemeProps? themeProps) {
    final filterOptions = filters?[activeFilterIndex!].filterOptions;
    final previousApplied = filters?[activeFilterIndex!].previousApplied;
    final title = filters?[activeFilterIndex!].title ?? "";
    Constants.debugLog(
        FilterSystemWidget, "rangerSliderTitleWidget:rangerSliderTitleWidget");

    final minValue = findMinValue(filterOptions);
    final maxValue = findMaxValue(filterOptions);
    final double minGap = 1.0;
    double? minPreviousAppliedValue;
    double? maxPreviousAppliedValue;
    if (previousApplied == null && previousApplied!.isEmpty) {
      minPreviousAppliedValue = 0.0;
      maxPreviousAppliedValue = 0.0;
    } else {
      minPreviousAppliedValue = findMinValue(previousApplied);
      maxPreviousAppliedValue = findMaxValue(previousApplied);
    }
    SfRangeValues? values = ((previousApplied == null &&
            previousApplied.isEmpty)
        ? SfRangeValues(minValue ?? 0.0, maxValue ?? 0.0)
        : SfRangeValues(
            minPreviousAppliedValue ?? 0.0, maxPreviousAppliedValue ?? 0.0));
    final SliderTileThemeProps? sliderTileThemeProps =
        filters?[activeFilterIndex!].sliderTileThemeProps;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: FilterVerticalRangerSliderTitle(
            key: UniqueKey(),
            sliderTileThemeProps: sliderTileThemeProps,
            filterOptions: filterOptions!,
            previousApplied: previousApplied!,
            title: title,
            values: values,
            minValue: minValue!,
            maxValue: maxValue!,
            onChanged: (newValues) async {
              FilterItemModel startModel = FilterItemModel(
                  filterKey: newValues.start,
                  filterTitle: "${newValues.start}");
              FilterItemModel endModel = FilterItemModel(
                  filterKey: newValues.end, filterTitle: "${newValues.end}");
              List<FilterItemModel> list = [];
              list.add(startModel);
              list.add(endModel);
              Constants.debugLog(FilterSystemWidget,
                  "rangerSliderTitleWidget:rangerSliderTitleWidget:onChanged:${list.toString()}");
              onFilterItemCheck(list);
            },
          ),
        )
      ],
    );
  }

  datePickerWidget(ThemeProps? themeProps) {
    final filterOptions = filters![activeFilterIndex!].filterOptions;
    final previousApplied = filters?[activeFilterIndex!].previousApplied;
    final title = filters?[activeFilterIndex!].title ?? "";

    final DateFormat inputDateFormat =
        filters?[activeFilterIndex!].inputDateFormat ??
            DateFormat("dd-MM-yyyy");
    final DateTime initialDate = (filters?[activeFilterIndex!].initialDate ==
                null ||
            filters![activeFilterIndex!].initialDate!.isEmpty)
        ? DateUtil.simpleDateFormatChanger(
            DateTime.now(), inputDateFormat.pattern!)!
        : DateUtil.stringToDate(
            filters?[activeFilterIndex!].initialDate, inputDateFormat.pattern!);
    final minimumDate = filters?[activeFilterIndex!].minimumDate ??
        DateTime(DateTime.now().year - 150, 1, 1);
    final maximumDate = filters?[activeFilterIndex!].maximumDate ??
        DateTime(DateTime.now().year + 150, 1, 1);
    final datePickerDateOrder =
        filters?[activeFilterIndex!].datePickerDateOrder ??
            DatePickerDateOrder.dmy;

    Constants.debugLog(
        FilterWidget, "rangerSliderTitleWidget:datePickerWidget");
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          child: DateTimeField(
            key: UniqueKey(),
            onChanged: (value) {},
            controller: new TextEditingController(),
            focusNode: new FocusNode(),
            validator: (value) {},
            initialValue: initialDate,
            autovalidateMode: AutovalidateMode.disabled,
            format: inputDateFormat,
            onShowPicker: (BuildContext context, DateTime? currentValue) async {
              final date = await showDatePickerSheet(
                context: context,
                initialDate: initialDate,
                pickerMode: CupertinoDatePickerMode.date,
                dateOrder: datePickerDateOrder,
                backgroundColor: Theme.of(context).colorScheme.background,
                minimumDate: minimumDate,
                maximumDate: maximumDate,
              );
              return date;
            },
          ),
        ),
      ],
    );
  }
}
