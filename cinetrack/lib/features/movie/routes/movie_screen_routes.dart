import 'package:cinetrack/features/movie/movie_screen.dart';
import 'package:flutter/material.dart';

class MovieScreenRoutes {
  static const String movie = '/movie';
  static final Map<String, Widget Function(BuildContext)> routes = {
    movie: (context) => const MovieScreen(),
  };
}
