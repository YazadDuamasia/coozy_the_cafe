import 'dart:io';

import 'package:animations/animations.dart';
import 'package:coozy_the_cafe/AppLocalization.dart';
import 'package:coozy_the_cafe/bloc/bloc.dart';
import 'package:coozy_the_cafe/pages/main_screen/home_screen/home_screen_drawer.dart';
import 'package:coozy_the_cafe/pages/main_screen/waiter_screen/waiter_screen.dart';
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

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  Size? size;
  Orientation? orientation;
  DateTime? currentBackPressTime;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var key = UniqueKey();
  List<Widget>? mobileListView;

  late TabController _tabController;
  int _currentIndex = 0;

  @override
  void initState() {


    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      mobileListView = [
        // HomePage(scrollController: scrollController),
        WaiterScreen(),
        Container(),
        Container(),
      ];

      _tabController = TabController(length: 3, vsync: this);
      _tabController.addListener(() {
        setState(() {
          _currentIndex = _tabController.index;
          Constants.debugLog(HomeScreen, "_currentIndex:$_currentIndex");
        });
      });
      BlocProvider.of<TableScreenBloc>(context).add(LoadTableScreenDataEvent());
    });

    // _processCsvToJson();
  }

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
                  controller: _tabController,
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
                  Visibility(
                    visible: _tabController.index == 0 ? true : false,
                    child: BlocConsumer<TableScreenBloc, TableScreenState>(
                      listener: (context, state) {},
                      builder: (context, state) {
                        if (state is TableScreenLoadedState) {
                          return IconButton(
                            onPressed: () async {
                              context
                                  .read<TableScreenBloc>()
                                  .add(SwitchViewTableInfoEvent());
                            },
                            icon: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 500),
                              child: (state.isGridView ?? false)
                                  ? Icon(
                                      Icons.list,
                                      color: Colors.white,
                                      key: ValueKey('list'),
                                    )
                                  : Icon(
                                      Icons.grid_view,
                                      color: Colors.white,
                                      key: ValueKey('grid'),
                                    ),
                            ),
                            tooltip: (state.isGridView ?? false)
                                ? (AppLocalizations.of(context)?.translate(
                                        StringValue
                                            .common_list_view_tooltip) ??
                                    "Switch to List View")
                                : (AppLocalizations.of(context)?.translate(
                                        StringValue
                                            .common_grid_view_tooltip) ??
                                    "Switch to Grid View"),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                  ),
                  Theme(
                    data: Theme.of(context),
                    child: PopupMenuButton(
                      onSelected: (value) async {
                        print(value);
                        if (value == "clear_data") {
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
                controller: _tabController,
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

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
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
