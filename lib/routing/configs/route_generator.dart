import 'package:coozy_cafe/pages/main_screen/menu_all_sub_category_screen/menu_all_sub_category_screen.dart';
import 'package:coozy_cafe/pages/main_screen/menu_category_screen/add_menu_category_screen/add_new_menu_category_screen.dart';
import 'package:coozy_cafe/pages/main_screen/menu_category_screen/edit_menu_category/edit_menu_category_screen.dart';
import 'package:coozy_cafe/pages/main_screen/menu_category_screen/menu_category_full_list_screen.dart';
import 'package:coozy_cafe/pages/main_screen/menu_screen/menu_full_list_screen.dart';
import 'package:coozy_cafe/pages/main_screen/recipes_list_screen/recipes_list_screen.dart';
import 'package:coozy_cafe/pages/main_screen/table_screen/table_screen.dart';
import 'package:coozy_cafe/pages/pages.dart';
import 'package:coozy_cafe/pages/startup_screens/login_screen/login_screen.dart';
import 'package:coozy_cafe/pages/startup_screens/login_via_phone_number_page/login_via_phone_number_page.dart';
import 'package:coozy_cafe/pages/startup_screens/otp_verification_page/otp_verification_page.dart';
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

      case RouteName.loginViaPhoneNumberRoute:
        bool? isForLogin = args as bool;
        return PageTransition(
          type: PageTransitionType.rightToLeftWithFade,
          settings: settings,
          curve: Curves.easeInOut,
          child: LoginViaPhoneNumberPage(
            isUseForLogin: isForLogin,
          ),
        );

      case RouteName.otpScreenRoute:
        bool? isForLogin = args as bool;
        return PageTransition(
          type: PageTransitionType.rightToLeftWithFade,
          settings: settings,
          curve: Curves.easeInOut,
          child: LoginViaPhoneNumberPage(
            isUseForLogin: isForLogin,
          ),
        );

      case RouteName.otpScreenRoute:
        bool? isForLogin = args as bool;
        return PageTransition(
          type: PageTransitionType.rightToLeftWithFade,
          settings: settings,
          curve: Curves.easeInOut,
          child: LoginViaPhoneNumberPage(
            isUseForLogin: isForLogin,
          ),
        );

      case RouteName.otpVerificationRoute:
        OtpVerificationScreenArgument otpVerificationScreenArgument =
            otpVerificationScreenArgumentFromMap(args.toString());
        return PageTransition(
          type: PageTransitionType.rightToLeftWithFade,
          settings: settings,
          curve: Curves.easeInOut,
          child: OtpVerificationPage(
            phoneNumber: otpVerificationScreenArgument.phoneNumber,
            otpNumber: otpVerificationScreenArgument.otpNumber,
            appSignature: otpVerificationScreenArgument.appSignature,
            customerID: otpVerificationScreenArgument.customerID,
            isForgetPassword: otpVerificationScreenArgument.isForgetPassword,
            isLoginScreen: otpVerificationScreenArgument.isLoginScreen,
          ),
        );

      case RouteName.loginRoute:
        return PageTransition(
          type: PageTransitionType.rightToLeftWithFade,
          settings: settings,
          curve: Curves.easeInOut,
          child: LoginScreen(
            isFirstTime: args as bool?,
          ),
        );


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
          child: const MenuFullListScreen(),
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
            categoryId: argument.categoryId,
          ),
        );

      case RouteName.menuAllSubCategoryScreenRoute:
        return PageTransition(
          type: PageTransitionType.rightToLeftWithFade,
          settings: settings,
          curve: Curves.easeInOut,
          child: MenuAllSubCategoryScreen(),
        );
        case RouteName.recipesListScreenRoute:
        return PageTransition(
          type: PageTransitionType.rightToLeftWithFade,
          settings: settings,
          curve: Curves.easeInOut,
          child: RecipesListScreen(),
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
