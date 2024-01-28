import 'package:coozy_cafe/AppLocalization.dart';
import 'package:coozy_cafe/model/table_info_model.dart';
import 'package:coozy_cafe/utlis/components/string_value.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
                      labelText: AppLocalizations.of(context)?.translate(
                              StringValue.table_nos_of_chairs_label_text) ??
                          'Nos Of Chairs per Table',
                      hintText: AppLocalizations.of(context)?.translate(
                              StringValue.table_nos_of_chairs_hint_text) ??
                          'Enter number of chairs',
                    ),
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    onFieldSubmitted: (String value) {
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
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
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              String tableName = _tableNameController!.text;
              int? nosOfChairs =
                  int.tryParse(_nosOfChairsController!.text.toString());
              TableInfoModel tableInfoModel = TableInfoModel(
                  id: widget.currentTableName.id,
                  name: tableName,
                  nosOfChairs: nosOfChairs ?? 4,
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
