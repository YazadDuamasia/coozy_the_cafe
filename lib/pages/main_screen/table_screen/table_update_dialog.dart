import 'package:coozy_cafe/AppLocalization.dart';
import 'package:coozy_cafe/model/table_info_model.dart';
import 'package:coozy_cafe/utlis/components/string_value.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class TableUpdateDialog extends StatefulWidget {
  final TableInfoModel currentTableName;
  final Function(TableInfoModel) onUpdate;

  const TableUpdateDialog(
      {super.key, required this.currentTableName, required this.onUpdate});

  @override
  _TableUpdateDialogState createState() => _TableUpdateDialogState();
}

class _TableUpdateDialogState extends State<TableUpdateDialog> {
  TextEditingController? _tableNameController;
  FocusNode? _tableNameFocusNode;
  TextEditingController? _nosOfChairsController;
  FocusNode? _nosOfChairsFocusNode;
  late TextEditingController _hexColorTextEditingController;
  FocusNode? _hexColorFocusNode;

  Color _selectedColor = Colors.white;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _tableNameController =
        TextEditingController(text: widget.currentTableName.name);
    _tableNameFocusNode = FocusNode();
    _nosOfChairsFocusNode = FocusNode();
    _nosOfChairsController =
        TextEditingController(text: "${widget.currentTableName.nosOfChairs}");
    _hexColorTextEditingController =
        TextEditingController(text: "${widget.currentTableName.colorValue}");
    _hexColorFocusNode = FocusNode();
    _selectedColor = Color(
        int.parse(widget.currentTableName.colorValue ?? "FFFFFF", radix: 16) |
            0xFF000000);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Update Table Name'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _tableNameController,
                    focusNode: _tableNameFocusNode,
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
                      FocusScope.of(context)
                          .requestFocus(_nosOfChairsFocusNode);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    focusNode: _nosOfChairsFocusNode,
                    controller: _nosOfChairsController,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelText: AppLocalizations.of(context)?.translate(
                              StringValue.table_nos_of_chairs_label_text) ??
                          'Nos Of Chairs per Table',
                      hintText: AppLocalizations.of(context)?.translate(
                              StringValue.table_nos_of_chairs_hint_text) ??
                          'Enter number of chairs',
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onFieldSubmitted: (String value) {
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: ColorPicker(
                          pickerColor: _selectedColor,
                          onColorChanged: (Color color) {
                            setState(() {
                              _selectedColor = color;
                            });
                          },
                          enableAlpha: true,
                          pickerAreaHeightPercent: 0.35,
                          hexInputController: _hexColorTextEditingController,
                          paletteType: PaletteType.hsvWithHue,
                          displayThumbColor: true,
                          portraitOnly: true,
                          labelTypes: const [],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    focusNode: _hexColorFocusNode,
                    controller: _hexColorTextEditingController,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)?.translate(
                          StringValue.color_indicator_table_label_text) ??
                          'Color Indicator for Table',
                      hintText: AppLocalizations.of(context)?.translate(
                          StringValue.color_indicator_table_hint_text) ??
                          'Select an unique color',
                    ),
                    inputFormatters: [
                      UpperCaseTextFormatter(),
                      FilteringTextInputFormatter.allow(
                          RegExp(kValidHexPattern)),
                    ],
                    maxLength: 9,
                    onFieldSubmitted: (String value) {
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
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
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              String tableName = _tableNameController!.text;
              String color = _hexColorTextEditingController.text;
              int? nosOfChairs =
                  int.tryParse(_nosOfChairsController!.text.toString());
              TableInfoModel tableInfoModel = TableInfoModel(
                  id: widget.currentTableName.id,
                  name: tableName,
                  nosOfChairs: nosOfChairs ?? 4,
                  colorValue: color,
                  sortOrderIndex: widget.currentTableName.sortOrderIndex);
              widget.onUpdate(tableInfoModel);
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
