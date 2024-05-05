import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:coozy_cafe/bloc/bloc.dart';
import 'package:coozy_cafe/model/recipe_model.dart';
import 'package:coozy_cafe/pages/pages.dart';
import 'package:coozy_cafe/routing/routs.dart';
import 'package:coozy_cafe/widgets/widgets.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  ThemeCubit? _themeCubit;
  final assetDirectories = ['images'];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        final cubit = context.read<ThemeCubit>();
        cubit.toggleTheme(false);
      },
    );
    super.initState();
    // preloadImages();
    checkFirstTime();
  }

  // Future<void> preloadImages() async {
  //   final appDirectory = await getApplicationDocumentsDirectory();
  //   final packageInfo = await PackageInfo.fromPlatform();
  //   final packageName = packageInfo.packageName;
  //   final assetList = <String>[];
  //
  //   Future<void> addImagesFromDirectory(Directory directory) async {
  //     final assetFiles = directory.listSync();
  //
  //     for (final assetFile in assetFiles) {
  //       if (assetFile is File) {
  //         final assetPath = assetFile.path.replaceFirst(appDirectory.path, '');
  //         assetList.add(assetPath);
  //       } else if (assetFile is Directory) {
  //         await addImagesFromDirectory(
  //             assetFile); // Recursively search subdirectories
  //       }
  //     }
  //   }
  //
  //   for (final directory in assetDirectories) {
  //     final assetDirectory =
  //         Directory('${appDirectory.path}/$packageName/$directory');
  //     await addImagesFromDirectory(assetDirectory);
  //   }
  //   // Preload all assets from the list and handle errors
  //   await Future.forEach(assetList, (asset) async {
  //     try {
  //       await precacheImage(AssetImage(asset), context);
  //     } catch (e) {
  //       Constants.debugLog(SplashScreen, "Error loading image:$asset");
  //     }
  //   });
  // }

  checkFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
/*
    final jsonContent = await rootBundle.loadString("assets/data/recipes_for_indian_food_dataset.json");
    final recipeModel = recipeModelFromJson(jsonContent);

    print("recipeModel:length:${recipeModel.length}");
*/

    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
    print("isFirstTime: $isFirstTime");
    if (isFirstTime) {
      await prefs.setBool('isFirstTime', false);
      Future.delayed(const Duration(seconds: 5)).then(
        (value) => Navigator.pushNamedAndRemoveUntil(
            context, RouteName.loginRoute, arguments: true, (route) => false),
      );
    } else {
      Future.delayed(const Duration(seconds: 5)).then(
        (value) => Navigator.pushNamedAndRemoveUntil(
            context,
            RouteName.homeScreenRoute,
            arguments: false,
            (route) => false),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: true,
      body: ResponsiveLayout(
        mobile: SplashScreenMobileLayout(),
        tablet: SplashScreenTabletLayout(),
        desktop: SplashScreenDesktopLayout(),
      ),
    );
  }
}
