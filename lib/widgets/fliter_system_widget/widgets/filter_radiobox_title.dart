/*
This piece of code for that retrun the user interface for CheckboxTileView names as FilterCheckboxTitle.
*/

import 'package:coozy_cafe/widgets/fliter_system_widget/filter_style_mixin.dart';
import 'package:coozy_cafe/widgets/fliter_system_widget/props/filter_item_model.dart';
import 'package:coozy_cafe/widgets/fliter_system_widget/props/filter_props.dart';
import 'package:coozy_cafe/widgets/fliter_system_widget/widgets/filter_text.dart';
import 'package:flutter/material.dart';

class FilterRadioBoxTitle extends StatelessWidget with FilterStyleMixin {
  final List<FilterItemModel> options;
  final FilterItemModel? selectedOption;
  final void Function(FilterItemModel?)? onChanged;

  final RadioTileThemeProps? radioTileThemeProps;

  const FilterRadioBoxTitle({
    Key? key,
    required this.options,
    this.selectedOption,
    this.onChanged,
    this.radioTileThemeProps,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: options.map((FilterItemModel option) {
        // return ListTile(
        //   title: Text(option.filterTitle ?? ''),
        //   leading: Radio<FilterItemModel>(
        //     value: option,
        //     groupValue: selectedOption,
        //     onChanged: onChanged,
        //   ),
        // );
        return RadioListTile<FilterItemModel>(
          title: FilterText(
            title: option.filterTitle ?? '',
            style: radioTileThemeProps?.radioTitleStyle ??
                getTitleTheme1(context)?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: radioTileThemeProps?.radioTitleColor,
                ),
          ),
          value: option,
          groupValue: selectedOption,
          onChanged: onChanged,
          tileColor: radioTileThemeProps?.tileColor,
          activeColor: radioTileThemeProps?.activeRadioColor,
          materialTapTargetSize: MaterialTapTargetSize.padded,
        );
      }).toList(),
    );
  }
}
