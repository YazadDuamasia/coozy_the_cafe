import 'package:coozy_the_cafe/AppLocalization.dart';
import 'package:coozy_the_cafe/utlis/components/string_value.dart';
import 'package:flutter/material.dart';

class DynamicTextFormFieldForEditSubCategoryWidget extends StatefulWidget {
  final String? initialValue;
  final void Function(String) onChanged;
  final VoidCallback onDelete;
  final int  index;

  const DynamicTextFormFieldForEditSubCategoryWidget(
      {super.key,
      this.initialValue,
      required this.index,
      required this.onChanged,
      required this.onDelete});

  @override
  _DynamicTextFormFieldForEditSubCategoryWidgetState createState() =>
      _DynamicTextFormFieldForEditSubCategoryWidgetState();
}

class _DynamicTextFormFieldForEditSubCategoryWidgetState
    extends State<DynamicTextFormFieldForEditSubCategoryWidget> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = new TextEditingController(text: "");
    _controller.text = widget.initialValue ?? "";
    _focusNode =new  FocusNode()..requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: UniqueKey(),
      controller: _controller,
      focusNode: _focusNode,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.never,
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
        if (v == null || v.trim().isEmpty) {
          return AppLocalizations.of(context)?.translate(
                  StringValue.add_new_menu_sub_category_error_text) ??
              'Enter your sub-category name';
        }
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
