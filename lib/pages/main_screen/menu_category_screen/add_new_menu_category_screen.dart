import 'package:coozy_cafe/AppLocalization.dart';
import 'package:coozy_cafe/model/category.dart';
import 'package:coozy_cafe/model/sub_category.dart';
import 'package:coozy_cafe/pages/main_screen/menu_category_screen/dynamic_text_form_field_for_sub_category_widget.dart';
import 'package:coozy_cafe/repositories/components/restaurant_repository.dart';
import 'package:coozy_cafe/utlis/utlis.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AddNewMenuCategoryScreen extends StatefulWidget {
  const AddNewMenuCategoryScreen({Key? key}) : super(key: key);

  @override
  _AddNewMenuCategoryScreenState createState() =>
      _AddNewMenuCategoryScreenState();
}

class _AddNewMenuCategoryScreenState extends State<AddNewMenuCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? menuCategoryNameController;
  FocusNode? menuCategoryNameFocusNode;
  List<String> _subCategoryList = [];
  RestaurantRepository? repository;

  @override
  void initState() {
    super.initState();
    menuCategoryNameController = TextEditingController(text: "");
    menuCategoryNameFocusNode = FocusNode();
    repository = RestaurantRepository();
    _subCategoryList = [];
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
                  await _saveCategory();
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
          body: SingleChildScrollView(
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
                            controller: menuCategoryNameController,
                            focusNode: menuCategoryNameFocusNode,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)
                                      ?.translate(StringValue
                                          .menu_category_label_text) ??
                                  'Category Name',
                              hintText: AppLocalizations.of(context)?.translate(
                                      StringValue.menu_category_hint_text) ??
                                  'Enter the category name',
                            ),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                            onFieldSubmitted: (String value) {
                              FocusScope.of(context).requestFocus(FocusNode());
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
                        child: ListView.separated(
                          itemCount: (_subCategoryList == null ||
                                  _subCategoryList.isEmpty)
                              ? 0
                              : _subCategoryList.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
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
                                      bottom:
                                          index == _subCategoryList.length - 1
                                              ? 10
                                              : 0),
                                  child:
                                      DynamicTextFormFieldForSubCategoryWidget(
                                    key: UniqueKey(),
                                    initialValue: _subCategoryList[index],
                                    onChanged: (v) =>
                                        _subCategoryList[index] = v,
                                    onDelete: () => setState(() {
                                      _subCategoryList.removeAt(index);
                                    }),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 10,
                          ),
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
                              setState(() {
                                _subCategoryList.add('');
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(10)),
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
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  _saveCategory() async {
    if (_formKey.currentState?.validate() ?? false) {
      Category newCategory = Category(
        name: menuCategoryNameController!.text.toString(),
        createdDate: DateTime.now().toUtc().toIso8601String(),
      );
      Constants.debugLog(
          AddNewMenuCategoryScreen, "newCategory:${newCategory.toJson()}");
      Constants.debugLog(AddNewMenuCategoryScreen,
          "newSubCategory:${_subCategoryList.toString()}");

      // Save the category to the database using your repository
      repository!.addCategory(newCategory).then((categoryId) async {
        if (categoryId != null) {
          // Successfully added category, you can do something here
          List<Category?>? list =
              await repository!.getCategoryBasedOnName(newCategory.name);
          if (list != null) {
            if (_subCategoryList != null && _subCategoryList.isNotEmpty) {
              bool errorOccurred = false; // Flag to track if an error occurred
              var errorIndex = -1; // Flag to track if an error occurred

              for (int i = 0; i < _subCategoryList.length; i++) {
                SubCategory subCategory = SubCategory(
                  name: _subCategoryList[i],
                  createdDate: DateTime.now().toUtc().toIso8601String(),
                  categoryId: list.first!.id,
                );
                // Check the result of createSubcategory
                int subcategoryId =
                    await repository!.createSubcategory(subCategory);

                if (subcategoryId > 0) {
                  // Subcategory added successfully
                  Constants.debugLog(AddNewMenuCategoryScreen,
                      "${subCategory.name} Subcategory added successfully with ID: $subcategoryId");
                } else {
                  // Failed to add subcategory, handle the error
                  Constants.debugLog(
                      AddNewMenuCategoryScreen, "Failed to add subcategory");
                  errorOccurred = true; // Set the flag to true
                  errorIndex = i;
                  break; // Exit the loop on the first error
                }
              }

              if (errorOccurred) {
                // Return an error message
                Constants.debugLog(AddNewMenuCategoryScreen,
                    "Error occurred during creation of $errorIndex subcategory .");
                Constants.customTimerPopUpDialogMessage(
                    classObject: AddNewMenuCategoryScreen,
                    isLoading: true,
                    context: navigatorKey.currentContext,
                    descriptions: AppLocalizations.of(context)?.translate(
                            StringValue
                                .menu_sub_category_new_added_failed_successfully_text) ??
                        "Error occurred during subcategory creation.",
                    title: "",
                    titleIcon: Lottie.asset(
                      StringImagePath.warming_cricle_blink_icon_lottie,
                      repeat: false,
                    ),
                    showForHowDuration: const Duration(seconds: 3),
                    navigatorKey: navigatorKey);
                return;
              }
            }
          }

          Constants.customTimerPopUpDialogMessage(
              classObject: AddNewMenuCategoryScreen,
              isLoading: true,
              context: navigatorKey.currentContext,
              descriptions: AppLocalizations.of(context)?.translate(
                      StringValue.menu_category_added_successfully_text) ??
                  "New Menu Category has been added successfully.",
              title: "",
              titleIcon: Lottie.asset(
                MediaQuery.of(context).platformBrightness == Brightness.light
                    ? StringImagePath.done_light_brown_color_lottie
                    : StringImagePath.done_brown_color_lottie,
                repeat: false,
              ),
              showForHowDuration: const Duration(seconds: 3),
              navigatorKey: navigatorKey);
          Navigator.pop(context);
        } else {
          // Failed to add category, handle the error
          // You might want to show a snackbar or an error message
          Constants.customTimerPopUpDialogMessage(
              classObject: AddNewMenuCategoryScreen,
              isLoading: true,
              context: navigatorKey.currentContext,
              descriptions: AppLocalizations.of(context)?.translate(StringValue
                      .menu_category_added_failed_successfully_text) ??
                  "New Menu Category has been added successfully.",
              title: "",
              titleIcon: Lottie.asset(
                StringImagePath.warming_cricle_blink_icon_lottie,
                repeat: false,
              ),
              showForHowDuration: const Duration(seconds: 3),
              navigatorKey: navigatorKey);
        }
      });
    }
  }
}
