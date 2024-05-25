/// Main widget for filtering data
/// Required parametter is FilterProps

import 'package:coozy_cafe/utlis/utlis.dart';
import 'package:coozy_cafe/widgets/datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:coozy_cafe/widgets/fliter_system_widget/filter_style_mixin.dart';
import 'package:coozy_cafe/widgets/fliter_system_widget/props/filter_item_model.dart';
import 'package:coozy_cafe/widgets/fliter_system_widget/props/filter_list_model.dart';
import 'package:coozy_cafe/widgets/fliter_system_widget/props/filter_props.dart';
import 'package:coozy_cafe/widgets/fliter_system_widget/state/filter_cubit.dart';
import 'package:coozy_cafe/widgets/fliter_system_widget/widgets/filter_checkbox_title.dart';
import 'package:coozy_cafe/widgets/fliter_system_widget/widgets/filter_radio_box_title.dart';
import 'package:coozy_cafe/widgets/fliter_system_widget/widgets/filter_range_slider_title.dart';
import 'package:coozy_cafe/widgets/fliter_system_widget/widgets/filter_range_slider_vertical_title.dart';
import 'package:coozy_cafe/widgets/fliter_system_widget/widgets/filter_slider_title.dart';
import 'package:coozy_cafe/widgets/fliter_system_widget/widgets/filter_slider_vertical_title.dart';
import 'package:coozy_cafe/widgets/fliter_system_widget/widgets/showDatePickerSheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import 'filter_text.dart';
import 'filter_text_button.dart';

class FilterWidget extends StatelessWidget {
  const FilterWidget({
    Key? key,
    required this.filterProps,
  }) : super(key: key);

  final FilterProps filterProps;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FilterCubit(
        filterProps: filterProps,
      ),
      child: Filter(),
    );
  }
}

