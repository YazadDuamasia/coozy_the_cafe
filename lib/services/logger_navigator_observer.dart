import 'dart:developer';

import 'package:flutter/material.dart';

class LoggerNavigatorObserver extends NavigatorObserver {

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    log('Pushed route: ${route.settings.name}', name: 'NavigatorObserver');
    if (previousRoute != null) {
      log('Previous route: ${previousRoute.settings.name}', name: 'NavigatorObserver');
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    log('Popped route: ${route.settings.name}', name: 'NavigatorObserver');
    if (previousRoute != null) {
      log('Previous route: ${previousRoute.settings.name}', name: 'NavigatorObserver');
    }
  }

  @override
  void didRemove(Route route, Route? previousRoute) {
    super.didRemove(route, previousRoute);
    log('Removed route: ${route.settings.name}', name: 'NavigatorObserver');
    if (previousRoute != null) {
      log('Previous route: ${previousRoute.settings.name}', name: 'NavigatorObserver');
    }
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) {
      log('Replaced with new route: ${newRoute.settings.name}', name: 'NavigatorObserver');
    }
    if (oldRoute != null) {
      log('Replaced old route: ${oldRoute.settings.name}', name: 'NavigatorObserver');
    }
  }
}
