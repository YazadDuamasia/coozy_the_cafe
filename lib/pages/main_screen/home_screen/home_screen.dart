import 'package:animations/animations.dart';
import 'package:coozy_cafe/bloc/bloc.dart';
import 'package:coozy_cafe/pages/main_screen/home_screen/home_screen_drawer.dart';
import 'package:coozy_cafe/utlis/utlis.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  Size? size;
  Orientation? orientation;
  DateTime? currentBackPressTime;
  final GlobalKey<ScaffoldState>? _scaffoldKey = GlobalKey<ScaffoldState>();
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
                  if (_scaffoldKey!.currentState!.isDrawerOpen) {
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
                tabAlignment: TabAlignment.fill,
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
                    onSelected: (value) {
                      print(value);
                    },
                    itemBuilder: (BuildContext bc) {
                      return const [
                        PopupMenuItem(
                          child: Text("Backup"),
                          value: 'backup',
                        ),
                        PopupMenuItem(
                          child: Text("Export"),
                          value: 'export',
                        ),
                        PopupMenuItem(
                          child: Text("Restore"),
                          value: 'restore',
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
    );
  }

  @override
  void dispose() {
    super.dispose();
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
                style: Theme.of(context).textTheme.subtitle2),
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
}