class Filter extends StatefulWidget {
  const Filter({
    Key? key,
  }) : super(key: key);

  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> with FilterStyleMixin {
  late FilterCubit _filterCubit;

  final _searchValueNotifier = ValueNotifier<String>('');
  final _searchController = TextEditingController();

  @override
  void initState() {
    _filterCubit = context.read<FilterCubit>();
    super.initState();
  }

  void _clearSearch() {
    _searchValueNotifier.value = '';
    _searchController.clear();
    _filterCubit.clearSearch();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FilterCubit, FilterState>(
      listener: (context, state) {},
      builder: (_, state) {
        final themeProps = _filterCubit.filterProps.themeProps;
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
                    title: _filterCubit.filterProps.title ?? 'Filters',
                    style: themeProps?.titleStyle,
                    fontColor: themeProps?.titleColor,
                  ),
                  Visibility(
                    visible: (_filterCubit.filterProps.showCloseIcon ?? true),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      visualDensity: const VisualDensity(
                        horizontal: -4,
                        vertical: -4,
                      ),
                      onPressed: () {
                        if (_filterCubit.filterProps.onCloseTap != null) {
                          _filterCubit.filterProps.onCloseTap!();
                        }
                        Navigator.of(context).pop();
                      },
                      icon: _filterCubit.filterProps.closeIcon ??
                          const Icon(Icons.close),
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
                                        state.filters[index];
                                    return Material(
                                      type: MaterialType.transparency,
                                      child: InkWell(
                                        splashColor:
                                            Theme.of(context).splashColor,
                                        onTap: () {
                                          _clearSearch();
                                          _filterCubit.onFilterTitleTap(index);
                                        },
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Expanded(
                                              child: Container(
                                                color: (index ==
                                                        state.activeFilterIndex)
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
                                                          state
                                                              .activeFilterIndex)
                                                      // ? themeProps
                                                      //     ?.activeFilterTextStyle
                                                      ? themeProps
                                                          ?.inActiveFilterTextStyle
                                                      : themeProps
                                                          ?.inActiveFilterTextStyle,
                                                  fontWeight: FontWeight.w500,
                                                  fontColor: (index ==
                                                          state
                                                              .activeFilterIndex)
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
                                  childCount: state.filters.length ?? 0,
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
                      child: custom_filter_widget(state, themeProps),
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
                      _filterCubit.onFilterRemove();
                      Navigator.of(context).pop();
                    },
                    style: themeProps?.resetButtonStyle,
                    txtColor: themeProps?.resetButtonColor,
                  ),
                  FilterTextButton(
                    text: 'Apply',
                    txtColor: themeProps?.submitButtonColor ??
                        getTheme(context).colorScheme.secondary,
                    onTap: () {
                      _filterCubit.onFilterSubmit();
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

  custom_filter_widget(FilterState state, ThemeProps? themeProps) {
    if (state.filters == null || state.filters.isEmpty) {
      return const SizedBox.shrink();
    } else {
      switch (state.type) {
        case FilterType.CheckboxList:
          return checkboxWidget(state, themeProps);
        case FilterType.RadioGroup:
          return radioGroupWidget(state, themeProps);
        case FilterType.Slider:
          return sliderWidget(state, themeProps);
        case FilterType.VericalSlider:
          return verticalSliderWidget(state, themeProps);
        case FilterType.RangeSlider:
          return rangerSliderTitleWidget(state, themeProps);
        case FilterType.VericalRangeSlider:
          return rangerVerticalSliderTitleWidget(state, themeProps);

        case FilterType.DatePicker:
          return datePickerWidget(state, themeProps);
        case FilterType.TimePicker:
          return timePickerWidget(state, themeProps);
        case FilterType.RangeDatePicker:
          return rangeDatePickerWidget(state, themeProps);

        case FilterType.RangeTimePicker:
          return Container();
        default:
          return Container();
      }
    }
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

  checkboxWidget(FilterState state, ThemeProps? themeProps) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Builder(
        builder: (context) {
          final list = state.filters[state.activeFilterIndex].filterOptions;

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
                                      _filterCubit.filterBySearch(
                                          _searchController.text);
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
                            _filterCubit.filterBySearch(_searchController.text);
                          }
                        },
                      );
                    }),
              ),
              Visibility(
                visible: list.isNotEmpty,
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
                                final item = list[index];
                                return FilterCheckboxTitle(
                                  key: UniqueKey(),
                                  checkBoxTileThemeProps:
                                      themeProps?.checkBoxTileThemeProps,
                                  selected: _filterCubit.checked(
                                    state.filters[state.activeFilterIndex]
                                        .previousApplied,
                                    item,
                                  ),
                                  title: item.filterTitle,
                                  onUpdate: (bool? value) {
                                    _filterCubit.onFilterItemCheck(item);
                                  },
                                );
                              },
                              addSemanticIndexes: true,
                              addAutomaticKeepAlives: true,
                              addRepaintBoundaries: false,
                              childCount: list.length ?? 0,
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

  radioGroupWidget(FilterState state, ThemeProps? themeProps) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Builder(
        builder: (context) {
          final list = state.filters[state.activeFilterIndex].filterOptions;

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
                                      _filterCubit.filterBySearch(
                                          _searchController.text);
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
                            _filterCubit.filterBySearch(_searchController.text);
                          }
                        },
                      );
                    }),
              ),
              Visibility(
                visible: list.isNotEmpty,
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
                                final item = list[index];
                                return FilterRadioBoxTitle(
                                  options: [item],
                                  // Use single item as an option
                                  selectedOption: _filterCubit.checked(
                                          state.filters[state.activeFilterIndex]
                                              .previousApplied,
                                          item)
                                      ? item
                                      : null,
                                  onChanged: (selected) {
                                    _filterCubit.onFilterItemCheck(item);
                                  },
                                  radioTileThemeProps:
                                      themeProps?.radioTileThemeProps,
                                );
                              },
                              addSemanticIndexes: true,
                              addAutomaticKeepAlives: true,
                              addRepaintBoundaries: false,
                              childCount: list.length ?? 0,
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

