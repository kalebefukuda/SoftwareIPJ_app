import 'package:flutter/material.dart';

class CustomNavigatorObserver extends NavigatorObserver {
  final Function(String routeName) onRouteChange;

  CustomNavigatorObserver({required this.onRouteChange});

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route.settings.name != null) {
      onRouteChange(route.settings.name!);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute?.settings.name != null) {
      onRouteChange(previousRoute!.settings.name!);
    }
  }
}
