import 'package:coozy_cafe/routing/routs.dart';
import 'package:flutter/material.dart';

final navigationRoutes = NavigationRoutes.getInstance();

final bucketGlobal = PageStorageBucket();

final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey<NavigatorState>(debugLabel: "navigatorKey");
