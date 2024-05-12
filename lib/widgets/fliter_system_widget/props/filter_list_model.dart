import 'package:coozy_cafe/widgets/fliter_system_widget/props/filter_item_model.dart';
import 'package:coozy_cafe/widgets/fliter_system_widget/props/filter_props.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

/// Enumeration for different types of filter options
enum FilterType {
  CheckboxList,
  RadioGroup,
  Slider,
  VericalSlider,
  RangeSlider,
  VericalRangeSlider,
  RangeDateTimePicker,
  RangeDateVerticalTimePicker,
  DatePicker,
  TimePicker,
  RangeDatePicker,
  RangeTimePicker,
  RangeVerticalTimePicker
}

/// Filter option model
class FilterListModel extends Equatable {
  final String? title;
  final String filterKey;
  final List<FilterItemModel> filterOptions;
  final List<FilterItemModel> previousApplied;
  FilterType? type = FilterType.CheckboxList;
  final SliderTileThemeProps? sliderTileThemeProps;
  DateTime? firstDate;
  DateTime? lastDate;
  String? initialDate;

  DateTime? minimumDate;
  DateTime? maximumDate;
  DatePickerDateOrder? datePickerDateOrder;

  DateFormat? inputDateFormat;

  FilterListModel({
    this.title,
    required this.filterKey,
    required this.filterOptions,
    required this.previousApplied,
    required this.type,
    this.inputDateFormat,
    this.initialDate,
    this.minimumDate,
    this.maximumDate,
    this.datePickerDateOrder,
    this.sliderTileThemeProps,
  });

  FilterListModel copyWith(
      {List<FilterItemModel>? filterOptions,
      List<FilterItemModel>? previousApplied,
      String? title,
      String? filterKey,
      FilterType? type,
      SliderTileThemeProps? sliderTileThemeProps,
      DateFormat? inputDateFormat,
      String? initialDate,
      DateTime? minimumDate,
      DateTime? maximumDate,
      DatePickerDateOrder? datePickerDateOrder}) {
    return FilterListModel(
        title: title ?? this.title,
        type: type ?? this.type,
        filterKey: filterKey ?? this.filterKey,
        filterOptions: filterOptions ?? this.filterOptions,
        previousApplied: previousApplied ?? this.previousApplied,
        sliderTileThemeProps: sliderTileThemeProps ?? this.sliderTileThemeProps,
        inputDateFormat: inputDateFormat ?? this.inputDateFormat,
        initialDate: initialDate ?? this.initialDate,
        minimumDate: minimumDate ?? this.minimumDate,
        maximumDate: maximumDate ?? this.maximumDate,
        datePickerDateOrder: datePickerDateOrder ?? this.datePickerDateOrder);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
        title,
        filterKey,
        type,
        filterOptions,
        previousApplied,
        inputDateFormat,
        datePickerDateOrder,
        initialDate,
        minimumDate,
        maximumDate,
      ];

  Map<String, dynamic> toMap() {
    return ({
      'title': title,
      'filter_key': filterKey,
      'type': type.toString().split('.').last,
      'previous_applied': previousApplied.map((e) => e.toMap()).toList(),
      'filter_options': filterOptions.map((e) => e.toMap()).toList(),
      'SliderTileThemeProps': sliderTileThemeProps.toString(),
      'inputDateFormat': inputDateFormat.toString(),
      'initialDate': initialDate.toString(),
      'minimumDate': minimumDate.toString(),
      'maximumDate': maximumDate.toString(),
    });
  }
}
