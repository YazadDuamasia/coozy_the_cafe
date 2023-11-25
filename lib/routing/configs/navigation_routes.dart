import 'package:coozy_cafe/routing/routs.dart';
import 'package:coozy_cafe/utlis/components/global.dart';
import 'package:flutter/material.dart';
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
}
