import 'package:coozy_cafe/model/category.dart';
import 'package:coozy_cafe/model/sub_category.dart';
import 'package:coozy_cafe/routing/routs.dart';
import 'package:coozy_cafe/utlis/utlis.dart';
import 'package:flutter/services.dart';

class NavigationRoutes {
  NavigationRoutes._();

  factory NavigationRoutes.getInstance() => _instance;
  static final NavigationRoutes _instance = NavigationRoutes._();

  goBack() {
    navigatorKey.currentState!.pop();
  }

  goBackToExitApp() {
    try {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    } catch (e) {
      SystemNavigator.pop();
    }
  }

  navigateToHomePage() {
    navigatorKey.currentState!
        .pushNamedAndRemoveUntil(RouteName.homeScreenRoute, (route) => false);
  }

  navigateToTableInfoScreen() {
    navigatorKey.currentState!.pushNamed(RouteName.tableInfoScreenRoute);
  }

  navigateToMenuFullListScreen() {
    navigatorKey.currentState!.pushNamed(RouteName.menuFullListScreenRoute);
  }

  navigateToMenuCategoryFullListScreen() {
    navigatorKey.currentState!.pushNamed(RouteName.menuCategoryFullListRoute);
  }

  Future navigateToAddNewMenuCategoryScreen() async {
    return await navigatorKey.currentState!
        .pushNamed(RouteName.addNewMenuCategoryScreenRoute);
  }

  Future navigateToUpdateMenuCategoryScreen(
      {required Category? category, required List<SubCategory>? subCategoryList}) async {
    String arg =
        UpdateMenuCategoryScreenArgument.updateMenuCategoryScreenArgument(
            category: category, subCategoryList: subCategoryList);
    Constants.debugLog(NavigationRoutes,
        "UpdateMenuCategoryScreen:arguments:${arg.toString()}");
    return await navigatorKey.currentState!
        .pushNamed(RouteName.updateMenuCategoryScreenRoute, arguments: arg);
  }
}
