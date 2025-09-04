import 'package:cinetrack/features/home/home_screen.dart';
import 'package:flutter/material.dart';

class HomeScreenRoutes {
  static final Map<String, Widget Function(BuildContext)> routes = {
    '/': (context) => const HomeScreen(),
  };
}