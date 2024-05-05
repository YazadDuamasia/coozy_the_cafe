/// Main widget for filtering data
/// Required parametter is FilterProps

import 'package:coozy_cafe/utlis/utlis.dart';
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
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      child: const Filter(),
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
      listener: (context, state) {
        // setState(() {});
      },
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
        /*  case FilterType.VericalSlider:
          return verticalSliderWidget(state, themeProps);
        case FilterType.RangeSlider:
          return rangerSliderTitleWidget(state, themeProps);
        case FilterType.VericalRangeSlider:
          return rangerVerticalSliderTitleWidget(state, themeProps);*/
        case FilterType.TimePicker:
          return Container();
        case FilterType.RangeDatePicker:
          return Container();
        case FilterType.DatePicker:
          return Container();
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
            sliderTileThemeProps: themeProps!.sliderTileThemeProps,
            filterOptions: filterOptions,
            previousApplied: previousApplied,
            title: title,
            values: values,
            minValue: minValue!,
            maxValue: maxValue!,
        /*    onChanged: (newValues) async {
              FilterItemModel model = FilterItemModel(
                  filterKey: newValues, filterTitle: "${newValues}");
              context.read<FilterCubit>().onFilterItemCheck(model);
            },*/
          ),
        )
      ],
    );
  }
/*
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
*/

  @override
  void dispose() {
    _searchValueNotifier.dispose();
    _searchController.dispose();
    super.dispose();
  }
}
