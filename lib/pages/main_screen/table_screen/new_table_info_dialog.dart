import 'package:coozy_cafe/AppLocalization.dart';
import 'package:coozy_cafe/model/table_info_model.dart';
import 'package:coozy_cafe/utlis/components/string_value.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class NewTableDialog extends StatefulWidget {
  final Function(TableInfoModel) onCreate;

  const NewTableDialog({super.key, required this.onCreate});

  @override
  _NewTableDialogState createState() => _NewTableDialogState();
}

class _NewTableDialogState extends State<NewTableDialog> {
  late TextEditingController _tableNameController;
  FocusNode? _tableNameFocusNode;
  late TextEditingController _nosOfChairsController;
  FocusNode? _nosOfChairsFocusNode;
  late TextEditingController _hexColorTextEditingController;
  FocusNode? _hexColorFocusNode;

  Color _selectedColor = Colors.white;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _hexColorTextEditingController = TextEditingController(text: 'FFFFFFFF');
    _hexColorFocusNode = FocusNode();
    _tableNameController = TextEditingController(text: "");
    _tableNameFocusNode = FocusNode();
    _nosOfChairsFocusNode = FocusNode();
    _nosOfChairsController = TextEditingController(text: "");
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(10.0), // Adjust the value to reduce roundness
      ),
      titlePadding: EdgeInsets.only(top: 10, bottom: 0, right: 24, left: 24),
      actionsPadding: EdgeInsets.zero,
      title: Text(AppLocalizations.of(context)
              ?.translate(StringValue.add_new_table_title) ??
          'Create New Table'),
      content: SingleChildScrollView(
        child: Form(
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
                        labelText: AppLocalizations.of(context)?.translate(
                                StringValue.table_name_label_text) ??
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
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)?.translate(
                                StringValue.table_nos_of_chairs_label_text) ??
                            'Nos Of Chairs per Table',
                        hintText: AppLocalizations.of(context)?.translate(
                                StringValue.table_nos_of_chairs_hint_text) ??
                            'Enter number of chairs',
                      ),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onFieldSubmitted: (String value) {
                        FocusScope.of(context).requestFocus(_hexColorFocusNode);
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
                        FocusScope.of(context).requestFocus(FocusNode());
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
              String tableName = _tableNameController.text;
              String color = _hexColorTextEditingController.text;

              int? nosOfChairs =
                  int.tryParse(_nosOfChairsController.text.toString());
              TableInfoModel tableInfoModel = TableInfoModel(
                  name: tableName,
                  nosOfChairs: nosOfChairs ?? 4,
                  colorValue: color);
              widget.onCreate(tableInfoModel);
            }
          },
          child: Text(AppLocalizations.of(context)
                  ?.translate(StringValue.common_submit) ??
              "Submit"),
        ),
      ],
    );
  }
}
