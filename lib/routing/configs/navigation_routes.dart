import 'package:coozy_cafe/model/recipe_model.dart';
import 'package:coozy_cafe/routing/routs.dart';
import 'package:coozy_cafe/utlis/utlis.dart';
import 'package:flutter/services.dart';

class NavigationRoutes {
  NavigationRoutes._();

/*
 // Push a new route onto the navigation stack
  context.go('/newRoute');

// Replace the current route with a new route
  context.go('/newRoute', replaceCurrent: true);

// Pop the current route from the navigation stack
  context.pop();

// Pop until a specific route is reached
  context.popUntil((state) => state.name == '/stopRoute');

// Push a new route onto the navigation stack and remove all previous routes
  context.go('/newRoute');
  context.popUntil((state) => state.name == '/newRoute');

// Replace the current route with a new route
  context.go('/newRoute', replaceCurrent: true);
  */

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

  navigateToLoginRoute() {
    navigatorKey.currentState!
        .pushNamedAndRemoveUntil(RouteName.loginRoute, (route) => false);
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

  Future navigateToUpdateMenuCategoryScreen({required categoryId}) async {
    String arg =
        UpdateMenuCategoryScreenArgument.updateMenuCategoryScreenArgument(
            categoryId: categoryId);
    Constants.debugLog(NavigationRoutes,
        "UpdateMenuCategoryScreen:arguments:${arg.toString()}");
    return await navigatorKey.currentState!
        .pushNamed(RouteName.updateMenuCategoryScreenRoute, arguments: arg);
  }

  Future navigateToMenuAllSubCategoryFullListScreen() async {
    return await navigatorKey.currentState!
        .pushNamed(RouteName.menuAllSubCategoryScreenRoute);
  }

  navigateToLoginPage({isFirstTime}) {
    navigatorKey.currentState!.pushNamedAndRemoveUntil(
      RouteName.loginRoute,
      arguments: isFirstTime,
      (route) => false,
    );
  }

  navigateToSignUpPage() {
    navigatorKey.currentState!.pushNamed(RouteName.registrationRoute);
  }

  navigateToOtpVerificationPage({String? arguments}) {
    navigatorKey.currentState!
        .pushNamed(RouteName.otpVerificationRoute, arguments: arguments);
  }

  navigateToSignInViaPhoneNumberPage({bool? isForLogin}) {
    navigatorKey.currentState!.pushNamed(RouteName.loginViaPhoneNumberRoute,
        arguments: isForLogin ?? false);
  }

  void navigateToRecipesScreen() {
    navigatorKey.currentState!.pushNamed(RouteName.recipesListScreenRoute);
  }

  void navigateToRecipesInfoScreen(RecipeModel arguments) {
    navigatorKey.currentState!.pushNamed(RouteName.recipesInfoScreenRoute,arguments: arguments);
  }
}
