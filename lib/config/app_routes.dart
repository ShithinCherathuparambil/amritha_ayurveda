import 'dart:io';
import 'package:amritha_ayurveda/presentation/screens/auth/sign_in_screen.dart';
import 'package:amritha_ayurveda/presentation/screens/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import '../presentation/screens/auth/sign_up_screen.dart';
import '../presentation/screens/home/home_screen.dart';
import 'slide_right_route.dart';

RouteFactory onAppGenerateRoute() => (settings) {
  Route<dynamic> getRoute(Widget child) {
    if (Platform.isIOS) {
      return CupertinoPageRoute(
        builder: (context) => child,
        settings: settings,
      );
    } else {
      return SlideRightRoute(child, settings.name);
    }
  }

  switch (settings.name) {
    case SplashScreen.route:
      return getRoute(const SplashScreen());
    case HomeScreen.route:
      return getRoute(const HomeScreen());
    case SignInScreen.route:
      return getRoute(const SignInScreen());
    case SignUpScreen.route:
      return getRoute(const SignUpScreen());

    default:
      return null;
  }
};
