import 'package:coozy_cafe/AppLocalization.dart';
import 'package:coozy_cafe/model/category.dart';
import 'package:coozy_cafe/model/sub_category.dart';
import 'package:coozy_cafe/utlis/utlis.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class EditMenuCategoryScreen extends StatefulWidget {
  final Category? category;
  final List<SubCategory>? subCategoryList;

  const EditMenuCategoryScreen(
      {Key? key, required this.category, required this.subCategoryList})
      : super(key: key);

  @override
  _EditMenuCategoryScreenState createState() => _EditMenuCategoryScreenState();
}

class _EditMenuCategoryScreenState extends State<EditMenuCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? categoryTextEditingController;
  FocusNode? categoryFocusNode;
  List<String> _subCategoryList = [];
  ScrollController? _dynamicListViewScrollController;

  @override
  void initState() {
    super.initState();
    categoryTextEditingController = TextEditingController(text: "");
    categoryFocusNode = FocusNode();
    _dynamicListViewScrollController = ScrollController();
    if (widget.category != null) {
      categoryTextEditingController!.text = "${widget.category!.name ?? ""}";
    }
    if (widget.subCategoryList != null && widget.subCategoryList!.isNotEmpty) {
      for (int i = 0; i < widget.subCategoryList!.length; i++) {
        _subCategoryList.add(widget.subCategoryList![i].name ?? "");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dynamic TextFormFields'),
        actions: [
          IconButton(
              onPressed: () async {
                handleSubmit();
              },
              icon: Icon(MdiIcons.checkCircle))
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      key: UniqueKey(),
                      controller: categoryTextEditingController,
                      focusNode: categoryFocusNode,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)?.translate(
                                StringValue.menu_category_label_text) ??
                            'Category Name',
                        hintText: AppLocalizations.of(context)?.translate(
                                StringValue.menu_category_hint_text) ??
                            'Enter the category name',
                      ),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.text,
                      textInputAction: widget.subCategoryList == null ||
                              widget.subCategoryList!.isEmpty
                          ? TextInputAction.done
                          : TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return AppLocalizations.of(context)?.translate(
                                  StringValue.menu_category_error_text) ??
                              'Please enter category name';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
              ],
            ),
            Flexible(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Visibility(
                    visible:
                        _subCategoryList != null && _subCategoryList.isNotEmpty,
                    child: Flexible(
                      child: ListView.separated(
                        controller: _dynamicListViewScrollController,
                        itemCount: _subCategoryList.length,
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(10),
                        itemBuilder: (context, index) => Row(
                          children: [
                            Expanded(
                              child: DynamicTextfield(
                                key: UniqueKey(),
                                initialValue: _subCategoryList[index],
                                onChanged: (v) => _subCategoryList[index] = v,
                                onDelete: () {
                                  setState(() {
                                    _subCategoryList.removeAt(index);
                                  });
                                },
                              ),
                            ),
                            // const SizedBox(width: 20),
                            // _textfieldBtn(index),
                          ],
                        ),
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 20,
                        ),
                      ),
                      flex: 1,
                      fit: FlexFit.loose,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 0, bottom: 5, right: 10, left: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                _subCategoryList.add('');
                              });
                              setState(() {
                                _dynamicListViewScrollController!.animateTo(
                                  _dynamicListViewScrollController!
                                      .position.maxScrollExtent+200,
                                  duration: const Duration(seconds: 1),
                                  curve: Curves.fastOutSlowIn,
                                );
                              });


                            },
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(10),
                                elevation: 5),
                            child: Text(AppLocalizations.of(context)?.translate(
                                    StringValue
                                        .add_menu_sub_category_btn_text) ??
                                "Add new sub-category"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// last textfield will have an add button, tapping which will add a new textfield below
  /// and all other textfields will have a remove button, tapping which will remove the textfield at the index
  Widget _textfieldBtn(int index) {
    // bool isLast = index == _subCategoryList.length - 1;
    bool isLast = index == _subCategoryList.length;

    return InkWell(
      onTap: () => setState(
        () => isLast
            ? _subCategoryList.add('')
            : _subCategoryList.removeAt(index),
      ),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: isLast ? Theme.of(context).primaryColor : Colors.red,
        ),
        child: Icon(
          isLast ? Icons.add : Icons.remove,
          color: Colors.white,
        ),
      ),
    );
  }

  void handleSubmit() {
    if (_formKey.currentState!.validate() ?? false) {
      print(_subCategoryList);
    }
  }
}

class DynamicTextfield extends StatefulWidget {
  String? initialValue;
  final void Function(String)? onChanged;
  final void Function()? onDelete;

  DynamicTextfield(
      {Key? key,
      required this.initialValue,
      required this.onChanged,
      required this.onDelete})
      : super(key: key);

  @override
  State createState() => _DynamicTextfieldState();
}

class _DynamicTextfieldState extends State<DynamicTextfield> {
  late final TextEditingController _controller;
  late final FocusNode focusNode;

  @override
  void initState() {
    super.initState();
    _controller = new TextEditingController(text: "");
    focusNode = new FocusNode();
    if (widget.initialValue != null && widget.initialValue!.isNotEmpty) {
      _controller.text = widget.initialValue ?? "";
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: UniqueKey(),
      controller: _controller,
      onChanged: widget.onChanged,
      autovalidateMode: AutovalidateMode.disabled,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: AppLocalizations.of(context)
                ?.translate(StringValue.add_new_menu_sub_category_label_text) ??
            "SubCategory Name",
        hintText: AppLocalizations.of(context)
                ?.translate(StringValue.add_new_menu_sub_category_hint_text) ??
            "Enter your subCategory name",
        suffixIcon: IconButton(
          onPressed: widget.onDelete,
          icon: Icon(MdiIcons.deleteForever,
              color: Theme.of(context).colorScheme.primary),
        ),
      ),
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
}
