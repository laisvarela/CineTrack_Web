import 'package:cinetrack/features/movie/controllers/movie_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MovieScreen extends ConsumerStatefulWidget {
  final String? movieId;
  const MovieScreen({super.key, this.movieId});

  @override
  ConsumerState<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  Widget build(BuildContext context) {
    final movies = ref.watch(movieControllerProvider);
    return Scaffold(
      appBar: AppBar(
      
      ),
    );
  }
}
