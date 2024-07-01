import 'dart:io';

import 'package:animations/animations.dart';
import 'package:coozy_the_cafe/bloc/bloc.dart';
import 'package:coozy_the_cafe/pages/main_screen/home_screen/home_screen_drawer.dart';
import 'package:coozy_the_cafe/utlis/utlis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  Size? size;
  Orientation? orientation;
  DateTime? currentBackPressTime;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var key = UniqueKey();
  List<Widget>? mobileListView;

  @override
  void initState() {
    mobileListView = [
      // HomePage(scrollController: scrollController),
      Container(),
      Container(),
      Container(),
    ];

    super.initState();

    // _processCsvToJson();
  }

  /* Future<void> _processCsvToJson() async {
    try {
      String jsonContent = await rootBundle.loadString("assets/data/recipes_for_indian_food_dataset.json");
      List<dynamic> jsonArray = json.decode(jsonContent);

      // Create a new list to store modified objects
      List<Map<String, dynamic>> modifiedJsonArray = [];

      // Define a map to store key renaming mappings
      Map<String, String> keyMappings = {
        "Srno": "id",
        "RecipeName": "recipe_name",
        "TranslatedRecipeName": "translated_recipe_name",
        "Ingredients": "recipe_ingredients",
        "TranslatedIngredients": "recipe_translated_ingredients",
        "PrepTimeInMins": "recipe_preparation_time_in_mins",
        "CookTimeInMins": "recipe_cooking_time_in_mins",
        "TotalTimeInMins": "recipe_total_time_in_mins",
        "Servings": "recipe_servings",
        "Cuisine": "recipe_cuisine",
        "Course": "recipe_course",
        "Diet": "recipe_diet",
        "Instructions": "recipe_instructions",
        "TranslatedInstructions": "recipe_translated_instructions",
        "URL\r": "recipe_reference_url"
      };

      // Iterate through each object in the array
      for (var jsonObject in jsonArray) {
        // Create a new map for storing renamed key-value pairs for the current object
        Map<String, dynamic> modifiedJsonObject = {};

        // Iterate through each key-value pair in the current object
        // and rename keys using the keyMappings
        jsonObject.forEach((key, value) {
          // Look up the new key name from keyMappings
          String? newKey = keyMappings[key];

          // If new key is found, add it to the modifiedJsonObject
          if (newKey != null) {
            modifiedJsonObject[newKey] = value;
          }
        });

        // Add the modified object to the list
        modifiedJsonArray.add(modifiedJsonObject);
      }

      // Convert the modified data back to JSON
      String modifiedJsonContent = json.encode(modifiedJsonArray);

      // Print the modified JSON
      print(modifiedJsonContent);
      await FileStorage.writeCounter(modifiedJsonContent, "recipes_for_indian_food_dataset.json");
    */ /*  // Read the CSV file from assets
      String csvString =
      await rootBundle.loadString("assets/data/IndianFoodDatasetCSV.csv");

      // Convert CSV to List of Lists
      List<List<dynamic>?>? csvData =
      const CsvToListConverter().convert(csvString, eol: "\n");

      // Convert List of Lists to JSON
      List<Map<String, dynamic>> jsonData = [];
      List<String>? headers = csvData![0]?.cast<String>();
      for (int i = 1; i < csvData.length; i++) {
        Map<String, dynamic> row = {};
        for (int j = 0; j < headers!.length; j++) {
          // Check for null values
          if (csvData[i]![j] != null) {
            row[headers[j]] = csvData[i]![j];
          } else {
            // Handle null values, for example, you can assign a default value
            row[headers[j]] = ""; // Or any default value you prefer
          }
        }
        jsonData.add(row);
      }

      await FileStorage.writeCounter(
          "${jsonEncode(jsonData)}", "recipes_for_indian_food_dataset.json");*/ /*
    } catch (e) {
      print('Error converting CSV to JSON: $e');
    }
  }*/

  Widget buildPageTransitionSwitcher({var list, int? currentIndex}) {
    return PageTransitionSwitcher(
      duration: const Duration(milliseconds: 3000),
      transitionBuilder: (child, primaryAnimation, secondaryAnimation) =>
          FadeThroughTransition(
        animation: primaryAnimation,
        secondaryAnimation: secondaryAnimation,
        child: child,
      ),
      child: list![currentIndex],
    );
  }

  Future<bool> onWillPop() {
    Constants.debugLog(HomeScreen, "WillPopScope");
    if (context.read<HomePageBottomNavCubit>().state != 0) {
      context.read<HomePageBottomNavCubit>().updateIndex(0);
      return Future.value(false);
    } else {
      DateTime now = DateTime.now();
      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
        currentBackPressTime = now;
        Fluttertoast.showToast(
            msg: "Press back again to exit",
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 3);

        return Future.value(false);
      } else {
        onBackPressDialog();
        return Future.value(true);
      }
    }
  }

  onBackPressDialog() {
    if (!Constants.isIOS() && !Constants.isMacOS()) {
      return showDialog(
        context: context,
        builder: (context) => Theme(
          data: Theme.of(context),
          child: AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
            titlePadding: const EdgeInsets.all(10.0),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            buttonPadding: const EdgeInsets.symmetric(horizontal: 10.0),
            title: Text(
              'Are you sure?',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            content: Text('Do you want to exit the app?',
                style: Theme.of(context).textTheme.titleSmall),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => navigationRoutes.goBackToExitApp(),
                child: const Text('Yes'),
              ),
            ],
          ),
        ),
      );
    } else {
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(35.0)),
          ),
          contentPadding: const EdgeInsets.only(top: 10.0),
          title: const Text('Are you sure?'),
          content: const Text('Do you want to exit the app?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      animationDuration: const Duration(milliseconds: 200),
      initialIndex: 0,
      child: SafeArea(
        child: WillPopScope(
          onWillPop: onWillPop,
          child: SafeArea(
            child: Scaffold(
              key: _scaffoldKey,
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                title: const Text(Constants.appName),
                leading: IconButton(
                  icon: const Icon(
                    Icons.menu,
                  ),
                  onPressed: () {
                    if (_scaffoldKey.currentState!.isDrawerOpen) {
                      _scaffoldKey.currentState!.closeDrawer();
                      //close drawer, if drawer is open
                    } else {
                      _scaffoldKey.currentState!.openDrawer();
                      //open drawer, if drawer is closed
                    }
                  },
                ),
                bottom: TabBar(
                  tabs: const <Widget>[
                    Tab(
                      text: 'Waiter',
                    ),
                    Tab(text: 'kitchen'),
                    Tab(text: 'more'),
                  ],
                  indicatorColor: Theme.of(context).dividerColor,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black,
                  unselectedLabelStyle: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                  labelStyle: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                actions: [
                  Theme(
                    data: Theme.of(context),
                    child: PopupMenuButton(
                      onSelected: (value) async {
                        print(value);
                        if(value=="clear_data"){
                          final prefs = await SharedPreferences.getInstance();
                          prefs.clear();

                        }
                      },
                      itemBuilder: (BuildContext bc) {
                        return const [
                          PopupMenuItem(
                            value: 'backup',
                            child: Text("Backup"),
                          ),
                          PopupMenuItem(
                            value: 'export',
                            child: Text("Export"),
                          ),
                          PopupMenuItem(
                            value: 'restore',
                            child: Text("Restore"),
                          ),
                          PopupMenuItem(
                            value: 'clear_data',
                            child: Text("clear data"),
                          )
                        ];
                      },
                      icon: Icon(
                        Icons.more_vert_rounded,
                        size: Theme.of(context).appBarTheme.iconTheme?.size,
                        color: Theme.of(context).appBarTheme.iconTheme?.color,
                      ),
                    ),
                  ),
                ],
              ),
              drawer: const HomeScreenDrawer(),
              body: TabBarView(
                children: [
                  buildPageTransitionSwitcher(
                      list: mobileListView, currentIndex: 0),
                  buildPageTransitionSwitcher(
                      list: mobileListView, currentIndex: 1),
                  buildPageTransitionSwitcher(
                      list: mobileListView, currentIndex: 2),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// To save the file in the device
class FileStorage {
  static Future<String> getExternalDocumentPath() async {
    // To check whether permission is given for this app or not.
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      // If not we will ask for permission first
      await Permission.storage.request();
    }
    Directory _directory = Directory("");
    if (Platform.isAndroid) {
      // Redirects it to download folder in android
      _directory = Directory("/storage/emulated/0/Download");
    } else {
      _directory = await getApplicationDocumentsDirectory();
    }

    final exPath = _directory.path;
    print("Saved Path: $exPath");
    await Directory(exPath).create(recursive: true);
    return exPath;
  }

  static Future<String> get _localPath async {
    // final directory = await getApplicationDocumentsDirectory();
    // return directory.path;
    // To get the external path from device of download folder
    final String directory = await getExternalDocumentPath();
    return directory;
  }

  static Future<File> writeCounter(String bytes, String name) async {
    final path = await _localPath;
    // Create a file for the path of
    // device and file name with extension
    File file = File('$path/$name');
    print("Save file");

    // Write the data in the file you have created
    return file.writeAsString(bytes);
  }
}
