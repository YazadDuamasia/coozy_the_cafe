import 'dart:convert';

import 'package:coozy_the_cafe/AppLocalization.dart';
import 'package:coozy_the_cafe/bloc/bloc.dart';
import 'package:coozy_the_cafe/model/category.dart';
import 'package:coozy_the_cafe/model/sub_category.dart';
import 'package:coozy_the_cafe/pages/pages.dart';
import 'package:coozy_the_cafe/repositories/repositories.dart';
import 'package:coozy_the_cafe/utlis/utlis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
/*

class EditMenuCategoryScreen extends StatefulWidget {
  var categoryId;

  EditMenuCategoryScreen({super.key, required this.categoryId});

  @override
  _EditMenuCategoryScreenState createState() => _EditMenuCategoryScreenState();
}

class _EditMenuCategoryScreenState extends State<EditMenuCategoryScreen> {
  bool isLoading = false;
  bool isError = false;
  final _formKey = GlobalKey<FormState>();

  Category? initialCategory;
  List<SubCategory>? initialSubCategories = [];
  List<TextEditingController>? listController = [];

  FocusNode menuCategoryNameFocusNode = FocusNode();
  TextEditingController menuCategoryNameController =
      TextEditingController(text: "");



  @override
  void initState() {
    super.initState();

    initialCategory = null;
    initialSubCategories = [];

    menuCategoryNameController = TextEditingController(text: "");
    menuCategoryNameFocusNode = FocusNode();
    setState(() {
      isError = false;
      isLoading = true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initialDataLoading();
    });
  }

  Future<void> reload() async {
    initialCategory = null;
    initialSubCategories = [];

    menuCategoryNameController = TextEditingController(text: "");
    menuCategoryNameFocusNode = FocusNode();
    setState(() {
      isError = false;
      isLoading = true;
    });

    initialDataLoading();
  }

  void initialDataLoading() async {
    Category? category;
    List<SubCategory>? subCategories = [];
    try {
      category = await RestaurantRepository()
          .getCategoryBasedOnCategoryId(categoryId: widget.categoryId);
      if (category != null) {
        menuCategoryNameController.text = category.name ?? "";
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
        isError = true;
      });
      return;
    }
    try {
      subCategories = await RestaurantRepository()
          .getSubcategoryBaseCategoryId(id: widget.categoryId);
    } catch (e) {
      setState(() {
        isLoading = false;
        isError = true;
      });
      return;
    }
    initialCategory = category;
    initialSubCategories = subCategories;

    // Clear the existing lists
    listController = [];

    // Initialize the currentList and related controllers and focus nodes
    if (initialSubCategories != null && initialSubCategories!.isNotEmpty) {
      for (int i = 0; i < initialSubCategories!.length; i++) {
        SubCategory subCategory = initialSubCategories![i];
        listController!.add(TextEditingController(text: subCategory.name));
        // listFocusNode.add(new FocusNode());
      }
    }
    setState(() {
      isLoading = false;
      isError = false;
      Future.microtask(() => FocusScope.of(context).requestFocus(FocusNode()));
    });
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
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              AppLocalizations.of(context)
                      ?.translate(StringValue.edit_menu_category_appbar_text) ??
                  "Edit Menu Category",
            ),
            centerTitle: false,
            actions: [
              Visibility(
                visible: isLoading == false && isError == false,
                child: IconButton(
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      print("press");
                      await onSubmit();
                    }
                  },
                  icon: Icon(MdiIcons.checkCircle),
                  tooltip: AppLocalizations.of(context)
                          ?.translate(StringValue.common_save) ??
                      "Save",
                ),
              ),
            ],
          ),
          body: body(),
        ),
      ),
    );
  }

  Widget body() {
    if (isLoading == true) {
      return const LoadingPage();
    } else if (isError == true) {
      return ErrorPage(
        onPressedRetryButton: () async {
          await reload();
        },
      );
    } else {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: menuCategoryNameController,
                      focusNode: menuCategoryNameFocusNode,
                      decoration: InputDecoration(
                        labelText: AppLocalizations.of(context)?.translate(
                                StringValue.menu_category_label_text) ??
                            'Category Name',
                        hintText: AppLocalizations.of(context)?.translate(
                                StringValue.menu_category_hint_text) ??
                            'Enter the category name',
                      ),
                      // autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
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
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: listController == null || listController!.isEmpty
                    ? 0
                    : listController!.length,
                primary: false,
                physics: const NeverScrollableScrollPhysics(),
                addAutomaticKeepAlives: false,
                addRepaintBoundaries: true,
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                              top: index == 0 ? 0 : 10,
                              bottom: index == (listController?.length ?? 0) - 1
                                  ? 10
                                  : 0),
                          child: TextFormField(
                            controller: listController![index],
                            autofocus: false,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)
                                      ?.translate(StringValue
                                          .add_new_menu_sub_category_label_text) ??
                                  "SubCategory Name",
                              hintText: AppLocalizations.of(context)?.translate(
                                      StringValue
                                          .add_new_menu_sub_category_hint_text) ??
                                  "Enter your subCategory name",
                              suffixIcon: IconButton(
                                onPressed: () async {
                                  await onRemove(index);
                                },
                                icon: const Icon(Icons.delete),
                              ),
                            ),
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return AppLocalizations.of(context)?.translate(
                                        StringValue
                                            .add_new_menu_sub_category_error_text) ??
                                    'Enter your sub-category name';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        await onAddNewItem();
                        // setState(() {
                        //   primaryScrollController?.animateTo(
                        //       primaryScrollController!
                        //           .position.maxScrollExtent,
                        //       duration: const Duration(milliseconds: 500),
                        //       curve: Curves.ease);
                        // });
                      },
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(10), elevation: 5),
                      child: Text(AppLocalizations.of(context)?.translate(
                              StringValue.add_menu_sub_category_btn_text) ??
                          "Add new sub-category"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }
  }

  Future<void> onRemove(index) async {
    setState(() {
      listController![index].clear();
      listController![index].dispose();
      listController!.removeAt(index);
    });
  }

  Future<void> onAddNewItem() async {
    setState(() {
      listController!.add(TextEditingController());
      // listFocusNode.add(new FocusNode());
    });
  }

  Future<void> onSubmit() async {
    String? categoryName = menuCategoryNameController.text;
    Constants.debugLog(
        EditMenuCategoryScreen, "onSubmit:categoryName:$categoryName");
    List<String?>? list =
        listController!.map((controller) => controller.text).toList();
    Constants.debugLog(EditMenuCategoryScreen,
        "onSubmit:SubCategory:${listController!.isEmpty ? null : json.encode(list)}");
    Category category = Category(
        id: initialCategory!.id,
        name: categoryName,
        createdDate: DateTime.now().toUtc().toIso8601String());

    Constants.debugLog(EditMenuCategoryScreen,
        "onSubmit:initialCategory:${json.encode(category)}");
    var resCategory = await RestaurantRepository().updateCategory(category!);
    Constants.debugLog(
        EditMenuCategoryScreen, "onSubmit:resCategory:${resCategory}");

    var resDelete = await RestaurantRepository()
        .deleteAllSubcategoryBasedOnCategoryId(categoryId: initialCategory!.id);
    Constants.debugLog(
        EditMenuCategoryScreen, "onSubmit:resDelete:${resDelete}");

    if (list != null && list.isNotEmpty) {
      var res = await RestaurantRepository().insertSubCategoriesForCategoryId(
          categoryId: initialCategory!.id, subCategoriesList: list);
      Constants.debugLog(EditMenuCategoryScreen, "onSubmit:res:${res}");
    }
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    for (var controller in listController!) {
      controller.dispose();
    }
    super.dispose();
  }
}

*/

