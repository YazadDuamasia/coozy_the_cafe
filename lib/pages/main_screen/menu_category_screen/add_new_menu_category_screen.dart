import 'package:coozy_cafe/AppLocalization.dart';
import 'package:coozy_cafe/bloc/add_menu_sub_categories_bloc/add_menu_categories_cubit.dart';
import 'package:coozy_cafe/pages/main_screen/menu_category_screen/dynamic_text_form_field_for_sub_category_widget.dart';
import 'package:coozy_cafe/utlis/utlis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddNewMenuCategoryScreen extends StatefulWidget {
  const AddNewMenuCategoryScreen({super.key});

  @override
  _AddNewMenuCategoryScreenState createState() =>
      _AddNewMenuCategoryScreenState();
}

class _AddNewMenuCategoryScreenState extends State<AddNewMenuCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  late AddMenuCategoryCubit _menuCategoryCubit;

  @override
  void initState() {
    super.initState();
    _menuCategoryCubit = context.read<AddMenuCategoryCubit>();
    _menuCategoryCubit.resetData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          Navigator.pop(context);
          return true;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            centerTitle: false,
            title: Text(
              AppLocalizations.of(context)
                      ?.translate(StringValue.add_menu_category_appbar_text) ??
                  "Add new menu category",
            ),
            actions: [
              IconButton(
                onPressed: () async {
                  if (_formKey.currentState?.validate() ?? false) {
                    _menuCategoryCubit.saveCategory(context);
                  }
                },
                icon: const Icon(
                  Icons.check,
                  color: Colors.white,
                ),
                tooltip: AppLocalizations.of(context)?.translate(
                        StringValue.add_menu_category_appbar_text) ??
                    "Add new menu category",
              ),
            ],
          ),
          body: BlocConsumer<AddMenuCategoryCubit, AddMenuCategoryState>(
            listener: (context, state) {
              // TODO: implement listener
            },
            builder: (context, state) {
              return SingleChildScrollView(
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
                            child: BlocConsumer<AddMenuCategoryCubit,
                                AddMenuCategoryState>(
                              listener: (context, state) {
                                // TODO: implement listener
                              },
                              builder: (context, state) {
                                if (state is AddMenuCategoryInitial) {
                                  return Container();
                                } else if (state is AddMenuCategoryUpdated) {
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
                                              initialValue:
                                                  state.subCategoryList[index],
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
                            top: 0, bottom: 5, right: 10, left: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () async {
                                  _menuCategoryCubit.addSubCategory('');
                                  setState(() {});
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
