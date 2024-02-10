import 'package:coozy_cafe/pages/main_screen/menu_category_screen/add_new_menu_category_screen.dart';
import 'package:coozy_cafe/pages/main_screen/menu_category_screen/edit_menu_category_screen.dart';
import 'package:coozy_cafe/pages/main_screen/menu_category_screen/menu_category_full_list_screen.dart';
import 'package:coozy_cafe/pages/main_screen/menu_screen/menu_full_list_screen.dart';
import 'package:coozy_cafe/pages/main_screen/table_screen/table_screen.dart';
import 'package:coozy_cafe/pages/pages.dart';
import 'package:coozy_cafe/routing/routs.dart';
import 'package:coozy_cafe/utlis/utlis.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  /*
  *
  *  If want to pop all previous routes and move specific screen.
  *  Navigator.of(context).pushNamedAndRemoveUntil(RouteName.homeScreenRoute, (Route<dynamic> route) => false,);
  *
  */

  static Route<dynamic> generateRoute(RouteSettings settings) {
    var args = settings.arguments;
    Constants.debugLog(RouteGenerator, "Route Name:${settings.name}");
    Constants.debugLog(RouteGenerator, "Route arguments:$args");
    switch (settings.name) {
      case '/':
        return MaterialPageRoute<dynamic>(builder: (_) => const SplashScreen());

      case RouteName.splashRoute:
        return MaterialPageRoute<dynamic>(builder: (_) => const SplashScreen());

      case RouteName.homeScreenRoute:
        return PageTransition(
          type: PageTransitionType.rightToLeftWithFade,
          settings: settings,
          curve: Curves.easeInOut,
          child: const HomeScreen(),
        );

      case RouteName.tableInfoScreenRoute:
        return PageTransition(
          type: PageTransitionType.rightToLeftWithFade,
          settings: settings,
          curve: Curves.easeInOut,
          child: const TableScreen(),
        );
      case RouteName.menuFullListScreenRoute:
        return PageTransition(
          type: PageTransitionType.rightToLeftWithFade,
          settings: settings,
          curve: Curves.easeInOut,
          child: MenuFullListScreen(),
        );

      case RouteName.menuCategoryFullListRoute:
        return PageTransition(
          type: PageTransitionType.rightToLeftWithFade,
          settings: settings,
          curve: Curves.easeInOut,
          child: const MenuCategoryFullListScreen(),
        );
      case RouteName.addNewMenuCategoryScreenRoute:
        return PageTransition(
          type: PageTransitionType.rightToLeftWithFade,
          settings: settings,
          curve: Curves.easeInOut,
          child: const AddNewMenuCategoryScreen(),
        );
      case RouteName.updateMenuCategoryScreenRoute:
        UpdateMenuCategoryScreenArgument argument =
            updateMenuCategoryScreenArgumentFromMap(args.toString());
        return PageTransition(
          type: PageTransitionType.rightToLeftWithFade,
          settings: settings,
          curve: Curves.easeInOut,
          child: EditMenuCategoryScreen(
            category: argument.category!,
            subCategoryList: argument.subCategoryList ?? [],
          ),
        );

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute<dynamic>(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
