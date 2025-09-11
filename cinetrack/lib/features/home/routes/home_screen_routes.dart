import 'package:cinetrack/features/home/home_screen.dart';
import 'package:flutter/material.dart';

class HomeScreenRoutes {
  static const String home = '/home';
  static final Map<String, Widget Function(BuildContext)> routes = {
    home: (context) => const HomeScreen(),
  };
}
