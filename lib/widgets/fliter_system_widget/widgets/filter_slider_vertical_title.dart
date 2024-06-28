import 'package:coozy_the_cafe/utlis/components/constants.dart';
import 'package:coozy_the_cafe/widgets/fliter_system_widget/props/filter_item_model.dart';
import 'package:coozy_the_cafe/widgets/fliter_system_widget/props/filter_props.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class FilterVerticalSliderTitle extends StatefulWidget {
  final List<FilterItemModel> filterOptions;
  final List<FilterItemModel> previousApplied;
  final String title;
  final double? values;
  final double minValue;
  final double maxValue;
  final Function(double) onChanged;
  final SliderTileThemeProps? sliderTileThemeProps;

  const FilterVerticalSliderTitle({
    Key? key,
    required this.filterOptions,
    required this.previousApplied,
    required this.title,
    required this.values,
    required this.minValue,
    required this.maxValue,
    required this.onChanged,
    this.sliderTileThemeProps,
  }) : super(key: key);

  @override
  _FilterVerticalSliderTitleState createState() =>
      _FilterVerticalSliderTitleState();
}

class _FilterVerticalSliderTitleState extends State<FilterVerticalSliderTitle> {
  double? _values;

  @override
  void initState() {
    super.initState();
    _values = widget.values;
  }

  @override
  void didUpdateWidget(FilterVerticalSliderTitle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.values != oldWidget.values) {
      setState(() {
        _values = widget.values ?? widget.minValue;
      });
    }
    Constants.debugLog(FilterVerticalSliderTitle, "didUpdateWidget called");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Constants.debugLog(
        FilterVerticalSliderTitle, "didChangeDependencies called");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Text(widget.title),
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(right: 20, left: 20, top: 10),
                  child: Visibility(
                    visible:
                        widget.sliderTileThemeProps?.sliderThemeData != null,
                    replacement: slider(),
                    child: SfRangeSliderTheme(
                      data: widget.sliderTileThemeProps?.sliderThemeData ??
                          SfRangeSliderThemeData(),
                      child: slider(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 5,
        ),
      ],
    );
  }

  slider() {
    return StatefulBuilder(builder: (context, state) {
      return SfSlider.vertical(
        tooltipTextFormatterCallback: (value, formattedText) =>
            '${(widget.sliderTileThemeProps?.tooltip_prefix_str == null || widget.sliderTileThemeProps!.tooltip_prefix_str!.isEmpty) ? "" : "${widget.sliderTileThemeProps?.tooltip_prefix_str.toString()} "}${double.tryParse("$value")?.toStringAsFixed(widget.sliderTileThemeProps?.fractionDigits ?? 0) ?? 0}${(widget.sliderTileThemeProps?.tooltip_suffix_str == null || widget.sliderTileThemeProps!.tooltip_suffix_str!.isEmpty) ? "" : " ${widget.sliderTileThemeProps?.tooltip_suffix_str}"}',
        min: widget.minValue,
        max: widget.maxValue,
        value: _values ?? 0.0,
        stepSize: widget.sliderTileThemeProps?.stepSize ?? 1.0,
        showLabels: true,
        enableTooltip: true,
        labelFormatterCallback: (value, formattedText) {
          return '${(widget.sliderTileThemeProps?.label_prefix_str == null || widget.sliderTileThemeProps!.label_prefix_str!.isEmpty) ? "" : "${widget.sliderTileThemeProps?.label_prefix_str.toString()} "}${double.tryParse("$value")?.toStringAsFixed(widget.sliderTileThemeProps?.fractionDigits ?? 0) ?? 0}${(widget.sliderTileThemeProps?.label_suffix_str == null || widget.sliderTileThemeProps!.label_suffix_str!.isEmpty) ? "" : " ${widget.sliderTileThemeProps?.label_suffix_str.toString()}"}';
        },
        onChanged: (newValues) async {
          Constants.debugLog(
              FilterVerticalSliderTitle, "onChanged:newValues:${newValues}");
          _values = newValues;
          state(() {});
          setState(() {});
          widget.onChanged(newValues ?? 0);
        },
      );
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
