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
    // parsing seguro: ratingAverage pode ser int/double/string; ratingCount pode ser int/double/string/nulo
    final oldAvgRaw = data['ratingAverage'] ?? 0;
    final oldAvg = oldAvgRaw is num ? (oldAvgRaw).toDouble() : double.tryParse(oldAvgRaw?.toString() ?? '') ?? 0.0;
    final oldCountRaw = data['ratingCount'] ?? 0;
    final oldCount = oldCountRaw is num ? (oldCountRaw).toInt() : int.tryParse(oldCountRaw?.toString() ?? '') ?? 0;

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
    final oldAvgRaw = data['ratingAverage'] ?? 0;
    final oldAvg = oldAvgRaw is num ? (oldAvgRaw).toDouble() : double.tryParse(oldAvgRaw?.toString() ?? '') ?? 0.0;
    final countRaw = data['ratingCount'] ?? 0;
    final count = countRaw is num ? (countRaw).toInt() : int.tryParse(countRaw?.toString() ?? '') ?? 0;

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

  /// deleta uma avaliação e atualiza os agregados do movie
  Future<void> deleteRatingAndUpdateMovie(String ratingId) async {
    // 1) busca avaliação antiga
    final old = await _ratingRepository.getRatingById(ratingId);
    if (old == null) {
      // nada a fazer
      return;
    }

    // 2) deleta a avaliação
    await _ratingRepository.deleteRating(ratingId: ratingId);

    // 3) atualiza agregados do filme
    final movieSnap = await _movieRepository.getMovieSnapshot(old.movieId);
    final data = movieSnap.data() ?? <String, dynamic>{};
    final oldAvgRaw = data['ratingAverage'] ?? 0;
    final oldAvg = oldAvgRaw is num
        ? (oldAvgRaw).toDouble()
        : double.tryParse(oldAvgRaw?.toString() ?? '') ?? 0.0;
    final countRaw = data['ratingCount'] ?? 0;
    final oldCount = countRaw is num
        ? (countRaw).toInt()
        : int.tryParse(countRaw?.toString() ?? '') ?? 0;

    final newCount = (oldCount - 1) < 0 ? 0 : (oldCount - 1);
    final newAvg = newCount == 0
        ? 0.0
        : (oldAvg * oldCount - old.rating) / newCount;

    await _movieRepository.updateAggregates(old.movieId, newAvg, newCount);
  }
}
