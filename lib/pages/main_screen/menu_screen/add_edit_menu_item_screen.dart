import 'dart:core';

import 'package:coozy_the_cafe/AppLocalization.dart';
import 'package:coozy_the_cafe/bloc/menu_category_full_list_cubit/menu_category_full_list_cubit.dart';
import 'package:coozy_the_cafe/model/category.dart';
import 'package:coozy_the_cafe/model/sub_category.dart';
import 'package:coozy_the_cafe/repositories/components/restaurant_repository.dart';
import 'package:coozy_the_cafe/utlis/utlis.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';

enum MenuVariations { simple, advance }

class AddEditMenuItemScreen extends StatefulWidget {
  AddEditMenuItemScreen({Key? key}) : super(key: key);

  @override
  _AddEditMenuItemScreenState createState() => _AddEditMenuItemScreenState();
}

class _AddEditMenuItemScreenState extends State<AddEditMenuItemScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController? dishNameTextController =
      TextEditingController(text: "");
  FocusNode? dishNameFocusNode = FocusNode(debugLabel: "dish_name_focus_node");
  TextEditingController? dishPriceTextController =
      TextEditingController(text: "");
  FocusNode? dishPriceFocusNode =
      FocusNode(debugLabel: "dish_price_focus_node");
  FocusNode? foodTypeFocusNode = FocusNode(debugLabel: "food_type_focus_node");
  FocusNode? foodMeasuringUnitsFocusNode =
      FocusNode(debugLabel: "food_measuring_units_focus_node");

  TextEditingController? dishSellingUnitTextController =
      TextEditingController(text: "");
  FocusNode? dishSellingUnitFocusNode =
      FocusNode(debugLabel: "dish_selling_unit_focus_node");
  TextEditingController? dishSellingAmountTextController =
      TextEditingController(text: "");
  FocusNode? dishSellingAmountFocusNode =
      FocusNode(debugLabel: "dish_selling_unit_focus_node");

  List<String> foodTypes = [
    'Vegetarian',
    'Lacto-Vegetarian',
    'Ovo-Vegetarian',
    'Lacto-Ovo Vegetarian',
    'Vegan',
    'Non-Vegetarian',
    'Poultry',
    'Red Meat',
    'Seafood',
    'Game',
    'Pescatarian',
    'Flexitarian',
    'Gluten-Free',
    'Ketogenic (Keto)',
    'Paleo',
    'Low-Carb',
    'Low-Fat',
    'Mediterranean',
    'Organic',
    'Processed',
    'Raw Food',
    'Junk Food'
  ];

  final List<String> measuringUnits = [
    "Unit",
    'Piece',
    'Dozen',
    'Pack',
    'Box',
    'Cup',
    'Slice',
    'Can',
    'Bottle',
    'Jar',
    'Bag',
    'Bundle',
    'Milligram',
    'Gram',
    'Kilogram',
    'Liter',
    'Milliliter',
    'Ounce',
    'Pound',
    'Gallon',
    'Pint',
    'Quart',
  ];

  String? selectedFoodType;
  String? selectedMeasuringUnits;
  Map<String, dynamic>? result;
  List<Category>? categories = [];
  Map<int, List<SubCategory>?>? subCategoryMap = {};
  Category? selectedCategory;
  SubCategory? selectedSubCategory;
  Set<MenuVariations> selectionMenuVariations = <MenuVariations>{
    MenuVariations.simple
  };
  ValueNotifier<MenuVariations> inputMenuVariationsValue =
      ValueNotifier<MenuVariations>(MenuVariations.simple);
  ValueNotifier<bool> _switchValue = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await initialData();
    });
  }

  Future<void> initialData() async {
    result = await fetchDataFromApi();
    if (result != null) {
      categories = (result!['categories'] as List)
          .map((e) => Category.fromJson(e))
          .toList();
      subCategoryMap = {
        for (Category category in categories!)
          category.id!: (result!['categories'] as List?)!
              .firstWhere(
                  (element) => element['id'] == category.id)['subCategories']
              .map<SubCategory>((e) => SubCategory.fromJson(e))
              .toList()
      };
    }
    setState(() {});
  }

  Future<Map<String, dynamic>?> fetchDataFromApi() async {
    try {
      List<Category>? categoryList;
      categoryList = await RestaurantRepository().getCategories();
      var subCategoryList = await RestaurantRepository().getSubcategories();

      var result = {
        "categories": categoryList?.map((category) {
              List<Map<String, dynamic>?> subCategories = subCategoryList
                      ?.where((subCategory) =>
                          subCategory.categoryId == category.id)
                      .map((subCategory) => subCategory.toJson())
                      .toList() ??
                  [];
              return {
                "id": category.id!,
                "name": category.name!,
                "isActive": category.isActive!,
                "createdDate": category.createdDate,
                "subCategories": subCategories,
              };
            }).toList() ??
            [],
      };

      return result;
    } catch (e) {
      Constants.debugLog(
          AddEditMenuItemScreen, "fetchDataFromApi:catchError:$e");
      return null;
    }
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
            title: const Text("Add Dish"),
            leadingWidth: 35,
            centerTitle: false,
            actions: <Widget>[
              TextButton(
                onPressed: () async {
                  final isValid = _formKey.currentState?.validate();
                  if (!isValid!) {
                    return;
                  }
                  _formKey.currentState?.save();
                },
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Add",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white,fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Theme(
              data: Theme.of(context),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: dishNameTextController,
                              focusNode: dishNameFocusNode,
                              keyboardType: TextInputType.text,
                              decoration: const InputDecoration(
                                labelText: "Dish Name",
                                hintText: "Enter dish name",
                                errorMaxLines: 3,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter dish name';
                                }
                                return null;
                              },
                              onFieldSubmitted: (value) {
                                // Future.microtask(() => FocusScope.of(context).requestFocus(dish_price_focus_node));
                              },
                            ),
                          ),
                        ],
                      ),
                      foodTypeWidget(),
                      categoryDropdownWidget(),
                      Visibility(
                        visible: selectedCategory != null,
                        child: subCategoryDropdownWidget(),
                      ),
                      toogle_simple_widget(),
                      ValueListenableBuilder<MenuVariations>(
                        valueListenable: inputMenuVariationsValue,
                        builder: (context, value, child) {
                          if (value == MenuVariations.simple)
                            return measuringUnitsWidget();
                          else
                            return advanceSelectPriceWidget();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget toogle_simple_widget() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: SegmentedButton<MenuVariations>(
              showSelectedIcon: false,
              multiSelectionEnabled: false,
              emptySelectionAllowed: false,
              segments: <ButtonSegment<MenuVariations>>[
                const ButtonSegment<MenuVariations>(
                  value: MenuVariations.simple,
                  label: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Simple',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                const ButtonSegment<MenuVariations>(
                  value: MenuVariations.advance,
                  label: Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      'Advance',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
              selected: selectionMenuVariations,
              onSelectionChanged: (Set<MenuVariations> newSelection) {
                setState(() {
                  selectionMenuVariations = newSelection;
                  inputMenuVariationsValue.value = newSelection.first;
                });
              },
              style: ButtonStyle(
                textStyle: WidgetStateProperty.all(
                  Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                backgroundColor: WidgetStateProperty.resolveWith<Color?>(
                    (Set<WidgetState> states) {
                  if (states.contains(WidgetState.selected)) {
                    return Theme.of(context).colorScheme.primary;
                  }
                  return null;
                }),
                foregroundColor: WidgetStateProperty.resolveWith<Color?>(
                    (Set<WidgetState> states) {
                  if (states.contains(WidgetState.selected)) {
                    return Colors.white;
                  }
                  return Theme.of(context).colorScheme.primary;
                }),
                side: WidgetStateProperty.all(
                  BorderSide(color: Theme.of(context).colorScheme.primary),
                ),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget categoryDropdownWidget() {
    Constants.debugLog(
        AddEditMenuItemScreen, "categories:${categories.toString()}");
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Visibility(
        visible: categories == null || categories!.isEmpty,
        replacement: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: Theme(
                data: Theme.of(context),
                child: DropdownButtonFormField<Category>(
                  key: UniqueKey(),
                  menuMaxHeight: MediaQuery.of(context).size.height * 0.35,
                  isDense: true,
                  isExpanded: true,
                  padding: const EdgeInsets.only(top: 10),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    labelText: 'Select Category',
                    errorMaxLines: 3,
                  ),
                  value: selectedCategory,
                  onChanged: (Category? newValue) {
                    setState(() {
                      selectedCategory = newValue;
                      selectedSubCategory = null;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                  items: categories?.map((Category category) {
                    return DropdownMenuItem<Category>(
                      value: category,
                      child: Text(category.name ?? ""),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  navigationRoutes
                      .navigateToAddNewMenuCategoryScreen()
                      .then((value) async {
                    await context.read<MenuCategoryFullListCubit>().loadData();
                    await initialData();
                  });
                },
                child: Text(AppLocalizations.of(context)
                        ?.translate(StringValue.menu_category_add_new_category) ??
                    'Add new category'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget subCategoryDropdownWidget() {
    List<SubCategory>? filteredSubCategories =
        subCategoryMap?[selectedCategory?.id] ?? [];

    return Visibility(
      visible:
          filteredSubCategories != null && filteredSubCategories.isNotEmpty,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: Theme(
              data: Theme.of(context),
              child: DropdownButtonFormField<SubCategory>(
                key: UniqueKey(),
                menuMaxHeight: MediaQuery.of(context).size.height * 0.35,
                isDense: true,
                isExpanded: true,
                padding: const EdgeInsets.only(top: 10),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                decoration: const InputDecoration(
                  labelText: 'Select Subcategory',
                  errorMaxLines: 3,
                ),
                value: selectedSubCategory,
                onChanged: (SubCategory? newValue) {
                  setState(() {
                    selectedSubCategory = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a subcategory';
                  }
                  return null;
                },
                items: filteredSubCategories.map((SubCategory subCategory) {
                  return DropdownMenuItem<SubCategory>(
                    value: subCategory,
                    child: Text(subCategory.name ?? ""),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget foodTypeWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          child: Theme(
            data: Theme.of(context),
            child: DropdownButtonFormField<String>(
              key: UniqueKey(),
              menuMaxHeight: MediaQuery.of(context).size.height * 0.35,
              focusNode: foodTypeFocusNode,
              isDense: true,
              isExpanded: true,
              padding: const EdgeInsets.only(top: 10),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: const InputDecoration(
                labelText: 'Select Food Type',
                errorMaxLines: 3,
              ),
              value: selectedFoodType,
              onChanged: (String? newValue) {
                setState(() {
                  selectedFoodType = newValue;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a food type';
                }
                return null;
              },
              items: foodTypes.map((String foodType) {
                return DropdownMenuItem<String>(
                  value: foodType,
                  child: Text(foodType),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget measuringUnitsWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: Theme(
                      data: Theme.of(context),
                      child: DropdownButtonFormField<String>(
                        menuMaxHeight: MediaQuery.of(context).size.height * 0.35,
                        focusNode: foodMeasuringUnitsFocusNode,
                        isDense: true,
                        isExpanded: true,
                        padding: const EdgeInsets.only(top: 10),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: const InputDecoration(
                          labelText: "Selling Unit",
                          hintText: 'Select measuring units type',
                          errorMaxLines: 3,
                        ),
                        value: selectedMeasuringUnits,
                        onChanged: (String? newValue) async {
                          setState(() {
                            selectedMeasuringUnits = newValue;
                            dishSellingUnitTextController?.clear();
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a measuring units type';
                          }
                          return null;
                        },
                        items: measuringUnits.map((String foodType) {
                          return DropdownMenuItem<String>(
                            value: foodType,
                            child: Text(foodType),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
              Visibility(
                visible: selectedMeasuringUnits != "Unit",
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              controller: dishSellingUnitTextController,
                              focusNode: dishSellingUnitFocusNode,
                              keyboardType: const TextInputType.numberWithOptions(
                                  decimal: true),
                              inputFormatters: <TextInputFormatter>[
                                // up to 3 decimals
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d+\.?\d{0,3}')),
                              ],
                              decoration: const InputDecoration(
                                labelText: "Selling Unit Value",
                                hintText: "Enter value of selling amount",
                                errorMaxLines: 3,
                              ),
                              validator: (value) {
                                if (selectedMeasuringUnits != "Unit") {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter selling unit value';
                                  }
                                }
                                return null;
                              },
                              onFieldSubmitted: (value) {
                                FocusScope.of(context)
                                    .requestFocus(dishPriceFocusNode);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            controller: dishSellingAmountTextController,
                            focusNode: dishSellingAmountFocusNode,
                            keyboardType:
                                const TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: <TextInputFormatter>[
                              // up to 3 decimals
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,3}')),
                            ],
                            decoration: const InputDecoration(
                              labelText: "Selling Unit amount",
                              hintText: "Enter value of selling amount",
                              errorMaxLines: 3,
                            ),
                            validator: (value) {
                              if (selectedMeasuringUnits != null ||
                                  inputMenuVariationsValue.value ==
                                      MenuVariations.simple) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter selling amount';
                                }
                              }
                              return null;
                            },
                            onFieldSubmitted: (value) {
                              FocusScope.of(context).requestFocus(dishPriceFocusNode);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    dishNameTextController?.dispose();
    dishNameFocusNode?.dispose();
    dishPriceTextController?.dispose();
    dishPriceFocusNode?.dispose();
    foodTypeFocusNode?.dispose();
    foodMeasuringUnitsFocusNode?.dispose();
    dishSellingUnitTextController?.dispose();
    dishSellingUnitFocusNode?.dispose();
    dishSellingAmountTextController?.dispose();
    dishSellingAmountFocusNode?.dispose();
    super.dispose();
  }

  Widget advanceSelectPriceWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        // Skeletonizer(
        //   child: ListView.builder(
        //     addRepaintBoundaries: true,
        //     addAutomaticKeepAlives: false,
        //     physics: const NeverScrollableScrollPhysics(),
        //     shrinkWrap: true,
        //     itemBuilder: (context, index) {
        //       return Container();
        //     },
        //   ),
        // )
      ],
    );
  }
}
