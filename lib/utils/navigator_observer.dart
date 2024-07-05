import 'package:flutter/material.dart';

class PopScopeNavigatorObserver extends NavigatorObserver {
  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    // Handle any additional logic here when a route is popped
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    super.didPush(route, previousRoute);
    // Handle any additional logic here when a route is pushed
  }
}
