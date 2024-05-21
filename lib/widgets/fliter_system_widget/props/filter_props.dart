import 'package:coozy_cafe/widgets/fliter_system_widget/props/applied_filter_model.dart';
import 'package:coozy_cafe/widgets/fliter_system_widget/props/filter_list_model.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';

/*
This class represents the properties regarding how filters should look.
It contains details like close icon, filter data, theme data, and event functions
*/

class FilterProps {
  final List<FilterListModel> filters;
  final String? title;
  final ThemeProps? themeProps;
  final Icon? closeIcon;
  final bool? showCloseIcon;
  final Function? onCloseTap;

  final Function(List<AppliedFilterModel> appliedFilterModel)? onFilterChange;

  FilterProps({
    this.closeIcon,
    this.onCloseTap,
    this.showCloseIcon,
    required this.filters,
    this.onFilterChange,
    this.title,
    this.themeProps,
  });
}

class ThemeProps {
  final TextStyle? titleStyle;
  final Color? titleColor;
  final Color? activeFilterHeaderColor;
  final Color? inActiveFilterHeaderColor;
  final Color? inActiveFilterItemBackgroundColor;
  final TextStyle? activeFilterHeaderStyle;
  final TextStyle? activeFilterTextStyle;
  final Color? activeFilterTextColor;
  final Color? inActiveFilterTextColor;
  final TextStyle? inActiveFilterTextStyle;
  final Color? resetButtonColor;
  final TextStyle? resetButtonStyle;
  final Color? submitButtonColor;
  final TextStyle? submitButtonStyle;
  final Widget? divider;
  final Color? dividerColor;
  final double? dividerThickness;
  final SearchBarViewProps? searchBarViewProps;
  final CheckBoxTileThemeProps? checkBoxTileThemeProps;
  final RadioTileThemeProps? radioTileThemeProps;
  final SliderTileThemeProps? sliderTileThemeProps;

  ThemeProps({
    this.searchBarViewProps,
    this.titleStyle,
    this.titleColor,
    this.inActiveFilterItemBackgroundColor,
    this.resetButtonColor,
    this.submitButtonColor,
    this.divider,
    this.dividerColor,
    this.inActiveFilterHeaderColor,
    this.activeFilterHeaderColor,
    this.activeFilterTextStyle,
    this.activeFilterTextColor,
    this.inActiveFilterTextColor,
    this.inActiveFilterTextStyle,
    this.activeFilterHeaderStyle,
    this.dividerThickness,
    this.resetButtonStyle,
    this.submitButtonStyle,
    this.checkBoxTileThemeProps,
    this.radioTileThemeProps,
    this.sliderTileThemeProps,
  });
}

class CheckBoxTileThemeProps {
  final Color? activeCheckBoxColor;
  final Color? inActiveCheckBoxColor;
  final Color? checkboxTitleColor;
  final TextStyle? checkboxTitleStyle;
  final Color? tileColor;

  CheckBoxTileThemeProps({
    this.activeCheckBoxColor,
    this.inActiveCheckBoxColor,
    this.checkboxTitleColor,
    this.checkboxTitleStyle,
    this.tileColor,
  });
}

class RadioTileThemeProps {
  final Color? activeRadioColor;
  final Color? inActiveRadioColor;
  final TextStyle? radioTitleStyle;
  final Color? radioTitleColor;
  final Color? tileColor;

  const RadioTileThemeProps({
    this.activeRadioColor,
    this.inActiveRadioColor,
    this.radioTitleStyle,
    this.radioTitleColor,
    this.tileColor,
  });
}

class SliderTileThemeProps {
  SfRangeSliderThemeData? sliderThemeData;
  String? tooltip_prefix_str;
  String? tooltip_suffix_str;
  String? label_prefix_str;
  String? label_suffix_str;
  double? stepSize;
  int? fractionDigits;

  SliderTileThemeProps(
      {this.sliderThemeData,
      this.label_prefix_str,
      this.label_suffix_str,
      this.tooltip_prefix_str,
      this.tooltip_suffix_str,
      this.fractionDigits,
      this.stepSize});

  @override
  String toString() {
    return 'SliderTileThemeProps{sliderThemeData: $sliderThemeData, tooltip_prefix_str: $tooltip_prefix_str, tooltip_suffix_str: $tooltip_suffix_str, label_prefix_str: $label_prefix_str, label_suffix_str: $label_suffix_str, stepSize: $stepSize, fractionDigits: $fractionDigits}';
  }
}

class SearchBarViewProps {
  OutlineInputBorder? inputBorder;
  Color? fillColor;
  Color? clearIconColor;
  Color? searchIconColor;
  Widget? clearIcon;
  Widget? searchIcon;
  bool? filled;
  String? searchHint;
  TextStyle? textStyle;
  TextStyle? hintStyle;

  SearchBarViewProps({
    this.clearIconColor,
    this.searchIconColor,
    this.clearIcon,
    this.searchIcon,
    this.inputBorder,
    this.fillColor,
    this.filled,
    this.searchHint,
    this.hintStyle,
    this.textStyle,
  });
}
