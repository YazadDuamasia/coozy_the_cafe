import 'dart:convert';

import 'package:coozy_cafe/AppLocalization.dart';
import 'package:coozy_cafe/model/category.dart';
import 'package:coozy_cafe/model/sub_category.dart';
import 'package:coozy_cafe/repositories/repositories.dart';
import 'package:coozy_cafe/utlis/utlis.dart';
import 'package:flutter/material.dart';

class MenuCategoryFullListScreen extends StatefulWidget {
  const MenuCategoryFullListScreen({Key? key}) : super(key: key);

  @override
  _MenuCategoryFullListScreenState createState() =>
      _MenuCategoryFullListScreenState();
}

class _MenuCategoryFullListScreenState
    extends State<MenuCategoryFullListScreen> {
  Size? size;
  Orientation? orientation;
  List<Category>? categoryList = [];
  List<SubCategory>? SubCategoryList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData();
    });
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
          appBar: AppBar(
            title: const Text(
              "Menu Category",
            ),
            leadingWidth: 35,
            centerTitle: false,
            actions: [
              IconButton(
                onPressed: () async {
                  navigationRoutes
                      .navigateToAddNewMenuCategoryScreen()
                      .then((value) async => loadData());
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                tooltip: AppLocalizations.of(context)?.translate(
                        StringValue.add_menu_category_icon_tooltip_text) ??
                    "Add a new menu category",
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      child: Container(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loadData() async {
    setState(() {
      isLoading = true;
    });
    categoryList = await RestaurantRepository().getCategories();
    Constants.debugLog(MenuCategoryFullListScreen, "categoryList:${json.encode(categoryList)}");
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
