import 'package:coozy_the_cafe/pages/startup_screens/sign_up_page/sign_up_page.dart';
import 'package:coozy_the_cafe/utlis/utlis.dart';
import 'package:coozy_the_cafe/widgets/fliter_system_widget/props/filter_item_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FilterDatePickerTextFormFieldTitle extends StatefulWidget {
  final String? title;
  InputDecoration? decoration;
  final String? value;
  final String? dateFormat;
  final Function(String)? onChanged;
  final List<FilterItemModel> filterOptions;
  final List<FilterItemModel> previousApplied;

  FilterDatePickerTextFormFieldTitle(
      {Key? key,
      this.title,
      this.dateFormat,
      required this.decoration,
      required this.onChanged,
      required this.filterOptions,
      required this.previousApplied,
      this.value})
      : super(key: key);

  @override
  _FilterDatePickerTextFormFieldTitleState createState() =>
      _FilterDatePickerTextFormFieldTitleState();
}

class _FilterDatePickerTextFormFieldTitleState
    extends State<FilterDatePickerTextFormFieldTitle> {
  late DateTime _selectedDate;
  TextEditingController datePickerTextEditingController =
      TextEditingController(text: "");
  FocusNode _focusNode = FocusNode();
  DateTime? date;

  @override
  void initState() {
    super.initState();
    datePickerTextEditingController = TextEditingController(text: "");
    _focusNode = FocusNode();
    datePickerTextEditingController.text = widget.value.toString() ?? "";
    _selectedDate = DateTime.parse(widget.value.toString()) ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Visibility(
          visible:
              (widget.title == null || widget.title!.isEmpty) ? false : true,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Text(widget.title ?? ""),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 10, right: 10, top: 15),
                        child: TextFormField(
                          onChanged: (value) async {
                            setState(() {
                              widget.onChanged!(value);
                            });
                          },
                          readOnly: true,
                          controller: datePickerTextEditingController,
                          focusNode: _focusNode,
                          decoration: widget.decoration,
                          autovalidateMode: AutovalidateMode.disabled,
                          validator: (value) {
                            return value;
                          },
                          onFieldSubmitted: (String value) {},
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  _selectDate(BuildContext context) async {
    DateTime? datePick;

    if (Constants.isIOS() || Constants.isMacOS()) {
      datePick = await showModalBottomSheet<DateTime?>(
        context: context,
        builder: (context) {
          DateTime? tempPickedDate;
          return SizedBox(
            height: 250,
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CupertinoButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    CupertinoButton(
                      child: const Text('Done'),
                      onPressed: () {
                        Navigator.of(context).pop(tempPickedDate);
                      },
                    ),
                  ],
                ),
                const Divider(
                  height: 0,
                  thickness: 1,
                ),
                Expanded(
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    minimumDate: DateTime(DateTime.now().year - 80),
                    initialDateTime: date ?? DateTime.now(),
                    maximumDate: DateTime.now(),
                    onDateTimeChanged: (DateTime? dateTime) {
                      tempPickedDate = dateTime;
                    },
                  ),
                ),
              ],
            ),
          );
        },
      );
    } else {
      datePick = await showDatePicker(
        context: context,
        initialDate: date ?? DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 120),
        lastDate: DateTime.now(),
        helpText: "Date of birth",
      );
    }

    if (datePick != null && datePick != date) {
      date = datePick;
      String? pick = DateUtil.dateToString(datePick, "dd-MM-yyyy");
      Constants.debugLog(FilterDatePickerTextFormFieldTitle, "FilterDatePickerTextFormFieldTitle:Date:$pick");
      datePickerTextEditingController.text = pick!;
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
