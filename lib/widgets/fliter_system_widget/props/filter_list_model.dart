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
  String? labelText;
  String? hintText;
  DateTime? minimumDate;
  DateTime? maximumDate;
  DatePickerDateOrder? datePickerDateOrder;
  DateFormat? inputDateFormat;
  Color? backgroundColor;
  int? minuteInterval;
  bool? use24hFormat;
  String? textButtonCancel;
  String? textButtonOkay;
  String? helpText;

  FilterListModel({
    this.title,
    required this.filterKey,
    required this.filterOptions,
    required this.previousApplied,
    required this.type,
    this.inputDateFormat,
    this.labelText,
    this.hintText,
    this.initialDate,
    this.minimumDate,
    this.maximumDate,
    this.datePickerDateOrder,
    this.sliderTileThemeProps,
    this.backgroundColor,
    this.minuteInterval,
    this.use24hFormat,
    this.textButtonCancel,
    this.textButtonOkay,
    this.helpText,
  });

  FilterListModel copyWith(
      {List<FilterItemModel>? filterOptions,
      List<FilterItemModel>? previousApplied,
      String? title,
      String? labelText,
      String? hintText,
      String? filterKey,
      FilterType? type,
      SliderTileThemeProps? sliderTileThemeProps,
      DateFormat? inputDateFormat,
      String? initialDate,
      DateTime? minimumDate,
      DateTime? maximumDate,
      Color? backgroundColor,
      int? minuteInterval,
      bool? use24hFormat,
      String? textButtonCancel,
      String? textButtonOkay,
      String? helpText,
      DatePickerDateOrder? datePickerDateOrder}) {
    return FilterListModel(
        title: title ?? this.title,
        labelText: labelText ?? this.labelText,
        hintText: hintText ?? this.hintText,
        type: type ?? this.type,
        filterKey: filterKey ?? this.filterKey,
        filterOptions: filterOptions ?? this.filterOptions,
        previousApplied: previousApplied ?? this.previousApplied,
        sliderTileThemeProps: sliderTileThemeProps ?? this.sliderTileThemeProps,
        inputDateFormat: inputDateFormat ?? this.inputDateFormat,
        initialDate: initialDate ?? this.initialDate,
        minimumDate: minimumDate ?? this.minimumDate,
        maximumDate: maximumDate ?? this.maximumDate,
        backgroundColor: backgroundColor ?? this.backgroundColor,
        minuteInterval: minuteInterval ?? this.minuteInterval,
        use24hFormat: use24hFormat ?? this.use24hFormat,
        textButtonCancel: textButtonCancel ?? this.textButtonCancel,
        textButtonOkay: textButtonOkay ?? this.textButtonOkay,
        helpText: helpText ?? this.helpText,
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
        hintText,
        labelText,
        backgroundColor,
        minuteInterval,
        use24hFormat,
        helpText,
        textButtonCancel,
        textButtonOkay
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
      'labelText': labelText,
      'hintText': hintText,
      'backgroundColor': backgroundColor,
      'minuteInterval': minuteInterval,
      'use24hFormat': use24hFormat,
      'textButtonCancel': textButtonCancel,
      'helpText': helpText,
      'textButtonOkay': textButtonOkay
    });
  }
}
