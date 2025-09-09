import 'package:cinetrack/features/auth/routes/auth_routes.dart';
import 'package:flutter/material.dart';
import 'package:cinetrack/features/home/routes/home_screen_routes.dart';
class WebRoutes {
  static final Map<String, Widget Function(BuildContext) > routes = {
    ...HomeScreenRoutes.routes,
    ...AuthRoutes.routes,
  };
}