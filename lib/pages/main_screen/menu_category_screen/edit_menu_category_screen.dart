import 'package:coozy_cafe/AppLocalization.dart';
import 'package:coozy_cafe/bloc/bloc.dart';
import 'package:coozy_cafe/model/category.dart';
import 'package:coozy_cafe/model/sub_category.dart';
import 'package:coozy_cafe/pages/main_screen/menu_category_screen/dynamic_text_form_field_for_sub_category_widget.dart';
import 'package:coozy_cafe/pages/pages.dart';
import 'package:coozy_cafe/utlis/components/string_value.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class EditMenuCategoryScreen extends StatefulWidget {
  final Category? category;
  final List<SubCategory>? subCategoryList;

  const EditMenuCategoryScreen(
      {super.key, required this.category, required this.subCategoryList});

  @override
  _EditMenuCategoryScreenState createState() => _EditMenuCategoryScreenState();
}

class _EditMenuCategoryScreenState extends State<EditMenuCategoryScreen> {
  Size? size;
  Orientation? orientation;

  final _formKey = GlobalKey<FormState>();
  late EditMenuCategoryCubit _menuCategoryCubit;
  ScrollController? primaryScrollController;

  @override
  void initState() {
    super.initState();
    primaryScrollController = ScrollController();
    _menuCategoryCubit = context.read<EditMenuCategoryCubit>();
    _menuCategoryCubit.initialLoadData(widget.category, widget.subCategoryList);
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    orientation = MediaQuery.of(context).orientation;
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return true;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              AppLocalizations.of(context)
                      ?.translate(StringValue.edit_menu_category_appbar_text) ??
                  "Edit Menu Category",
            ),
            centerTitle: false,
            actions: [
              IconButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    _menuCategoryCubit.submit(context);
                  }
                },
                icon: Icon(MdiIcons.checkCircle),
                tooltip: AppLocalizations.of(context)
                        ?.translate(StringValue.common_save) ??
                    "Save",
              ),
            ],
          ),
          body: BlocConsumer<EditMenuCategoryCubit, EditMenuCategoryState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is InitialEditMenuCategoryState ||
                  state is LoadingEditMenuCategoryState) {
                return LoadingPage(
                  key: UniqueKey(),
                );
              } else if (state is LoadedEditMenuCategoryState) {
                return SingleChildScrollView(
                  controller: primaryScrollController,
                  physics: const ClampingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  child: Form(
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
                                  controller: _menuCategoryCubit
                                      .menuCategoryNameController,
                                  focusNode: _menuCategoryCubit
                                      .menuCategoryNameFocusNode,
                                  autofocus: false,
                                  decoration: InputDecoration(
                                    floatingLabelBehavior: FloatingLabelBehavior.never,
                                    labelText: AppLocalizations.of(context)
                                            ?.translate(StringValue
                                                .menu_category_label_text) ??
                                        'Category Name',
                                    hintText: AppLocalizations.of(context)
                                            ?.translate(StringValue
                                                .menu_category_hint_text) ??
                                        'Enter the category name',
                                  ),
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  keyboardType: TextInputType.text,
                                  textInputAction: TextInputAction.next,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return AppLocalizations.of(context)
                                              ?.translate(StringValue
                                                  .menu_category_error_text) ??
                                          'Please enter category name';
                                    }
                                    return null;
                                  },
                                  onFieldSubmitted: (String value) {
                                    FocusScope.of(context).unfocus();
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: BlocConsumer<EditMenuCategoryCubit,
                                  EditMenuCategoryState>(
                                listener: (context, state) {
                                  // TODO: implement listener
                                },
                                builder: (context, state) {
                                  if (state is LoadedEditMenuCategoryState) {
                                    return ListView.separated(
                                      itemCount: state.subCategoryList.length,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      primary: false,
                                      addAutomaticKeepAlives: false,
                                      itemBuilder: (context, index) => Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 10,
                                                  right: 10,
                                                  top: 5,
                                                  bottom: index ==
                                                          state.subCategoryList
                                                                  .length -
                                                              1
                                                      ? 10
                                                      : 0),
                                              child:
                                                  DynamicTextFormFieldForSubCategoryWidget(
                                                index: index,
                                                key: UniqueKey(),
                                                initialValue: state
                                                    .subCategoryList[index],
                                                onChanged: (value) async {
                                                  _menuCategoryCubit
                                                      .onChangeSubCategory(
                                                          value, index);
                                                },
                                                onDelete: () async {
                                                  _menuCategoryCubit
                                                      .removeSubCategory(index);
                                                  FocusScope.of(context)
                                                      .unfocus();
                                                  setState(() {});
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(
                                        height: 10,
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 0, bottom: 10, right: 10, left: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    _menuCategoryCubit.addSubCategory('');
                                    setState(() {
                                      primaryScrollController?.animateTo(
                                          primaryScrollController!
                                                  .position.maxScrollExtent +
                                              100,
                                          duration:
                                              const Duration(milliseconds: 500),
                                          curve: Curves.ease);
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.all(10),
                                      elevation: 5),
                                  child: Text(AppLocalizations.of(context)
                                          ?.translate(StringValue
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
                );
              } else if (state is NoInternetEditMenuCategoryState) {
                return NoInternetPage(
                  key: UniqueKey(),
                  onPressedRetryButton: () async {
                    _menuCategoryCubit.initialLoadData(
                        widget.category, widget.subCategoryList);
                  },
                );
              } else {
                return ErrorPage(
                  key: UniqueKey(),
                  onPressedRetryButton: () async {
                    _menuCategoryCubit.initialLoadData(
                        widget.category, widget.subCategoryList);
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
