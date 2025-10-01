import 'package:flutter/material.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigatorkey =
      GlobalKey<NavigatorState>();
  void removeAndNavigatteToRoute(String route) {
    navigatorkey.currentState!.popAndPushNamed(route);
  }

  void navigateToRoute(String route) {
    navigatorkey.currentState!.pushNamed(route);
  }

  void navigateToPage(Widget page) {
    navigatorkey.currentState!.push(
      MaterialPageRoute(builder: (BuildContext context) => page),
    );
  }



  void goback() {
    navigatorkey.currentState!.pop();
  }
}
