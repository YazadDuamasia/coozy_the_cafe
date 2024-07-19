import 'dart:core';

import 'package:coozy_the_cafe/AppLocalization.dart';
import 'package:coozy_the_cafe/bloc/menu_category_full_list_cubit/menu_category_full_list_cubit.dart';
import 'package:coozy_the_cafe/model/category.dart';
import 'package:coozy_the_cafe/model/menu_item.dart';
import 'package:coozy_the_cafe/model/sub_category.dart';
import 'package:coozy_the_cafe/repositories/components/restaurant_repository.dart';
import 'package:coozy_the_cafe/utlis/utlis.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

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
  TextEditingController? dishDescriptionTextController =
      TextEditingController(text: "");
  FocusNode? disDescriptionFocusNode =
      FocusNode(debugLabel: "dish_description_focus_node");

  FocusNode? foodTypeFocusNode = FocusNode(debugLabel: "food_type_focus_node");
  FocusNode? foodMeasuringUnitsFocusNode =
      FocusNode(debugLabel: "food_measuring_units_focus_node");

  TextEditingController? dishSellingUnitTextController =
      TextEditingController(text: "");
  FocusNode? dishSellingUnitFocusNode =
      FocusNode(debugLabel: "dish_selling_unit_focus_node");

  TextEditingController? dishPriceTextController =
      TextEditingController(text: "");
  FocusNode? dishPriceFocusNode =
      FocusNode(debugLabel: "dish_price_focus_node");

  TextEditingController? dishSellingAmountTextController =
      TextEditingController(text: "");
  FocusNode? dishSellingAmountFocusNode =
      FocusNode(debugLabel: "dish_selling_unit_focus_node");

  TextEditingController dishDurationTextController =
      TextEditingController(text: "");
  FocusNode dishDurationFocusNode =
      FocusNode(debugLabel: "dish_duration_focus_node");

  Duration _selectedDuration = const Duration(hours: 0, minutes: 0, seconds: 0);

  void _showDurationPicker(BuildContext context) async {
    showTimePicker(
      context,
      _selectedDuration,
      (Duration? pickedDuration) {
        print(pickedDuration);
        if (pickedDuration != null) {
          setState(() {
            _selectedDuration = pickedDuration;
            dishDurationTextController.text =
                _formatDuration(_selectedDuration);
          });
        }
      },
    );
  }

  String _formatDuration(Duration duration) {
    return "${duration.inHours.toString().padLeft(2, '0')}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}";
  }

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
  ValueNotifier<bool> _isTodayAvailableValue = ValueNotifier<bool>(false);
  double? simple_menu_variations_profit_margin = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await initialData();
    });
    dishPriceTextController!.addListener(_updateProfitMargin);
    dishSellingAmountTextController!.addListener(_updateProfitMargin);
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
                  FocusManager.instance.primaryFocus?.unfocus();
                  final isValid = _formKey.currentState?.validate();
                  if (!isValid!) {
                    return;
                  }
                  _formKey.currentState?.save();
                  MenuItem menuItem = MenuItem().copyWith(
                    creationDate: DateUtil.dateToString(
                        DateTime.now(), DateUtil.DATE_FORMAT15),
                    categoryId: selectedCategory?.id,
                    subcategoryId: selectedSubCategory?.id,
                    isSimpleVariation:
                        inputMenuVariationsValue.value == MenuVariations.simple
                            ? true
                            : false,
                    name: dishNameTextController?.text.toString() ?? null,
                    description:
                        dishDescriptionTextController?.text.toString() ?? null,
                    sellingPrice: dishSellingAmountTextController!.text == null
                        ? null
                        : double.tryParse(
                            dishSellingAmountTextController!.text ?? ""),
                    stockQuantity:
                        inputMenuVariationsValue.value == MenuVariations.simple
                            ? null
                            : 0,
                    purchaseUnit: "$selectedMeasuringUnits",
                    quantity: selectedMeasuringUnits == "Unit"
                        ? "1"
                        : dishSellingUnitTextController?.text ?? null,
                    costPrice:
                        inputMenuVariationsValue.value == MenuVariations.simple
                            ? double.tryParse(
                                dishPriceTextController?.text ?? "0.0")
                            : null,
                    isTodayAvailable: _isTodayAvailableValue.value,
                    foodType: selectedFoodType ?? "",
                    duration: _selectedDuration == null
                        ? 0
                        : _selectedDuration.inSeconds,
                  );

                  Constants.debugLog(AddEditMenuItemScreen,
                      "Add:menuItem:${menuItem.toJson()}");

                  final res = await RestaurantRepository().createMenuItem(menuItem);

                  Constants.customAutoDismissAlertDialog(
                      classObject: AddEditMenuItemScreen,
                      context: context,
                      descriptions: AppLocalizations.of(context)
                          ?.translate(StringValue.add_edit_menu_item_screen_create_successfully) ??
                          "Menu item has been created successfully.",
                      title: "",
                      titleIcon: Lottie.asset(
                        MediaQuery.of(context).platformBrightness ==
                            Brightness.light
                            ? StringImagePath.done_light_brown_color_lottie
                            : StringImagePath.done_brown_color_lottie,
                        repeat: false,
                      ),
                      navigatorKey: navigatorKey);

                  Constants.debugLog(AddEditMenuItemScreen,
                      "res:${res}");
                },
                style: TextButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  "Add",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics()),
            child: Theme(
              data: Theme.of(context),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  key: _formKey,
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
                                Future.microtask(() => FocusScope.of(context)
                                    .requestFocus(disDescriptionFocusNode));
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: dishDescriptionTextController,
                              focusNode: disDescriptionFocusNode,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.none,
                              minLines: 3,
                              maxLines: null,
                              decoration: const InputDecoration(
                                labelText: "Dish Description",
                                hintText: "Enter dish description",
                                errorMaxLines: 3,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter dish description';
                                }
                                return null;
                              },
                              onFieldSubmitted: (value) {
                                Future.microtask(() => FocusScope.of(context)
                                    .requestFocus(FocusNode()));
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              controller: dishDurationTextController,
                              focusNode: dishDurationFocusNode,
                              readOnly: true,
                              onTap: () => _showDurationPicker(context),
                              decoration: const InputDecoration(
                                  labelText: "Cooking Durations",
                                  hintText:
                                      'Select cooking Duration (H:M:S) Approx'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      foodTypeWidget(),
                      const SizedBox(
                        height: 5,
                      ),
                      categoryDropdownWidget(),
                      Visibility(
                        visible: selectedCategory != null,
                        child: subCategoryDropdownWidget(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Expanded(
                            child: ValueListenableBuilder<bool>(
                              valueListenable: _isTodayAvailableValue,
                              builder: (context, value, child) {
                                return Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.0),
                                    border: Border.all(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5.0),
                                    child: SwitchListTile(
                                      contentPadding: const EdgeInsets.only(
                                          left: 10, right: 5),
                                      visualDensity:
                                          VisualDensity.adaptivePlatformDensity,
                                      title: Text(
                                        "${AppLocalizations.of(context)!.translate(StringValue.today_available) ?? "Today Available"}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                      value: value,
                                      onChanged: (newValue) {
                                        _isTodayAvailableValue.value = newValue;
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),

                      toogle_simple_widget(),
                      measuringUnitsWidget(),
                      // ValueListenableBuilder<MenuVariations>(
                      //   valueListenable: inputMenuVariationsValue,
                      //   builder: (context, value, child) {
                      //     if (value == MenuVariations.simple)
                      //       return measuringUnitsWidget();
                      //     else
                      //       return advanceSelectPriceWidget();
                      //   },
                      // ),
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
                child: Text(AppLocalizations.of(context)?.translate(
                        StringValue.menu_category_add_new_category) ??
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
                        menuMaxHeight:
                            MediaQuery.of(context).size.height * 0.35,
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
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: dishSellingUnitTextController,
                              focusNode: dishSellingUnitFocusNode,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
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
                                Future.microtask(() => FocusScope.of(context)
                                    .requestFocus(dishPriceFocusNode));
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: dishPriceTextController,
                            focusNode: dishPriceFocusNode,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            inputFormatters: <TextInputFormatter>[
                              // up to 3 decimals
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,3}')),
                            ],
                            decoration: const InputDecoration(
                              labelText: "Cost price",
                              hintText: "Enter value of costing amount",
                              errorMaxLines: 3,
                            ),
                            validator: (value) {
                              if (selectedMeasuringUnits != null ||
                                  inputMenuVariationsValue.value ==
                                      MenuVariations.simple) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter costing amount';
                                }
                              }
                              return null;
                            },
                            onFieldSubmitted: (value) {
                              FocusScope.of(context)
                                  .requestFocus(dishSellingAmountFocusNode);
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
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
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            controller: dishSellingAmountTextController,
                            focusNode: dishSellingAmountFocusNode,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
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
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: 'Profit Margin: ',
                        style: Theme.of(context).textTheme.bodyMedium,
                        children: <TextSpan>[
                          TextSpan(
                            text:
                                '${simple_menu_variations_profit_margin!.toStringAsFixed(2)}%',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: simple_menu_variations_profit_margin! <
                                          0
                                      ? Colors.red
                                      : simple_menu_variations_profit_margin! ==
                                              0
                                          ? null
                                          : Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _updateProfitMargin() {
    setState(() {
      simple_menu_variations_profit_margin = calculateProfitMargin();
    });
  }

  double? calculateProfitMargin() {
    final dishPriceText = dishPriceTextController!.text;
    final dishSellingAmountText = dishSellingAmountTextController!.text;
    Constants.debugLog(AddEditMenuItemScreen,"calculateProfitMargin:cost_price:$dishPriceText");
    Constants.debugLog(AddEditMenuItemScreen,"calculateProfitMargin:selling_price:$dishSellingAmountText");

    final dishPrice = double.tryParse(dishPriceText) ?? 0.0;
    final dishSellingAmount = double.tryParse(dishSellingAmountText) ?? 0.0;
    Constants.debugLog(AddEditMenuItemScreen,"CP_amt:$dishPrice");
    Constants.debugLog(AddEditMenuItemScreen,"SP_amt:$dishSellingAmount");

    if (dishPrice == 0.0) {
      // Avoid division by zero
      return 0.00;
    }

    if (dishSellingAmount == 0.0) {
      // Avoid division by zero
      return 0.00;
    }

    final profit = dishSellingAmount - dishPrice;
    final profitMargin = (profit / dishSellingAmount) * 100;

    return profitMargin;
  }

  @override
  void dispose() {
    dishPriceTextController?.removeListener(_updateProfitMargin);
    dishSellingAmountTextController?.removeListener(_updateProfitMargin);
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
    return const Row(
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

  void showTimePicker(BuildContext context, Duration initialDuration,
      Function(Duration?) onDurationPicked) {
    showModalBottomSheet(
      context: context,
      elevation: 5,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10.0),
          bottom: Radius.circular(0.0),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (BuildContext builder) {
        Duration? selectedDuration = initialDuration;

        return SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.35,
          child: Column(
            children: [
              // Buttons row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    child: Text(AppLocalizations.of(context)
                            ?.translate(StringValue.common_cancel) ??
                        "Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text(AppLocalizations.of(context)
                            ?.translate(StringValue.common_done) ??
                        "Done"),
                    onPressed: () {
                      onDurationPicked(selectedDuration);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              // Timer picker
              Expanded(
                child: CupertinoTimerPicker(
                  mode: CupertinoTimerPickerMode.hms,
                  initialTimerDuration: initialDuration,
                  onTimerDurationChanged: (Duration duration) {
                    selectedDuration = duration;
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
