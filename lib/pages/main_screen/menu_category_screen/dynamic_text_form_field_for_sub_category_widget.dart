import 'package:coozy_cafe/AppLocalization.dart';
import 'package:coozy_cafe/utlis/components/string_value.dart';
import 'package:flutter/material.dart';

class DynamicTextFormFieldForSubCategoryWidget extends StatefulWidget {
  final String? initialValue;
  final void Function(String) onChanged;
  final VoidCallback  onDelete;

  const DynamicTextFormFieldForSubCategoryWidget(
      {Key? key,
      this.initialValue,
      required this.onChanged,
      required this.onDelete})
      : super(key: key);

  @override
  _DynamicTextFormFieldForSubCategoryWidgetState createState() =>
      _DynamicTextFormFieldForSubCategoryWidgetState();
}

class _DynamicTextFormFieldForSubCategoryWidgetState
    extends State<DynamicTextFormFieldForSubCategoryWidget> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = new TextEditingController(text: "");
    _controller.text = widget.initialValue ?? "";
    _focusNode = new FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      focusNode: _focusNode,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)
                ?.translate(StringValue.add_new_menu_sub_category_label_text) ??
            "SubCategory Name",
        hintText: AppLocalizations.of(context)
                ?.translate(StringValue.add_new_menu_sub_category_hint_text) ??
            "Enter your subCategory name",
        suffixIcon: IconButton(
          onPressed: widget.onDelete,
          icon: const Icon(Icons.delete),
        ),
      ),
      onFieldSubmitted: (String value) {
        FocusScope.of(context).unfocus();
      },
      validator: (v) {
        if (v == null || v.trim().isEmpty)
          return AppLocalizations.of(context)?.translate(
                  StringValue.add_new_menu_sub_category_error_text) ??
              'Enter your sub-category name';
        return null;
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
