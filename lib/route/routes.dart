import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jiayuan/page/login_page/login_page.dart';
import 'package:jiayuan/page/start_page.dart';
import 'package:jiayuan/route/route_path.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePath.startPage:
        return pageRoute(StartPage());
      case RoutePath.loginPage:
        return pageRoute(LoginPage());
    }
    return pageRoute(Scaffold(
      body: SafeArea(
        child: Center(
          child: Text("route path ${settings.name} is not found"),
        ),
      ),
    ));
  }

  static MaterialPageRoute pageRoute(
    Widget page, {
    RouteSettings? settings,
    bool? fullscreenDialog,
    bool? maintainState,
    bool? allowSnapshotting,
  }) {
    return MaterialPageRoute(
        builder: (context) {
          return page;
        },
        settings: settings,
        fullscreenDialog: fullscreenDialog ?? false,
        maintainState: maintainState ?? true,
        allowSnapshotting: allowSnapshotting ?? true);
  }
}
