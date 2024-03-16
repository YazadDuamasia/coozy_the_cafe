import 'package:coozy_cafe/AppLocalization.dart';
import 'package:coozy_cafe/model/sub_category.dart';
import 'package:coozy_cafe/model/table_info_model.dart';
import 'package:coozy_cafe/utlis/components/string_value.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class MenuAllSubCategoryUpdateDialog extends StatefulWidget {
  final SubCategory currentSubCategory;
  final Function(SubCategory) onUpdate;

  const MenuAllSubCategoryUpdateDialog(
      {super.key, required this.currentSubCategory, required this.onUpdate});

  @override
  _MenuAllSubCategoryUpdateDialogState createState() =>
      _MenuAllSubCategoryUpdateDialogState();
}

class _MenuAllSubCategoryUpdateDialogState
    extends State<MenuAllSubCategoryUpdateDialog> {
  TextEditingController? _subCategoryNameController;
  FocusNode? _subCategoryNameFocusNode;
  bool? isActive = false;
  final _formKey = GlobalKey<FormState>();
  List<bool> isSelected = [false, true];

  @override
  void initState() {
    super.initState();
    _subCategoryNameController =
        TextEditingController(text: widget.currentSubCategory.name);
    _subCategoryNameFocusNode = FocusNode();
    isActive = widget.currentSubCategory.isActive == 1 ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Update Sub-category',
          style: Theme.of(context).textTheme.bodyLarge),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _subCategoryNameController,
                    focusNode: _subCategoryNameFocusNode,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelText: AppLocalizations.of(context)
                              ?.translate(StringValue.table_name_label_text) ??
                          'Table Name',
                      hintText: AppLocalizations.of(context)
                              ?.translate(StringValue.table_name_hint_text) ??
                          'Enter table name like Table1',
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return AppLocalizations.of(context)?.translate(
                                StringValue.table_name_error_text) ??
                            "Table name is required.";
                      } else {
                        return null;
                      }
                    },
                    onFieldSubmitted: (String value) {
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Is Active:",
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(
                  width: 5,
                ),
                Expanded(
                  child: ToggleButtons(
                    isSelected: isSelected,
                    onPressed: (int index) {
                      setState(() {
                        for (int buttonIndex = 0;
                            buttonIndex < isSelected.length;
                            buttonIndex++) {
                          if (buttonIndex == index) {
                            isSelected[buttonIndex] = true;
                          } else {
                            isSelected[buttonIndex] = false;
                          }
                        }
                      });
                    },
                    textStyle: Theme.of(context).textTheme.bodyMedium,
                    renderBorder: true,
                    borderColor: Theme.of(context).colorScheme.primary,
                    selectedBorderColor: Theme.of(context).colorScheme.primary,
                    borderWidth: 1,
                    constraints: BoxConstraints(minHeight: 30,maxHeight: 30),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    borderRadius: BorderRadius.circular(10),
                    children: const <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text('Active'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text('Deactivate'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          child: Text(AppLocalizations.of(context)
                  ?.translate(StringValue.common_cancel) ??
              "cancel"),
        ),
        TextButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              String name = _subCategoryNameController!.text;
              SubCategory model = SubCategory(
                categoryId: widget.currentSubCategory.categoryId,
                id: widget.currentSubCategory.id,
                name: name,
                createdDate: DateTime.now().toUtc().toIso8601String(),
              );
              widget.onUpdate(model);
            }
          },
          child: Text(AppLocalizations.of(context)
                  ?.translate(StringValue.common_update) ??
              "Update"),
        ),
      ],
    );
  }
}