  sliderWidget(FilterState state, ThemeProps? themeProps) {
    final List<FilterItemModel>? filterOptions =
        state.filters[state.activeFilterIndex].filterOptions;
    List<FilterItemModel>? previousApplied =
        state.filters[state.activeFilterIndex].previousApplied;
    final title = state.filters[state.activeFilterIndex].title ?? "";

    final minValue = findMinValue(filterOptions!);
    final maxValue = findMaxValue(filterOptions);
    final double minGap = 1.0;
    double? values = (previousApplied == null || previousApplied.isEmpty)
        ? 0.0
        : double.tryParse("${previousApplied.first.filterKey ?? 0.0}") ?? 0.0;
    final SliderTileThemeProps? sliderTileThemeProps =
        state.filters[state.activeFilterIndex].sliderTileThemeProps;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          child: FilterSliderTitle(
            key: UniqueKey(),
            sliderTileThemeProps: sliderTileThemeProps,
            filterOptions: filterOptions,
            previousApplied: previousApplied,
            title: title,
            values: values,
            minValue: minValue!,
            maxValue: maxValue!,
            onChanged: (newValues) {
              FilterItemModel model = FilterItemModel(
                  filterKey: newValues, filterTitle: "${newValues}");
              context.read<FilterCubit>().onFilterItemCheck(model);
            },
          ),
        )
      ],
    );
  }

  verticalSliderWidget(FilterState state, ThemeProps? themeProps) {
    final filterOptions = state.filters[state.activeFilterIndex].filterOptions;
    final previousApplied =
        state.filters[state.activeFilterIndex].previousApplied;
    final title = state.filters[state.activeFilterIndex].title ?? "";

    final minValue = findMinValue(filterOptions);
    final maxValue = findMaxValue(filterOptions);
    final double minGap = 1.0;
    final double? values = (previousApplied == null || previousApplied.isEmpty)
        ? 0.0
        : double.tryParse("${previousApplied.first.filterKey}") ?? 0.0;
    final SliderTileThemeProps? sliderTileThemeProps =
        state.filters[state.activeFilterIndex].sliderTileThemeProps;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          child: FilterVerticalSliderTitle(
            key: UniqueKey(),
            sliderTileThemeProps: sliderTileThemeProps,
            filterOptions: filterOptions,
            previousApplied: previousApplied,
            title: title,
            values: values,
            minValue: minValue!,
            maxValue: maxValue!,
            onChanged: (double newValues) async {
              FilterItemModel model = FilterItemModel(
                  filterKey: newValues, filterTitle: "${newValues}");
              context.read<FilterCubit>().onFilterItemCheck(model);
            },
          ),
        )
      ],
    );
  }

  rangerSliderTitleWidget(FilterState state, ThemeProps? themeProps) {
    final filterOptions = state.filters[state.activeFilterIndex].filterOptions;
    final previousApplied =
        state.filters[state.activeFilterIndex].previousApplied;
    final title = state.filters[state.activeFilterIndex].title ?? "";
    Constants.debugLog(
        FilterWidget, "rangerSliderTitleWidget:rangerSliderTitleWidget");

    final minValue = findMinValue(filterOptions);
    final maxValue = findMaxValue(filterOptions);
    final double minGap = 1.0;
    double? minPreviousAppliedValue;
    double? maxPreviousAppliedValue;
    if (previousApplied == null && previousApplied.isEmpty) {
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
        state.filters[state.activeFilterIndex].sliderTileThemeProps;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          child: FilterRangerSliderTitle(
            key: UniqueKey(),
            sliderTileThemeProps: sliderTileThemeProps,
            filterOptions: filterOptions,
            previousApplied: previousApplied,
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
              Constants.debugLog(FilterWidget,
                  "rangerSliderTitleWidget:rangerSliderTitleWidget:onChanged:${list.toString()}");
              context.read<FilterCubit>().onFilterItemCheck(list);
            },
          ),
        )
      ],
    );
  }

  rangerVerticalSliderTitleWidget(FilterState state, ThemeProps? themeProps) {
    final filterOptions = state.filters[state.activeFilterIndex].filterOptions;
    final previousApplied =
        state.filters[state.activeFilterIndex].previousApplied;
    final title = state.filters[state.activeFilterIndex].title ?? "";
    Constants.debugLog(
        FilterWidget, "rangerSliderTitleWidget:rangerSliderTitleWidget");

    final minValue = findMinValue(filterOptions);
    final maxValue = findMaxValue(filterOptions);
    final double minGap = 1.0;
    double? minPreviousAppliedValue;
    double? maxPreviousAppliedValue;
    if (previousApplied == null && previousApplied.isEmpty) {
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
        state.filters[state.activeFilterIndex].sliderTileThemeProps;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: FilterVerticalRangerSliderTitle(
            key: UniqueKey(),
            sliderTileThemeProps: sliderTileThemeProps,
            filterOptions: filterOptions,
            previousApplied: previousApplied,
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
              Constants.debugLog(FilterWidget,
                  "rangerSliderTitleWidget:rangerSliderTitleWidget:onChanged:${list.toString()}");
              context.read<FilterCubit>().onFilterItemCheck(list);
            },
          ),
        )
      ],
    );
  }

  datePickerWidget(FilterState state, ThemeProps? themeProps) {
    final filterOptions = state.filters[state.activeFilterIndex].filterOptions;
    final previousApplied =
        state.filters[state.activeFilterIndex].previousApplied;
    final title = state.filters[state.activeFilterIndex].title ?? "";

    final DateFormat inputDateFormat =
        state.filters[state.activeFilterIndex].inputDateFormat ??
            DateFormat("dd-MM-yyyy");
    DateTime initialDate;

    final minimumDate = state.filters[state.activeFilterIndex].minimumDate ??
        DateTime(DateTime.now().year - 150, 1, 1);
    final maximumDate = state.filters[state.activeFilterIndex].maximumDate ??
        DateTime(DateTime.now().year + 150, 1, 1);
    final datePickerDateOrder =
        state.filters[state.activeFilterIndex].datePickerDateOrder ??
            DatePickerDateOrder.dmy;
    final labelText = state.filters[state.activeFilterIndex].labelText ?? "";
    final hintText = state.filters[state.activeFilterIndex].hintText ?? "";
    var backgroundColor =
        state.filters[state.activeFilterIndex].backgroundColor;
    var textButtonCancel =
        state.filters[state.activeFilterIndex].textButtonCancel;
    var textButtonOkay = state.filters[state.activeFilterIndex].textButtonOkay;

    String? initialDateValue;

    if (previousApplied == null || previousApplied.isEmpty) {
      initialDate =
          (state.filters[state.activeFilterIndex].initialDate == null ||
                  state.filters[state.activeFilterIndex].initialDate!.isEmpty)
              ? DateTime.now()
              : DateUtil.stringToDate(
                  state.filters[state.activeFilterIndex].initialDate!,
                  inputDateFormat.pattern!);
      initialDateValue = inputDateFormat.format(initialDate);
    } else {
      initialDate = DateUtil.stringToDate(
          previousApplied.first.filterKey!, inputDateFormat.pattern!);
      initialDateValue = inputDateFormat.format(initialDate);
    }
    Constants.debugLog(FilterWidget, "datePickerWidget");
    TextEditingController? textEditingController = new TextEditingController();
    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 10, bottom: 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: Text(title),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: DateTimeField(
                      format: inputDateFormat,
                      autofocus: false,
                      onShowPicker: (context, currentValue) async {
                        final date = await showDatePickerSheet(
                          context: context,
                          initialDate: initialDate,
                          pickerMode: CupertinoDatePickerMode.date,
                          dateOrder: datePickerDateOrder,
                          backgroundColor: backgroundColor ??
                              Theme.of(context).colorScheme.background,
                          maximumDate: maximumDate,
                          minimumDate: minimumDate,
                          textButtonOkay: textButtonOkay,
                          textButtonCancel: textButtonCancel,
                        );
                        return date;
                      },
                      initialValue: initialDate,
                      autovalidateMode: AutovalidateMode.disabled,
                      controller: textEditingController,
                      decoration: InputDecoration(
                        labelText: labelText,
                        hintText: hintText,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).disabledColor,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.error),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.error),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      validator: (value) {
                        return null;
                      },
                      onChanged: (DateTime? value) async {
                        if (value == null) {
                          context.read<FilterCubit>().onFilterItemCheck(null);
                        } else {
                          String? date = DateUtil.dateToString(
                              value, inputDateFormat.pattern!);
                          print("datePickerWidget:date:${date?.toString()}");

                          FilterItemModel model = FilterItemModel(
                              filterKey: date, filterTitle: "${date}");
                          context.read<FilterCubit>().onFilterItemCheck(model);
                        }
                      },
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  timePickerWidget(FilterState state, ThemeProps? themeProps) {
    final filterOptions = state.filters[state.activeFilterIndex].filterOptions;
    final previousApplied =
        state.filters[state.activeFilterIndex].previousApplied;
    final title = state.filters[state.activeFilterIndex].title ?? "";

    final DateFormat inputDateFormat =
        state.filters[state.activeFilterIndex].inputDateFormat ??
            DateFormat("hh:mm:ss aaa");

    final labelText = state.filters[state.activeFilterIndex].labelText ?? "";
    final hintText = state.filters[state.activeFilterIndex].hintText ?? "";
    var backgroundColor =
        state.filters[state.activeFilterIndex].backgroundColor;
    var minuteInterval = state.filters[state.activeFilterIndex].minuteInterval;
    var use24hFormat = state.filters[state.activeFilterIndex].use24hFormat;
    var textButtonCancel =
        state.filters[state.activeFilterIndex].textButtonCancel;
    var textButtonOkay = state.filters[state.activeFilterIndex].textButtonOkay;

    DateTime? initialDate;
    TimeOfDay? initialTime;
    String? initialTimeValue;

    if (previousApplied == null || previousApplied.isEmpty) {
      initialDate =
          (state.filters[state.activeFilterIndex].initialDate == null ||
                  state.filters[state.activeFilterIndex].initialDate!.isEmpty)
              ? DateTime.now()
              : DateUtil.stringToDate(
                  state.filters[state.activeFilterIndex].initialDate!,
                  inputDateFormat.pattern!);
      initialTime = DateUtil.dateTimeToTimeOfDay(initialDate);
      initialTimeValue = inputDateFormat.format(initialDate);
    } else {
      initialDate = DateUtil.stringToDate(
          previousApplied.first.filterKey!, inputDateFormat.pattern!);
      initialTime = DateUtil.dateTimeToTimeOfDay(initialDate);
      initialTimeValue = inputDateFormat.format(initialDate);
    }

    Constants.debugLog(FilterWidget, "timePickerWidget");
    TextEditingController? textEditingController = new TextEditingController();

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 10, bottom: 0.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: Text(title),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10.0, top: 10.0, bottom: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: DateTimeField(
                      format: inputDateFormat,
                      autofocus: false,
                      onShowPicker: (context, currentValue) async {
                        final time = await showTimePickerSheet(
                            context: context,
                            initialTime: initialTime,
                            backgroundColor: backgroundColor ??
                                Theme.of(context).colorScheme.background,
                            minuteInterval: minuteInterval ?? 1,
                            use24hFormat: use24hFormat,
                            textButtonOkay: textButtonOkay,
                            textButtonCancel: textButtonCancel);
                        return DateTimeField.convert(time);
                      },
                      onChanged: (value) {
                        print("timePickerWidget:${value.toString()}");
                      },
                      initialValue: initialDate,
                      autovalidateMode: AutovalidateMode.disabled,
                      controller: textEditingController,
                      decoration: InputDecoration(
                        labelText: labelText,
                        hintText: hintText,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).disabledColor,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.error),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.error),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).unfocus();
                      },
                      validator: (value) {
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Future<DateTimeRange?> showDateRangePickerDialog({
    required BuildContext context,
    DateTimeRange? initialDateRange,
    DateTime? firstDate,
    DateTime? lastDate,
    String? cancelText,
    String? confirmText,
    String? helpText,
  }) async {
    return showDateRangePicker(
      context: context,
      initialDateRange: initialDateRange,
      firstDate: firstDate ?? DateTime(DateTime.now().year - 5),
      lastDate: lastDate ?? DateTime(DateTime.now().year + 5),
      cancelText: cancelText,
      confirmText:confirmText ,
      helpText: helpText,
    );
  }

  rangeDatePickerWidget(FilterState state, ThemeProps? themeProps) {
    final filterOptions = state.filters[state.activeFilterIndex].filterOptions;
    final previousApplied = state.filters[state.activeFilterIndex].previousApplied;

    final title = state.filters[state.activeFilterIndex].title ?? "";

    final DateFormat inputDateFormat =
        state.filters[state.activeFilterIndex].inputDateFormat ??
            DateFormat("dd-MM-yyyy");

    final minimumDate = state.filters[state.activeFilterIndex].minimumDate ??
        DateTime(DateTime.now().year - 150, 1, 1);
    final maximumDate = state.filters[state.activeFilterIndex].maximumDate ??
        DateTime(DateTime.now().year + 150, 1, 1);

    DateTimeRange? initialDateRange;
    if (previousApplied == null || previousApplied.isEmpty) {
      final initialDate = state.filters[state.activeFilterIndex].initialDate;
      if (initialDate != null && initialDate.isNotEmpty) {
        final startDate = DateUtil.stringToDate(initialDate, inputDateFormat.pattern!);
        initialDateRange = DateTimeRange(start: startDate, end: startDate.add(Duration(days: 1)));
      } else {
        final now = DateTime.now();
        initialDateRange = DateTimeRange(start: now, end: now.add(Duration(days: 1)));
      }
    } else {
      final startDate = DateUtil.stringToDate(previousApplied.first.filterKey, inputDateFormat.pattern!);
      final endDate = DateUtil.stringToDate(previousApplied.last.filterKey, inputDateFormat.pattern!);
      initialDateRange = DateTimeRange(start: startDate, end: endDate);
    }

    TextEditingController textEditingController = TextEditingController();

    return StatefulBuilder(
      builder: (context, setState) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 10, bottom: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: Text(title),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0, top: 0.0, bottom: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        final DateTimeRange? picked = await showDateRangePickerDialog(
                          context: context,
                          initialDateRange: initialDateRange,
                          firstDate: minimumDate,
                          lastDate: maximumDate,
                        );
                        if (picked != null && picked != initialDateRange) {
                          setState(() {
                            initialDateRange = picked;
                            textEditingController.text = "${inputDateFormat.format(picked.start)} - ${inputDateFormat.format(picked.end)}";
                          });
                          // Handle the selected date range here
                        }
                      },
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: textEditingController,
                          decoration: InputDecoration(
                            labelText: "Select Date Range",
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _searchValueNotifier.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
