
import 'package:cinetrack/features/rating/models/create_rating_model.dart';

import 'package:cinetrack/features/rating/models/update_rating_model.dart';
import 'package:cinetrack/features/rating/repositories/rating_repository.dart';
import 'package:cinetrack/features/movie/repositories/movie_repository.dart';

class RatingService {
  final RatingRepository _ratingRepository;
  final MovieRepository _movieRepository;

  RatingService({RatingRepository? ratingRepo, MovieRepository? movieRepo})
    : _ratingRepository = ratingRepo ?? RatingRepository(),
      _movieRepository = movieRepo ?? MovieRepository();

  /// cria rating (async) e atualiza agregados do movie em duas operações separadas.
  Future<void> createRatingAndUpdateMovie(CreateRatingModel rating) async {
    await _ratingRepository.createRating(rating: rating);

    // lê o documento do filme para obter agregados atuais
    final movieSnap = await _movieRepository.getMovieSnapshot(rating.movieId);
    final data = movieSnap.data() ?? <String, dynamic>{};
    final oldAvg = (data['ratingAverage'] ?? 0).toDouble();
    final oldCount = (data['ratingCount'] ?? 0) as int;

    final newCount = oldCount + 1;
    final newAvg = (oldAvg * oldCount + rating.rating) / newCount;

    await _movieRepository.updateAggregates(rating.movieId, newAvg, newCount);
  }

  /// atualiza uma avaliação existente e ajusta os agregados do filme (sem transaction).
  /// Requer que RatingRepository tenha métodos: getRatingById(id) -> RatingModel e updateRating(rating).
  Future<void> updateRatingAndUpdateMovie(
    UpdateRatingModel updatedRating,
  ) async {
    // 1) busca avaliação antiga
    final old = await _ratingRepository.getRatingById(updatedRating.id);
    if (old == null)
      throw Exception('Avaliação não encontrada: ${updatedRating.id}');

    // 2) atualiza documento da avaliação
    await _ratingRepository.updateRating(rating: updatedRating);

    // 3) lê agregados atuais do filme
    final movieSnap = await _movieRepository.getMovieSnapshot(
      updatedRating.movieId,
    );
    final data = movieSnap.data() ?? <String, dynamic>{};
    final oldAvg = (data['ratingAverage'] ?? 0).toDouble();
    final count = (data['ratingCount'] ?? 0) as int;

    // proteção: se count == 0, recalcule lendo todas as avaliações ou defina newAvg = updatedRating.rating
    final newAvg = count == 0
        ? updatedRating.rating
        : (oldAvg * count - old.rating + updatedRating.rating) / count;

    await _movieRepository.updateAggregates(
      updatedRating.movieId,
      newAvg,
      count,
    );
  }
}