class EditMenuCategoryScreen extends StatefulWidget {
  var categoryId;

  EditMenuCategoryScreen({super.key, required this.categoryId});

  @override
  _EditMenuCategoryScreenState createState() => _EditMenuCategoryScreenState();
}

class _EditMenuCategoryScreenState extends State<EditMenuCategoryScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FocusNode? menuCategoryNameFocusNode = FocusNode();
  TextEditingController? menuCategoryNameController =
      TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
    menuCategoryNameController = TextEditingController(text: "");
    menuCategoryNameFocusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      BlocProvider.of<EditMenuCategoryBloc>(context)
          .add(LoadEditMenuCategoryDataEvent(categoryId: widget.categoryId));
    });
  }

  Future<void> reload() async {
    BlocProvider.of<EditMenuCategoryBloc>(context)
        .add(LoadEditMenuCategoryDataEvent(categoryId: widget.categoryId));
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
                  FocusManager.instance.primaryFocus?.unfocus();
                  if (_formKey.currentState?.validate() ?? false) {
                    print("press");

                    BlocProvider.of<EditMenuCategoryBloc>(context).add(
                        SubmitSubCategoryEditMenuEvent(
                            categoryName: menuCategoryNameController!.text,
                            context: context));
                  }
                },
                icon: Icon(MdiIcons.checkCircle),
                tooltip: AppLocalizations.of(context)
                        ?.translate(StringValue.common_save) ??
                    "Save",
              ),
            ],
          ),
          body: BlocConsumer<EditMenuCategoryBloc, EditMenuCategoryState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is EditMenuCategoryInitial ||
                  state is EditMenuCategoryLoadingState) {
                return const LoadingPage();
              } else if (state is EditMenuCategoryLoadedState) {
                  menuCategoryNameController!.text = state.initialCategory?.name ?? "";
                return body();
              } else if (state is EditMenuCategoryErrorState) {
                return ErrorPage(onPressedRetryButton: () async {
                  BlocProvider.of<EditMenuCategoryBloc>(context).add(
                      LoadEditMenuCategoryDataEvent(
                          categoryId: widget.categoryId));
                });
              } else if (state is EditMenuCategoryNoInternetState) {
                return NoInternetPage(
                  onPressedRetryButton: () async {
                    BlocProvider.of<EditMenuCategoryBloc>(context).add(
                        LoadEditMenuCategoryDataEvent(
                            categoryId: widget.categoryId));
                  },
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget body() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
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
                  child: TextFormField(
                    controller: menuCategoryNameController,
                    focusNode: menuCategoryNameFocusNode,
                    autofocus: false,
                    decoration: InputDecoration(
                      labelText: AppLocalizations.of(context)?.translate(
                              StringValue.menu_category_label_text) ??
                          'Category Name',
                      hintText: AppLocalizations.of(context)?.translate(
                              StringValue.menu_category_hint_text) ??
                          'Enter the category name',
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
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
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: listView(),
                ),
              ],
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      FocusManager.instance.primaryFocus?.unfocus();
                      BlocProvider.of<EditMenuCategoryBloc>(context)
                          .add(onAddNewSubCategoryEditMenuCategoryEvent());
                      setState(() {});
                    },
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10), elevation: 5),
                    child: Text(AppLocalizations.of(context)?.translate(
                            StringValue.add_menu_sub_category_btn_text) ??
                        "Add new sub-category"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget listView() {
    return BlocConsumer<EditMenuCategoryBloc, EditMenuCategoryState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is EditMenuCategoryLoadedState) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Visibility(
                visible: (state.listController == null ||
                        state.listController!.isEmpty)
                    ? false
                    : true,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.listController == null ||
                          state.listController!.isEmpty
                      ? 0
                      : state.listController!.length,
                  primary: false,
                  physics: const NeverScrollableScrollPhysics(),
                  addAutomaticKeepAlives: false,
                  addRepaintBoundaries: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: 15,
                                bottom: index ==
                                        (state.listController?.length ?? 0) - 1
                                    ? 10
                                    : 5),
                            child: TextFormField(
                              controller: state.listController![index],
                              autofocus: false,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: InputDecoration(
                                labelText: AppLocalizations.of(context)
                                        ?.translate(StringValue
                                            .add_new_menu_sub_category_label_text) ??
                                    "SubCategory Name",
                                hintText: AppLocalizations.of(context)
                                        ?.translate(StringValue
                                            .add_new_menu_sub_category_hint_text) ??
                                    "Enter your subCategory name",
                                suffixIcon: IconButton(
                                  onPressed: () async {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();
                                    BlocProvider.of<EditMenuCategoryBloc>(
                                            context)
                                        .add(DeleteSubCategoryEditMenuEvent(
                                            index: index));
                                    setState(() {});
                                  },
                                  icon: const Icon(Icons.delete),
                                ),
                              ),
                              onChanged: (value) {
                                BlocProvider.of<EditMenuCategoryBloc>(context)
                                    .add(UpdateSubCategoryEditMenuCategoryEvent(
                                        index: index, value: value));
                              },
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return AppLocalizations.of(context)
                                          ?.translate(StringValue
                                              .add_new_menu_sub_category_error_text) ??
                                      'Enter your sub-category name';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                )),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  //
  // Future<void> onSubmit() async {
  //   String? categoryName = menuCategoryNameController.text;
  //   Constants.debugLog(
  //       EditMenuCategoryScreen, "onSubmit:categoryName:$categoryName");
  //   List<String?>? list =
  //       listController!.map((controller) => controller.text).toList();
  //   Constants.debugLog(EditMenuCategoryScreen,
  //       "onSubmit:SubCategory:${listController!.isEmpty ? null : json.encode(list)}");
  //   Category category = Category(
  //       id: initialCategory!.id,
  //       name: categoryName,
  //       createdDate: DateTime.now().toUtc().toIso8601String());
  //
  //   Constants.debugLog(EditMenuCategoryScreen,
  //       "onSubmit:initialCategory:${json.encode(category)}");
  //   var resCategory = await RestaurantRepository().updateCategory(category!);
  //   Constants.debugLog(
  //       EditMenuCategoryScreen, "onSubmit:resCategory:${resCategory}");
  //
  //   var resDelete = await RestaurantRepository()
  //       .deleteAllSubcategoryBasedOnCategoryId(categoryId: initialCategory!.id);
  //   Constants.debugLog(
  //       EditMenuCategoryScreen, "onSubmit:resDelete:${resDelete}");
  //
  //   if (list != null && list.isNotEmpty) {
  //     var res = await RestaurantRepository().insertSubCategoriesForCategoryId(
  //         categoryId: initialCategory!.id, subCategoriesList: list);
  //     Constants.debugLog(EditMenuCategoryScreen, "onSubmit:res:${res}");
  //   }
  //   Navigator.of(context).pop();
  // }

  @override
  void dispose() {
    BlocProvider.of<EditMenuCategoryBloc>(context).close();
    super.dispose();
  }
}
