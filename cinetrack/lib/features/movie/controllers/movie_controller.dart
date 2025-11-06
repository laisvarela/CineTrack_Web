import 'package:cinetrack/features/movie/models/movie_model.dart';
import 'package:cinetrack/features/movie/repositories/movie_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final movieControllerProvider = FutureProvider.autoDispose<List<MovieModel>>((ref) {
  return ref.watch(movieRepositoryProvider).getMovieList();
});

final movieRepositoryProvider = Provider<MovieRepository>((ref) {
  return MovieRepository();
});
