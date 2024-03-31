import 'package:coozy_cafe/widgets/fliter_system_widget/props/applied_filter_model.dart';
import 'package:coozy_cafe/widgets/fliter_system_widget/props/filter_list_model.dart';
import 'package:flutter/material.dart';

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

  ThemeProps({
    this.searchBarViewProps,
    this.titleStyle,
    this.titleColor,
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
    this.checkBoxTileThemeProps,
    this.dividerThickness,
    this.resetButtonStyle,
    this.submitButtonStyle,
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

class SearchBarViewProps {
  final OutlineInputBorder? inputBorder;
  final Color? fillColor;
  final Color? clearIconColor;
  final Color? searchIconColor;
  final Widget? clearIcon;
  final Widget? searchIcon;
  final bool? filled;
  final String? searchHint;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;

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
